//
//  HomeworkReplySwitchView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/9.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkReplySwitchView.h"
#import "HomeworkDetailHintView.h"
@interface HomeworkReplySwitchView ()
@property (nonatomic, strong)UISwitch *replySwitch;
@end

@implementation HomeworkReplySwitchView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [titleLabel setFont:[UIFont systemFontOfSize:15]];
        [titleLabel setText:@"开启作业回复"];
        [titleLabel sizeToFit];
        [titleLabel setOrigin:CGPointMake(12, (self.height - titleLabel.height) / 2)];
        [self addSubview:titleLabel];
        
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [detailButton setImage:[UIImage imageNamed:@"explainIcon"] forState:UIControlStateNormal];
        [detailButton setFrame:CGRectMake(titleLabel.right, (self.height - 30) / 2, 30, 30)];
        [detailButton addTarget:self action:@selector(showDetailHint) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:detailButton];
        
        _replySwitch = [[UISwitch alloc] init];
        [_replySwitch setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
        [_replySwitch addTarget:self action:@selector(onReplySwitch) forControlEvents:UIControlEventValueChanged];
        [_replySwitch setOrigin:CGPointMake(self.width - 10 - _replySwitch.width, (self.height - _replySwitch.height) / 2)];
        [_replySwitch setOnTintColor:kCommonTeacherTintColor];
        [self addSubview:_replySwitch];
        
        UIView* bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [bottomLine setBackgroundColor:kSepLineColor];
        [self addSubview:bottomLine];
    }
    return self;
}

- (void)setReplyOn:(BOOL)replyOn{
    _replyOn = replyOn;
    [self.replySwitch setOn:_replyOn];
}

- (void)onReplySwitch{
    if(self.replySwitchCallback){
        self.replySwitchCallback(self.replySwitch.isOn);
    }
}

- (void)showDetailHint{
    [HomeworkDetailHintView showWithTitle:@"开启作业回复" description:@"开启作业回复后，家长可以通过APP向您回复作业." completion:nil];
}

@end
