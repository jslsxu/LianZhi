//
//  HomeworkDetailHintView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/9.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkDetailHintView.h"

@interface HomeworkDetailHintView ()
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, strong)UIButton*  bgButton;
@property (nonatomic, strong)UIView*    contentView;
@property (nonatomic, strong)void (^dismissCallBack)();
@end

@implementation HomeworkDetailHintView

+ (void)showWithTitle:(NSString *)title description:(NSString *)description completion:(void (^)(void))completion{
    HomeworkDetailHintView *hintView = [[HomeworkDetailHintView alloc] initWithFrame:CGRectZero title:title description:description];
    [hintView setDismissCallBack:completion];
    [hintView show];
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self){
        self.title = title;
        self.content = description;
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgButton setFrame:self.bounds];
        [_bgButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
        [_bgButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bgButton];
        
        [self addSubview:self.contentView];
        [self.contentView setOrigin:CGPointMake((self.width - self.contentView.width) / 2, (self.height - self.contentView.height) / 2)];
    }
    return self;
}

- (UIView *)contentView{
    if(_contentView == nil){
        NSInteger width = self.width * 3 / 4;
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(self.width / 8, 0, width, 0)];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView.layer setCornerRadius:15];
        [_contentView.layer setMasksToBounds:YES];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLabel setText:[NSString stringWithFormat:@"%@:",self.title]];
        [titleLabel setFont:[UIFont systemFontOfSize:15]];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"525252"]];
        [titleLabel sizeToFit];
        [_contentView addSubview:titleLabel];
        [titleLabel setOrigin:CGPointMake(15, 15)];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom + 15, _contentView.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [_contentView addSubview:sepLine];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [contentLabel setWidth:width - 15 * 2];
        [contentLabel setFont:[UIFont systemFontOfSize:15]];
        [contentLabel setTextColor:[UIColor colorWithHexString:@"525252"]];
        [contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [contentLabel setNumberOfLines:0];
        [contentLabel setText:self.content];
        [contentLabel sizeToFit];
        [contentLabel setOrigin:CGPointMake(15, sepLine.bottom + 15)];
        [_contentView addSubview:contentLabel];
        [_contentView setHeight:contentLabel.bottom + 15];
    }
    return _contentView;
}


- (void)show{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    self.bgButton.alpha = 0.f;
    self.contentView.alpha = 1.f;
    [UIView animateWithDuration:0.3 animations:^{
        self.bgButton.alpha = 1.f;
        self.contentView.alpha = 1.f;
    }];
}

- (void)dismiss{
    if(self.dismissCallBack){
        self.dismissCallBack();
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.bgButton.alpha = 0.f;
        self.contentView.alpha = 0.f;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
