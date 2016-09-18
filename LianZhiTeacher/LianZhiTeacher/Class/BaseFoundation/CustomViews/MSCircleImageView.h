//
//  MSCircleImageView.h
//  menswear
//
//  Created by jslsxu on 14-9-14.
//  Copyright (c) 2014年 menswear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvatarView : UIImageView
{
    UILabel*    _statusLabel;
}
@property (nonatomic, copy)NSString *status;
- (instancetype)initWithRadius:(CGFloat)radius;
@end

@interface LogoView : AvatarView

@end
