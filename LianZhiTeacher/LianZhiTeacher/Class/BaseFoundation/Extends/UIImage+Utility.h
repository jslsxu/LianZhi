//
//  UIImage+Utility.h
//
//  Created by sho yakushiji on 2013/05/17.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+Additions.h"
@interface UIImage (Utility)

+ (UIImage*)fastImageWithData:(NSData*)data;
+ (UIImage*)fastImageWithContentsOfFile:(NSString*)path;

- (UIImage*)deepCopy;
- (UIImage *)formatImage;
+ (UIImage *)formatAsset:(ALAsset *)asset;
- (UIImage*)resize:(CGSize)targetSize;
+ (UIImage *)resize:(CGSize)size withImageRef:(CGImageRef)imageRef;
- (UIImage*)aspectFit:(CGSize)size;
- (UIImage*)aspectFill:(CGSize)size;
- (UIImage*)aspectFill:(CGSize)size offset:(CGFloat)offset;
+ (UIImage *)fixOrientation:(UIImage *)imageSourceTmp;
- (UIImage*)crop:(CGRect)rect;

- (UIImage*)maskedImage:(UIImage*)maskImage;

      //  {blurLevel | 0 ≤ t ≤ 1}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;

+ (UIImage *)coverImageForVideo:(NSURL *)url;
@end
