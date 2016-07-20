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
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setFrame:CGRectMake(0, 0, 42, self.height)];
        [_selectButton addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_selectButton];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_titleLabel setText:title];
        [_titleLabel sizeToFit];
        [_titleLabel setOrigin:CGPointMake(_selectButton.right, (self.height - _titleLabel.height) / 2)];
        [self addSubview:_titleLabel];
        
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.right + 10, 0, self.width - 10 - (_titleLabel.right + 10), self.height)];
        [_infoLabel setTextColor:kCommonTeacherTintColor];
        [_infoLabel setFont:[UIFont systemFontOfSize:14]];
        [_infoLabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_infoLabel];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
        
        [self setIsOn:NO];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    
}

- (void)setIsOn:(BOOL)isOn{
    _isOn = isOn;
    [_selectButton setImage:[UIImage imageNamed:_isOn ? @"send_sms_on" : @"send_sms_off"] forState:UIControlStateNormal];
}

- (void)onClick{
    [self setIsOn:!self.isOn];
}

@end
