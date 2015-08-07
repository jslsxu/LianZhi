//
//  QRCodeScanVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/5/13.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
@class QRCodeScanVC;
@protocol QRCodeScanDelegate <NSObject>
- (void)qrCodeScanVC:(QRCodeScanVC *)scanVC didFinish:(NSString *)info;
- (void)qrCodeScanVC:(QRCodeScanVC *)scanVC didFailWithError:(NSString *)error;
- (void)qrCodeScanVCDidCancel:(QRCodeScanVC *)scanVC;
@end

@interface QRCodeScanVC : TNBaseViewController<ZBarReaderViewDelegate,ZBarReaderDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSInteger                   count;
    CameraMaskView *            _maskView;
    UIImageView*                _scanLine;
    ZBarReaderView *            _readerView;
}
@property (nonatomic, weak)id<QRCodeScanDelegate> delegate;
@end
