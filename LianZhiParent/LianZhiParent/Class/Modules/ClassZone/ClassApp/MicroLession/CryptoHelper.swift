//
//  CryptoHelper.swift
//  DecryptString
//
//  Created by creatingtech.cn on 06/02/2017.
//  Copyright © 2017 creatingtech.cn. All rights reserved.
//

import UIKit
import CryptoSwift

class CryptoHelper: NSObject {
    public func decrypt(encryptedString: String) -> String {
        let CRYPTO_IV           = "0123456789876543"
        let CRYPTO_PASSWORD     = "9zXvDE3p67VC32jmV78rIYu2017x1aoe"
        
        let aes = try! AES(key: CRYPTO_PASSWORD, iv: CRYPTO_IV, blockMode: .CTR, padding: NoPadding())
    
        do {
            if let data = Data(fromHexEncodedString: encryptedString){
                let decrypted = try aes.decrypt(data)
                let data = NSData(bytes: decrypted, length: decrypted.count)
                let str = String(data:data as Data,encoding: String.Encoding.utf8)
                return str!
//                return String(cString: decrypted)
            }
            else{
                return ""
            }
            
        } catch {
            // deal with error
            return ""
        }
        
        
        
//        print("decrypted filename: \(String(cString: decrypted))")
        
        //return String(cString: decrypted)
    }
}

extension Data {
    
    init?(fromHexEncodedString string: String) {
        
        // Convert 0 ... 9, a ... f, A ...F to their decimal value,
        // return nil for all other input characters
        func decodeNibble(u: UInt16) -> UInt8? {
            switch(u) {
            case 0x30 ... 0x39:
                return UInt8(u - 0x30)
            case 0x41 ... 0x46:
                return UInt8(u - 0x41 + 10)
            case 0x61 ... 0x66:
                return UInt8(u - 0x61 + 10)
            default:
                return nil
            }
        }
        
        self.init(capacity: string.utf16.count/2)
        var even = true
        var byte: UInt8 = 0
        for c in string.utf16 {
            guard let val = decodeNibble(u: c) else { return nil }
            if even {
                byte = val << 4
            } else {
                byte += val
                self.append(byte)
            }
            even = !even
        }
        guard even else { return nil }
    }
}
