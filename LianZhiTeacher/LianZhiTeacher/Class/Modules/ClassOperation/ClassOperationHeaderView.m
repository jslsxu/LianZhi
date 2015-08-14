//
//  ClassOperationHeaderView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/4.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ClassOperationHeaderView.h"

@implementation ClassOperationHeaderView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        _bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:(@"WhiteBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [_bgImageView setFrame:CGRectMake(40, 22, self.width - 40 - 10, 60)];
        [self addSubview:_bgImageView];
        
        _logoView = [[LogoView alloc] initWithFrame:CGRectMake(10, 15, 75, 75)];
        [_logoView setBorderWidth:2];
        [_logoView setBorderColor:[UIColor colorWithWhite:0 alpha:0.2f]];
        [self addSubview:_logoView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, _bgImageView.top, self.width - 100 - 10, 30)];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:15]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [self addSubview:_nameLabel];
        
        _classButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_classButton setUserInteractionEnabled:NO];
        [_classButton setBackgroundImage:[[UIImage imageNamed:(@"GrayBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
        [_classButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_classButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_classButton setFrame:CGRectMake(105, _nameLabel.bottom, 130, 22)];
        [self addSubview:_classButton];
        
        if([UserCenter sharedInstance].curSchool.classes.count > 1)
        {
            _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_switchButton setFrame:CGRectMake(_classButton.right + 5, _classButton.top, 60, 22)];
            [_switchButton setBackgroundImage:[[UIImage imageNamed:(@"BlueBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
            [_switchButton addTarget:self action:@selector(onSwitchClass) forControlEvents:UIControlEventTouchUpInside];
            [_switchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_switchButton setTitle:@"切换" forState:UIControlStateNormal];
            [_switchButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [self addSubview:_switchButton];
        }
        [self updateSubviews];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAvatarChanged:) name:kUserInfoChangedNotification object:nil];
    }
    return self;
}

- (void)onAvatarChanged:(NSNotification *)notification
{
    [self updateSubviews];
}

- (void)updateSubviews
{
    if(_classInfo.classID.integerValue == -1)
        [_logoView setImageWithUrl:[NSURL URLWithString:[UserCenter sharedInstance].curSchool.logoUrl]];
    else
        [_logoView setImageWithUrl:[NSURL URLWithString:_classInfo.logoUrl]];
    [_nameLabel setText:[NSString stringWithFormat:@"%@ 老师 (%@)",[UserCenter sharedInstance].userInfo.name,_classInfo.course]];
}

- (void)onSwitchClass
{
    if([self.delegate respondsToSelector:@selector(classSwitch:)])
        [self.delegate classSwitch:self];
}

- (void)setClassInfo:(ClassInfo *)classInfo
{
    _classInfo = classInfo;
    NSString *title = nil;
    if([_classInfo.classID isEqualToString:@"-1"])
    {
        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        for (ClassInfo *classInfo in [UserCenter sharedInstance].curSchool.classes) {
            NSString *course = classInfo.course;
            if(course.length > 0)
            {
                [tmpDic setObject:classInfo forKey:course];
            }
        }
        NSArray *allKeys = [tmpDic allKeys];
        if(allKeys.count > 1)
            title = @"多科";
        else
            title = [allKeys objectAtIndex:0];
    }
    else
        title = _classInfo.course;
    [_nameLabel setText:[NSString stringWithFormat:@"%@ 老师 (%@)",[UserCenter sharedInstance].userInfo.name,title]];
    [_classButton setTitle:_classInfo.className forState:UIControlStateNormal];
    if(_classInfo.classID.integerValue == -1)
        [_logoView setImageWithUrl:[NSURL URLWithString:[UserCenter sharedInstance].curSchool.logoUrl]];
    else
        [_logoView setImageWithUrl:[NSURL URLWithString:_classInfo.logoUrl]];
    
}
@end
