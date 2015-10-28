//
//  ActionView.m
//  LianZhiParent
//
//  Created by jslsxu on 15/8/22.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ActionView.h"

#define kActionViewWidth                    240
#define kActionViewHeight                   36

@interface ActionView ()
@property (nonatomic, copy)Action action;
@end

@implementation ActionView

- (instancetype)initWithPoint:(CGPoint)point praised:(BOOL)praised action:(Action)action;
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        self.action = action;
        _coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_coverButton setFrame:self.bounds];
        [_coverButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventAllEvents];
        [self addSubview:_coverButton];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(point.x - kActionViewWidth, point.y - kActionViewHeight / 2, kActionViewWidth, kActionViewHeight)];
        [_contentView setBackgroundColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_contentView.layer setCornerRadius:2];
        [_contentView.layer setMasksToBounds:YES];
        [self addSubview:_contentView];
        
        NSArray *titleArray = @[praised ? @"取消" : @"赞",@"评论",@"分享"];
        NSArray *imageArray = @[@"ActionPraise",@"ActionComment",@"ActionShare"];
        NSArray *actionArray = @[@"onActionPraise",@"onActionComment",@"onActionShare"];
        NSInteger itemWidth = _contentView.width / titleArray.count;
        for (NSInteger i = 0; i < titleArray.count; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(itemWidth * i, 0, itemWidth, _contentView.height)];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Normal",imageArray[i]]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Highlighted",imageArray[i]]] forState:UIControlStateHighlighted];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0c0c0c"] size:button.size] forState:UIControlStateHighlighted];
            [button addTarget:self action:NSSelectorFromString(actionArray[i]) forControlEvents:UIControlEventTouchUpInside];
            [_contentView addSubview:button];
            if(i == 0)
                _praiseButton = button;
            else if(i == 1)
                _commentButton = button;
            else
                _shareButton = button;
            
            if(i > 0)
            {
                UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(button.x, 3, kLineHeight, _contentView.height - 3 * 2)];
                [sepLine setBackgroundColor:[UIColor colorWithHexString:@"0c0c0c"]];
                [_contentView addSubview:sepLine];
            }
        }
    }
    return self;
}

- (void)onActionPraise
{
    if(self.action)
        self.action(0);
    [self dismiss];
}

- (void)onActionComment
{
    if(self.action)
        self.action(1);
    [self dismiss];
}

- (void)onActionShare
{
    if(self.action)
        self.action(2);
    [self dismiss];
}

- (void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}

- (void)dismiss
{
    [self removeFromSuperview];
}

@end
