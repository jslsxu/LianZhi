//
//  UIImageView+Animation.m
//  TravelGuideMdd
//
//  Created by Song Xiaofeng on 13-6-21.
//  Copyright (c) 2013年 mafengwo.com. All rights reserved.
//

#import "UIImageView+Animation.h"


static const char delaySetImageKey;
static const char tmpAnimationViewKey;

@interface UIImageView(AnimationVars)
@property (nonatomic, retain) UIImage *delaySetImage;
@property (nonatomic, assign) UIImageView *tmpAnimationView;
@end

@implementation UIImageView(AnimationVars)
- (UIImage*)delaySetImage
{
    return [self getAssociativeValue:&delaySetImageKey];
}

- (void)setDelaySetImage:(UIImage *)delaySetImage
{
    [self setRetainNonatomicProperty:delaySetImage
                               byKey:&delaySetImageKey];
}

- (UIImageView*)tmpAnimationView
{
    return [self getAssociativeValue:&tmpAnimationViewKey];
}

- (void)setTmpAnimationView:(UIImageView *)tmpAnimationView
{
    [self setRetainNonatomicProperty:tmpAnimationView
                               byKey:&tmpAnimationViewKey];
}
@end

@implementation UIImageView (Animation)

+ (void)load
{
    Method m1 = class_getInstanceMethod(self, @selector(setImage:));
    Method m2 = class_getInstanceMethod(self, @selector(swizzed_setImage:));
    method_exchangeImplementations(m1, m2);
}

- (void)clearTmpAnimation
{
    self.delaySetImage = nil;
    if (self.tmpAnimationView)
    {
        [self.tmpAnimationView removeFromSuperview];
        self.tmpAnimationView = nil;
    }
}

- (void)setImage:(UIImage*)image animated:(BOOL)animated
{
    [self clearTmpAnimation];
    if (!animated) {
        [self swizzed_setImage:image];
    }else{
        CGRect frame = self.bounds;
        UIImageView* imgv = [[UIImageView alloc] initWithFrame:frame];
        imgv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imgv.contentMode = self.contentMode;
        imgv.image = image;
        imgv.alpha = 0;
        [self insertSubview:imgv atIndex:0];
        self.tmpAnimationView = imgv;
        self.delaySetImage = image;
        
        __weak UIImageView *wself = self;
        [UIView animateWithDuration:0.5 animations:^{
            imgv.alpha = 1;
        } completion:^(BOOL finished) {
            UIImageView * sself = wself;
            if (!sself)
            {
                return ;
            }
            if (sself.delaySetImage)
            {
                sself.image = sself.delaySetImage;
            }
            [self clearTmpAnimation];
        }];
    }
}

- (void)swizzed_setImage:(UIImage*)aImage
{
    [self setImage:aImage animated:NO];
}

@end
