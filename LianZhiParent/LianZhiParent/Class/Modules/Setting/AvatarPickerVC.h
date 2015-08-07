//
//  AvatarPickerVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/2/3.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
@class AvatarPickerVC;
@protocol AvatarPickerDelegate <NSObject>

@optional
- (void)avatarPickerDidFinished:(AvatarPickerVC *)picker withImage:(UIImage *)avatar;
- (void)avatarPickerDidCancel:(AvatarPickerVC *)picker;

@end

@interface AvatarPickerVC : TNBaseViewController
{
    UIImageView*        _imageView;
}
@property (nonatomic, strong)UIImage *originalImage;
@property (nonatomic, weak)id<AvatarPickerDelegate> delegate;
@end
