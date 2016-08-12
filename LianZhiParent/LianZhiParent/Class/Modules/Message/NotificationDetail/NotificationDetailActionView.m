//
//  NotificationDetailActionView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/29.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationDetailActionView.h"
#define kBaseTag                10000
@implementation NotificationActionItem
+ (NotificationActionItem *)actionItemWithTitle:(NSString *)title action:(void (^)())action destroyItem:(BOOL)destroy{
    NotificationActionItem *actionItem = [[NotificationActionItem alloc] init];
    [actionItem setTitle:title];
    [actionItem setAction:action];
    [actionItem setDestroyItem:destroy];
    return actionItem;
}

@end

@interface NotificationDetailActionView (){
    UIButton*       _bgButton;
    UIView*         _contentView;
}
@property (nonatomic, copy)void (^completion)();
@property (nonatomic, strong)NSArray *actionArray;
@end

@implementation NotificationDetailActionView

+ (void)showWithActions:(NSArray *)actionArray completion:(void (^)())completion{
    NotificationDetailActionView *actionView = [[NotificationDetailActionView alloc] initWithActions:actionArray];
    [actionView setCompletion:completion];
    [actionView show];
}

- (instancetype)initWithActions:(NSArray *)actionArray{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self){
        self.actionArray = actionArray;
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        [_bgButton setFrame:self.bounds];
        [_bgButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bgButton];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake((self.width - 200) / 2, 0, 200, 0)];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView.layer setCornerRadius:10];
        [_contentView.layer setMasksToBounds:YES];
        
        CGFloat spaceYStart = 0;
        CGFloat itemHeight = 50;
        for (NSInteger i = 0; i < actionArray.count; i++) {
            NotificationActionItem *actionItem = actionArray[i];
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(15, spaceYStart, _contentView.width - 15 * 2, itemHeight)];
            [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            if(actionItem.destroyItem){
                [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            else{
                [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
            }
            [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [button setTitle:actionItem.title forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setTag:kBaseTag + i];
            [_contentView addSubview:button];
            
            spaceYStart += itemHeight;
            
            if(i < actionArray.count - 1){
                UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, button.bottom, _contentView.width, kLineHeight)];
                [sepLine setBackgroundColor:kSepLineColor];
                [_contentView addSubview:sepLine];
                spaceYStart += kLineHeight;
            }
        }
        [_contentView setFrame:CGRectMake((self.width - 200) / 2, (self.height - spaceYStart) / 2, 200, spaceYStart)];
        [self addSubview:_contentView];
    }
    return self;
}

- (void)onButtonClicked:(UIButton *)button{
    NSInteger index = button.tag - kBaseTag;
    NotificationActionItem *actionItem = self.actionArray[index];
    if(actionItem.action){
        actionItem.action();
    }
    [self dismiss];
}

- (void)show{
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    [keywindow addSubview:self];
    [_bgButton setAlpha:0.f];
    [_contentView setAlpha:0.f];
    [_contentView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
    [UIView animateWithDuration:0.3 animations:^{
        [_bgButton setAlpha:1.f];
        [_contentView setTransform:CGAffineTransformIdentity];
        [_contentView setAlpha:1.f];
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        [_bgButton setAlpha:0.f];
        [_contentView setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
        [_contentView setAlpha:0.f];
    }completion:^(BOOL finished) {
        if(self.completion){
            self.completion();
        }
        [self removeFromSuperview];
    }];
}

@end
