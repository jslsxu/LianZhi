//
//  ActionFadeView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/27.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ActionFadeView.h"
#import "NotificationSendVC.h"
@interface ActionFadeView (){
    UIVisualEffectView* _effectView;
    UIView*             _contentView;
    UIImageView*        _logoView;
    UIButton*           _cancelButton;
    NSMutableArray*     _buttonArray;
}
@end

@implementation ActionFadeView

+ (void)showActionView{
    ActionFadeView *actionView = [[ActionFadeView alloc] init];
    [actionView show];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self){
        _buttonArray = [NSMutableArray array];
//        [self setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.6]];
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _effectView.frame = self.bounds;
        [self addSubview:_effectView];
        
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        [self setupContentView:_contentView];
        [self addSubview:_contentView];
    }
    return self;
}

- (void)setupContentView:(UIView *)viewParent{
    
    _logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_title"]];
    [_logoView setOrigin:CGPointMake((_contentView.width - _logoView.width) / 2, 160)];
    [_contentView addSubview:_logoView];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setSize:CGSizeMake(50, 50)];
    [_cancelButton setCenter:CGPointMake(_contentView.width / 2, _contentView.height - _cancelButton.height / 2)];
    [_cancelButton setImage:[UIImage imageNamed:@"ActionCancel"] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_cancelButton];
    
//    if([UserCenter sharedInstance].curSchool.classes.count + [UserCenter sharedInstance].curSchool.managedClasses.count > 0)
    {
        [_buttonArray addObject:[self actionViewWithTitle:@"发通知" image:@"SendNotification" action:@selector(sendNotification)]];
    }
    [_buttonArray addObject:[self actionViewWithTitle:@"新聊天" image:@"NewChat" action:@selector(newChat)]];
    [_buttonArray addObject:[self actionViewWithTitle:@"学生考勤" image:@"StudentAttendance" action:@selector(studentAttendance)]];
    
    NSInteger count = _buttonArray.count;
    NSInteger spaceXStart = (_contentView.width - 100 * count) / 2;
    NSInteger spaceYStart = (_cancelButton.y + _logoView.bottom - 110) / 2;
    for (NSInteger i = 0; i < count; i++) {
        UIView *itemView = _buttonArray[i];
        [_contentView addSubview:itemView];
        [itemView setOrigin:CGPointMake(spaceXStart + 100 * i, spaceYStart)];
    }
    
}

- (UIView *)actionViewWithTitle:(NSString *)title image:(NSString *)imageName action:(SEL)action{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 110)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button setSize:CGSizeMake(100, 80)];
    [view addSubview:button];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, button.bottom, view.width, 30)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [titleLabel setText:title];
    [view addSubview:titleLabel];
    
    return view;
}

- (void)sendNotification{
    [self dismissWithCompletion:^{
        NotificationSendVC *sendVC = [[NotificationSendVC alloc] init];
        [CurrentROOTNavigationVC pushViewController:sendVC animated:YES];
    }];
}

- (void)newChat{
    [ApplicationDelegate.homeVC selectAtIndex:1];
    [self dismiss];
}

- (void)studentAttendance{

    [self dismissWithCompletion:^{
        
    }];
}

- (void)show{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    self.alpha = 0.f;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.f;
    }completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.f;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dismissWithCompletion:(void (^)())completion{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.f;
    }completion:^(BOOL finished) {
        if(completion){
            completion();
        }
        [self removeFromSuperview];
    }];
}

@end
