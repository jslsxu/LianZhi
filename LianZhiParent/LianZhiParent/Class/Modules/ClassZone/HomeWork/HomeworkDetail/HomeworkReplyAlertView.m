//
//  HomeworkReplyAlertView.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/20.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkReplyAlertView.h"
#import "LZKVStorage.h"
@interface HomeworkReplyAlertView ()
@property (nonatomic, strong)UIButton*  bgButton;
@property (nonatomic, strong)UIView*    contentView;
@property (nonatomic, copy)void (^completion)();
@end

@implementation HomeworkReplyAlertView

+ (void)showAlertViewWithCompletion:(void (^)())completion{
    BOOL hiddenAlert = [[NSUserDefaults standardUserDefaults] boolForKey:@"HomeworkReplyAlert"];
    if(!hiddenAlert){
        HomeworkReplyAlertView *alertView = [[HomeworkReplyAlertView alloc] init];
        [alertView setCompletion:completion];
        [alertView show];
    }
    else{
        if(completion){
            completion();
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self){
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgButton setFrame:self.bounds];
        [_bgButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
//        [_bgButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bgButton];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake((self.width - 250) / 2, (self.height - 150) / 2, 250, 150)];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView.layer setCornerRadius:10];
        [_contentView.layer setMasksToBounds:YES];
        [self setupContentView:_contentView];
        [self addSubview:_contentView];
    }
    return self;
}

- (void)setupContentView:(UIView *)viewParent{
    UILabel*    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setText:@"确认回复作业"];
    [titleLabel sizeToFit];
    [titleLabel setOrigin:CGPointMake((viewParent.width - titleLabel.width) / 2, 20)];
    [viewParent addSubview:titleLabel];
    
    UILabel* contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [contentLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [contentLabel setFont:[UIFont systemFontOfSize:13]];
    [contentLabel setText:@"作业回复后，就不能再修改了"];
    [contentLabel sizeToFit];
    [contentLabel setOrigin:CGPointMake((viewParent.width - contentLabel.width) / 2, titleLabel.bottom + 12)];
    [viewParent addSubview:contentLabel];
    
    UIButton* checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkButton setImage:[UIImage imageNamed:@"checkNormal"] forState:UIControlStateNormal];
    [checkButton setImage:[UIImage imageNamed:@"checkSelected"] forState:UIControlStateSelected];
    [checkButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(showAlertToggle:) forControlEvents:UIControlEventTouchUpInside];
    [checkButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [checkButton setTitle:@"不再显示该消息" forState:UIControlStateNormal];
    [checkButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [checkButton setFrame:CGRectMake((viewParent.width - 140) / 2, contentLabel.bottom, 140, viewParent.height - 38 - contentLabel.bottom - 2)];
    [viewParent addSubview:checkButton];
    
    UIView* hLine = [[UIView alloc] initWithFrame:CGRectMake(0, viewParent.height - 38, viewParent.width, kLineHeight)];
    [hLine setBackgroundColor:kSepLineColor];
    [viewParent addSubview:hLine];
    
    UIView* vLine = [[UIView alloc] initWithFrame:CGRectMake(viewParent.width / 2, hLine.bottom, kLineHeight, 38)];
    [vLine setBackgroundColor:kSepLineColor];
    [viewParent addSubview:vLine];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setTitleColor:kCommonParentTintColor forState:UIControlStateNormal];
    [confirmButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [confirmButton setTitle:@"回复" forState:UIControlStateNormal];
    [confirmButton setFrame:CGRectMake(0, hLine.bottom, viewParent.width / 2, 38)];
    [confirmButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"dddddd"] size:confirmButton.size] forState:UIControlStateHighlighted];
    [confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [viewParent addSubview:confirmButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitleColor:kCommonParentTintColor forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setFrame:CGRectMake(viewParent.width / 2, hLine.bottom, viewParent.width / 2, 38)];
    [cancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"dddddd"] size:cancelButton.size] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [viewParent addSubview:cancelButton];
}

- (void)confirm{
    if(self.completion){
        self.completion();
    }
    [self dismiss];
}

- (void)showAlertToggle:(UIButton *)button{
    button.selected = !button.selected;
    [[NSUserDefaults standardUserDefaults] setBool:button.selected forKey:@"HomeworkReplyAlert"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)show{
    [self setAlpha:0.f];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        [self setAlpha:1.f];
    }completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        [self setAlpha:0.f];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
