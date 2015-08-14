//
//  NewEditionPreview.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/3/1.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "NewEditionPreview.h"

static NSString *versionInfo = @"温馨提示 为了更好的方便您的使用，也为了孩子的老师识别您和您孩子的信息，请及时到设置中修改您的个人信息和您孩子的档案";
#define kMargin         18

@implementation NewEditionPreview

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        [_bgView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_bgView];
        
        CGFloat height = MIN(self.bounds.size.height - 80 * 2, 8 * 2 + [self totalHeight] + 36 + kMargin);
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(12, (self.height - height) / 2, self.width - 12 * 2, height)];
        [_contentView setBackgroundColor:[UIColor colorWithRed:0xcd / 255.0 green:0xca / 255.0 blue:0xca / 255.0 alpha:0.6]];
        [_contentView.layer setCornerRadius:5];
        [_contentView.layer setMasksToBounds:YES];
        [self addSubview:_contentView];
        
        _rootView = [[UIView alloc] initWithFrame:CGRectInset(_contentView.bounds, 8, 8)];
        [_rootView setBackgroundColor:[UIColor whiteColor]];
        [_contentView addSubview:_rootView];
        
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setBackgroundImage:[[UIImage imageNamed:@"GreenBG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_confirmButton setTitle:@"立即使用" forState:UIControlStateNormal];
        [_confirmButton setFrame:CGRectMake(kMargin, _rootView.height - kMargin - 36, _rootView.width - kMargin * 2, 36)];
        [_confirmButton addTarget:self action:@selector(onConfirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_rootView addSubview:_confirmButton];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _rootView.width, _confirmButton.y )];
        [self setupScrollView:_scrollView];
        [_rootView addSubview:_scrollView];
    }
    return self;
}

- (CGFloat)totalHeight
{
    CGFloat infoHeight = [versionInfo boundingRectWithSize:CGSizeMake(self.width - kMargin * 2 - (12 + 8) * 2, 0) andFont:[UIFont systemFontOfSize:14]].height;
    return kMargin * 4 + 20 * 2 + infoHeight;
}

- (void)setupScrollView:(UIView *)viewParent
{
    CGFloat margin = kMargin;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin, viewParent.width - margin * 2, 20)];
    [titleLabel setFont:[UIFont systemFontOfSize:17]];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
    [titleLabel setText:[NSString stringWithFormat:@"欢迎使用连枝家长版"]];
    [viewParent addSubview:titleLabel];
    
    UILabel*    subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, titleLabel.bottom + margin, viewParent.width - margin * 2, 20)];
    [subTitleLabel setFont:[UIFont systemFontOfSize:14]];
    [subTitleLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
    [subTitleLabel setText:@"更新说明"];
    [viewParent addSubview:subTitleLabel];
    
    UILabel*    contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, subTitleLabel.bottom + margin, subTitleLabel.width, 0)];
    [contentLabel setNumberOfLines:0];
    [contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [contentLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
    [contentLabel setFont:[UIFont systemFontOfSize:14]];
    [contentLabel setText:versionInfo];
     [contentLabel sizeToFit];
    [viewParent addSubview:contentLabel];
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, [self totalHeight])];
}

- (void)onConfirmButtonClicked
{
    [self dismiss];
}

- (void)show
{
    UIView *viewParent = [UIApplication sharedApplication].keyWindow;
    [viewParent addSubview:self];
    [self setCenter:CGPointMake(viewParent.width / 2, viewParent.height / 2)];
    _contentView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    _contentView.alpha = 0.f;
    [UIView animateWithDuration:0.2 animations:^{
        _contentView.alpha = 1.f;
        _contentView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.f;
        _contentView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
