//
//  ContactsLoadingView.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/9/5.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ContactsLoadingView.h"

#define kItemDotWidth           12

@interface ContactsLoadingView ()
@property (nonatomic, strong)NSMutableArray *dotArray;
@property (nonatomic, strong)UILabel*       textLabel;
@property (nonatomic, strong)NSTimer* timer;
@property (nonatomic, assign)NSInteger step;
@end

@implementation ContactsLoadingView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.dotArray = [NSMutableArray array];
        for (NSInteger i = 0; i < 3; i++) {
            UIView *dot = [[UIView alloc] initWithFrame:CGRectMake((kItemDotWidth + kItemDotWidth / 2) * i, 0, kItemDotWidth, kItemDotWidth)];
            [dot.layer setCornerRadius:kItemDotWidth / 2];
            [self addSubview:dot];
            [self.dotArray addObject:dot];
        }
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_textLabel setTextColor:[UIColor colorWithHexString:@"B4B4B4"]];
        [_textLabel setFont:[UIFont systemFontOfSize:14]];
        [_textLabel setText:@"加载中"];
        [_textLabel sizeToFit];
        [self addSubview:_textLabel];
        
        [self setSize:CGSizeMake(kItemDotWidth * 3 + kItemDotWidth / 2 * 2, kItemDotWidth + 8 + _textLabel.height)];
        [_textLabel setOrigin:CGPointMake((self.width - _textLabel.width) / 2, self.height - _textLabel.height)];
        [self setHidden:YES];
    }
    return self;
}

- (void)setStep:(NSInteger)step{
    _step = step;
    NSInteger i = self.step % 3;
    UIView *midView = self.dotArray[i];
    [midView setBackgroundColor:[UIColor darkGrayColor]];
    UIView *leftView = self.dotArray[(i + 2) % 3];
    [leftView setBackgroundColor:[UIColor grayColor]];
    UIView *rightView = self.dotArray[(i + 1) % 3];
    [rightView setBackgroundColor:[UIColor lightGrayColor]];
}

- (void)show{
    [self setHidden:NO];
    if(self.timer){
        [self.timer invalidate];
    }
    @weakify(self)
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 block:^(NSTimer * _Nonnull timer) {
        @strongify(self)
        [self setStep:self.step + 1];
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

- (void)dismiss{
    [self.timer invalidate];
    [self setHidden:YES];
}

@end
