//
//  ActionView.m
//  LianZhiParent
//
//  Created by jslsxu on 15/8/22.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ActionView.h"

@implementation ActionView

- (instancetype)initWithPoint:(CGPoint)point
{
    self = [super initWithFrame:CGRectZero];
    if(self)
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"0c0c0c"]];
        NSArray *titleArray = @[@"赞",@"评论",@"分享"];
        NSArray *imageArray = @[@"ActionPraise",@"ActionComment",@"ActionShare"];
        NSArray *actionArray = @[@"onActionPraise",@"onActionComment",@"onActionShare"];
        NSInteger itemWidth = self.width / 3;
        for (NSInteger i = 0; i < 3; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(itemWidth * i, 0, itemWidth, self.height)];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Normal",imageArray[i]]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Highlighted",imageArray[i]]] forState:UIControlStateHighlighted];
            [button addTarget:self action:NSSelectorFromString(actionArray[i]) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            if(i == 0)
                _praiseButton = button;
            else if(i == 1)
                _commentButton = button;
            else
                _shareButton = button;
        }
        self.point = point;
    }
    return self;
}

- (void)onActionPraise
{
    
}

- (void)onActionComment
{
    
}

- (void)onActionShare
{
    
}

@end
