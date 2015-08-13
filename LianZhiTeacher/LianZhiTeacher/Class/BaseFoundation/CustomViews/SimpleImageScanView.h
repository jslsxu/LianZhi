//
//  SimpleImageScanView.h
//  LianZhiParent
//
//  Created by jslsxu on 15/2/4.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleImageScanView : UIView
{
    UIImageView*        _sourceImageView;
}
- (instancetype)initWithSourceImage:(UIImage *)sourceImage;
- (void)showFromTargetFrame:(CGRect)targetFrame;
@end
