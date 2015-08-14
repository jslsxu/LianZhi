//
//  AvatarPickerVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/2/3.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "AvatarPickerVC.h"

@implementation AvatarPickerVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.hideNavigationBar = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _imageView = [[UIImageView alloc] initWithImage:self.originalImage];
    [self.view addSubview:_imageView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:[UIImage imageNamed:@"AvatarCancel.png"] forState:UIControlStateNormal];
    [cancelButton setFrame:CGRectMake(20, 20, 40, 40)];
    [cancelButton addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setImage:[UIImage imageNamed:@"AvatarConfirm.png"] forState:UIControlStateNormal];
    [confirmButton setFrame:CGRectMake((self.view.width - 40) / 2, self.view.height - 40 - 20, 40, 40)];
    [confirmButton addTarget:self action:@selector(onConfirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
}

- (void)onCancel
{
    if([self.delegate respondsToSelector:@selector(avatarPickerDidCancel:)])
        [self.delegate avatarPickerDidCancel:self];
}

- (void)onConfirm
{
    if([self.delegate respondsToSelector:@selector(avatarPickerDidFinished:withImage:)])
        [self.delegate avatarPickerDidFinished:self withImage:nil];
}
@end
