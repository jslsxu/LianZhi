//
//  MSCircleImageView.h
//  menswear
//
//  Created by jslsxu on 14-9-14.
//  Copyright (c) 2014年 menswear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSCircleImageView : UIView
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, assign) BOOL disableClip;

@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIColor *borderColor;

- (instancetype)initWithRadius:(CGFloat)radius;
- (void)setImageWithUrl:(NSURL *)url placeHolder:(UIImage *)placeHolder;
- (void)setImageWithUrl:(NSURL *)url;
@end

@interface AvatarView : MSCircleImageView

@end

@interface LogoView : MSCircleImageView

@end
