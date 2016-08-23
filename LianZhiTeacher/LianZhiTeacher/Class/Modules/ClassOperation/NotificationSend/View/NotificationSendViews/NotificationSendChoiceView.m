//
//  NotificationSendSmsView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/19.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationSendChoiceView.h"

@implementation NotificationSendChoiceView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title{
    self = [super initWithFrame:frame];
    if(self){
        [self setClipsToBounds:YES];
        _stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stateButton setFrame:CGRectMake(0, 0, 42, self.height)];
        [_stateButton addTarget:self action:@selector(onStateButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_stateButton];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_titleLabel setText:title];
        [_titleLabel sizeToFit];
        [_titleLabel setOrigin:CGPointMake(_stateButton.right, (self.height - _titleLabel.height) / 2)];
        [self addSubview:_titleLabel];
        
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.right + 10, 0, self.width - 10 - (_titleLabel.right + 10), self.height)];
        [_infoLabel setTextColor:kCommonTeacherTintColor];
        [_infoLabel setFont:[UIFont systemFontOfSize:14]];
        [_infoLabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_infoLabel];
        
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [infoButton setFrame:_infoLabel.frame];
        [infoButton addTarget:self action:@selector(onInfoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:infoButton];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
        
        [self setIsOn:NO];
    }
    return self;
}

- (void)setInfoStr:(NSString *)infoStr{
    _infoStr = [infoStr copy];
    [_infoLabel setText:_infoStr];
}

- (void)setIsOn:(BOOL)isOn{
    _isOn = isOn;
    [_stateButton setImage:[UIImage imageNamed:_isOn ? @"send_sms_on" : @"send_sms_off"] forState:UIControlStateNormal];
}

- (void)onStateButtonClicked{
    [self setIsOn:!self.isOn];
    if(self.switchCallback){
        self.switchCallback(self.isOn);
    }
}

- (void)onInfoButtonClicked{
    if(self.infoAction){
        self.infoAction();
    }
}

@end
