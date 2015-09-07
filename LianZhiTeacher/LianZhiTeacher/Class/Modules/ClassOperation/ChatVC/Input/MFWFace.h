//
//  MFWFace.h
// MFWIOS
//
//  Created by dong jianbo on 12-5-24.
//  Copyright 2011 mafengwo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EXP_FACE_BEGIN              @"(#"
#define	EXP_FACE_END                @")"

@interface MFWFace : NSObject
{
    NSArray* faces;
}

+ (NSUInteger)numberOfFace; //总共有多少表情
+ (NSString *)faceStringForIndex:(NSUInteger)index; //返回表情锁对应的字符串
+ (NSUInteger)indexForFace:(NSString *)faceString; //根据表情字符串获取表情索引,没有这个表情则返回NSNotFound
+ (CGSize)faceSize; //获取表情size

+ (BOOL) faceInFaces:(NSString *)faceString;

@end
