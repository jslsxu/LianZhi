//
//  ChildrenSwitchView.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/8/20.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ChildrenSwitchView.h"
#import "LZTabBarButton.h"
#import "ChildrenSelectVC.h"

@implementation SwitchChildButton
- (void)layoutSubviews
{
    [super layoutSubviews];
    if(_redDot == nil)
    {
        _redDot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        [_redDot.layer setCornerRadius:3];
        [_redDot.layer setMasksToBounds:YES];
        [_redDot setBackgroundColor:[UIColor colorWithHexString:@"F0003A"]];
        [_redDot setHidden:YES];
        [self addSubview:_redDot];
    }
    [_redDot setCenter:CGPointMake(self.imageView.right, self.imageView.top)];
}

- (void)setHasNew:(BOOL)hasNew
{
    _hasNew = hasNew;
    [_redDot setHidden:!_hasNew];
    [self setNeedsLayout];
}

@end

@interface ChildrenSwitchView ()
{
    SwitchChildButton*     _switchButton;
    AvatarView*         _avatar;
}
@property (nonatomic, strong)NSMutableArray*    childBadgeArray;
@end

@implementation ChildrenSwitchView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStatusChanged) name:kStatusChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupSubviews) name:kUserCenterChangedCurChildNotification object:nil];
        _switchButton = [SwitchChildButton buttonWithType:UIButtonTypeCustom];
        [_switchButton setImage:[UIImage imageNamed:@"ChildrenSwitch"] forState:UIControlStateNormal];
        [_switchButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_switchButton setUserInteractionEnabled:NO];
        [_switchButton setSize:CGSizeMake(24, 24)];
        [self addSubview:_switchButton];
        
        _avatar = [[AvatarView alloc] initWithRadius:14];
        [self addSubview:_avatar];
    
        [self setupSubviews];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchChild)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)onStatusChanged
{
    [_switchButton setHasNew:[self hasNewMessage]];
}

- (BOOL)hasNewMessage{
    ChildInfo *curChild = [UserCenter sharedInstance].curChild;
    for (ChildInfo *childInfo in [UserCenter sharedInstance].children) {
        if(![childInfo.uid isEqualToString:curChild.uid]){
            if([[UserCenter sharedInstance].statusManager hasNewForChildID:childInfo.uid])
            {
                return YES;
            }
        }
    }
    return NO;
}

- (void)setupSubviews{
    UserInfo *curChild = [UserCenter sharedInstance].curChild;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:curChild.avatar]];
    if([UserCenter sharedInstance].children.count <= 1){
        [_switchButton setHidden:YES];
        [_avatar setOrigin:CGPointMake(0, (self.height - _avatar.height) / 2)];
    }
    else{
        [_switchButton setHidden:NO];
        [_switchButton setOrigin:CGPointMake(0, (self.height - _switchButton.height) / 2)];
        [_avatar setOrigin:CGPointMake(_switchButton.right, (self.height - _avatar.height) / 2)];
    }
    [self setWidth:_avatar.right];
    [self onStatusChanged];
}

- (void)switchChild{
    if([UserCenter sharedInstance].children.count > 1){
        [ChildrenSelectVC showChildrenSelectWithCompletion:^{
            
        }];
    }
}
@end
