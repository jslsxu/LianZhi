//
//  IndividualOperationView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/5.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "IndividualOperationView.h"
#import "ContactParentsVC.h"
#import "PhotoOperationVC.h"
#import "GrowthTimelinePublishVC.h"
#define kBaseButtonTag              1000

@implementation IndividualOperationView


- (instancetype)initWithFrame:(CGRect)frame andClassInfo:(ClassInfo *)classInfo
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        self.classInfo = classInfo;
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgButton setFrame:self.bounds];
        [_bgButton addTarget:self action:@selector(onBgButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bgButton];
        
        _bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:MJRefreshSrcName(@"WhiteBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)]];
        [_bgImageView setFrame:CGRectMake((self.width - 210) / 2 ,(self.height - 210) / 2, 210, 210)];
        [_bgImageView setUserInteractionEnabled:YES];
        [self addSubview:_bgImageView];
        
        _avatar = [[AvatarView alloc] initWithFrame:CGRectMake((_bgImageView.width - 90) / 2, 15, 90, 90)];
        [_avatar setBorderWidth:2];
        [_avatar setBorderColor:[UIColor colorWithWhite:0.8 alpha:1.f]];
        [_avatar setImageWithUrl:[NSURL URLWithString:self.studentInfo.avatar]];
        [_bgImageView addSubview:_avatar];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _avatar.bottom, _bgImageView.width, 36)];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [_nameLabel setFont:[UIFont systemFontOfSize:16]];
        [_nameLabel setTextColor:kCommonTeacherTintColor];
        [_nameLabel setText:self.studentInfo.name];
        [_bgImageView addSubview:_nameLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, _nameLabel.bottom, _bgImageView.width, 1)];
        [_sepLine setBackgroundColor:kCommonTeacherTintColor];
        [_bgImageView addSubview:_sepLine];
        
        [self layout];
        _bgImageView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    }
    return self;
}

- (void)layout
{
    NSArray *btnImage = @[@"PhotoOperation.png",@"GrowthOperation.png",@"LookParentsOperation.png"];
    NSArray *btnTitle = @[@"发照片",@"成长册",@"找家长"];
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *button = (UIButton *)[_bgImageView viewWithTag:kBaseButtonTag + i];
        if(button == nil)
        {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(70 * i, _sepLine.bottom, 70, _bgImageView.height - _sepLine.bottom)];
            [button setTag:kBaseButtonTag + i];
            [button setImage:[UIImage imageNamed:btnImage[i]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onOperationBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setImageEdgeInsets:UIEdgeInsetsMake(-15, 0, 0, 0)];
            [_bgImageView addSubview:button];

            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, button.height - 30, button.width, 30)];
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            [titleLabel setUserInteractionEnabled:NO];
            [titleLabel setTextAlignment:NSTextAlignmentCenter];
            [titleLabel setFont:[UIFont systemFontOfSize:14]];
            [titleLabel setTextColor:kCommonTeacherTintColor];
            [titleLabel setText:btnTitle[i]];
            [button addSubview:titleLabel];
        }
        if(self.classInfo.recordEnabled)
        {
            button.hidden = NO;
            [button setFrame:CGRectMake(70 * i, _sepLine.bottom, 70, _bgImageView.height - _sepLine.bottom)];
        }
        else
        {
            if(i == 1)
                button.hidden = YES;
            else
            {
                button.hidden = NO;
                CGFloat spaceXStart = 0;
                if(i == 0)
                    spaceXStart = _bgImageView.width / 2 - button.width;
                else
                    spaceXStart = _bgImageView.width / 2;
                [button setX:spaceXStart];
            }
        }
    }

}

- (void)setStudentInfo:(StudentInfo *)studentInfo
{
    _studentInfo = studentInfo;
    [_avatar setImageWithUrl:[NSURL URLWithString:self.studentInfo.avatar]];
    [_nameLabel setText:self.studentInfo.name];
}

- (void)onBgButtonClicked
{
    [self fadeOut];
}

- (void)onOperationBtnClicked:(id)sender
{
    [self fadeOut];
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag - kBaseButtonTag;
   if(index == 0)
   {
       PhotoOperationVC *photoOperationVC = [[PhotoOperationVC alloc] init];
       [photoOperationVC setClassInfo:self.classInfo];
       [photoOperationVC setTargetArray:@[self.studentInfo]];
       TNBaseNavigationController *nav = [[TNBaseNavigationController alloc] initWithRootViewController:photoOperationVC];
       [CurrentROOTNavigationVC presentViewController:nav animated:YES completion:nil];
   }
    else if(index == 1)
    {
        GrowthTimelinePublishVC *growthPublishVC = [[GrowthTimelinePublishVC alloc] init];
        [growthPublishVC setStudents:@[self.studentInfo]];
        [growthPublishVC setClassInfo:self.classInfo];
        TNBaseNavigationController *nav = [[TNBaseNavigationController alloc] initWithRootViewController:growthPublishVC];
        [CurrentROOTNavigationVC presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        ContactParentsVC *parentsVC = [[ContactParentsVC alloc] init];
        [parentsVC setStudentInfo:self.studentInfo];
        [parentsVC setPresentedByClassOperation:YES];
        TNBaseNavigationController *nav = [[TNBaseNavigationController alloc] initWithRootViewController:parentsVC];
        [CurrentROOTNavigationVC presentViewController:nav animated:YES completion:nil];
    }
}

- (void)fadeIn
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    _bgImageView.layer.opacity = 0.f;
    [UIView animateWithDuration:0.3 animations:^{
        [self setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7]];
        _bgImageView.layer.transform = CATransform3DMakeScale(1, 1, 1);
        _bgImageView.layer.opacity = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)fadeOut
{
    [UIView animateWithDuration:0.3 animations:^{
        [self setBackgroundColor:[UIColor clearColor]];
        _bgImageView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1);
        _bgImageView.layer.opacity = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
