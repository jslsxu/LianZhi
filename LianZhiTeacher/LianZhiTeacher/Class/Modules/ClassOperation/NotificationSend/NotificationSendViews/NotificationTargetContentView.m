//
//  NotificationTargetContentView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/19.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationTargetContentView.h"

#define kVMargin                20

@implementation NotificationTargetContentView

- (instancetype)initWithWidth:(CGFloat)width targets:(NSArray *)targets{
    self = [super initWithFrame:CGRectMake(0, 0, width, 0)];
    if(self){
        
        UILabel*    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 20, 55, 20)];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [titleLabel setFont:[UIFont systemFontOfSize:15]];
        [titleLabel setText:@"收件人:"];
        [titleLabel sizeToFit];
        [self addSubview:titleLabel];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_numLabel setTextColor:kCommonTeacherTintColor];
        [_numLabel setFont:[UIFont systemFontOfSize:12]];
        [_numLabel setText:[NSString stringWithFormat:@"(%zd人)",[targets count]]];
        [_numLabel sizeToFit];
        [_numLabel setOrigin:CGPointMake(12, titleLabel.bottom + 10)];
        [self addSubview:_numLabel];
        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:[UIImage imageNamed:@"add_target"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(onAddButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_addButton setFrame:CGRectMake(width - 40, 10, 40, 40)];
        [self addSubview:_addButton];
        
        _memberView = [[NotificationSendTargetView alloc] initWithFrame:CGRectMake(70, kVMargin, width - 40 - 70, 32)];
        [self addSubview:_memberView];
        [self setHeight:_memberView.height + kVMargin * 2];
        
        UIView* bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, width, kLineHeight)];
        [bottomLine setBackgroundColor:kSepLineColor];
        [bottomLine setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [self addSubview:bottomLine];
        
        [self setTargets:targets];
    }
    return self;
}

- (void)setTargets:(NSArray *)targets{
    _targets = targets;
    [_memberView setSendArray:_targets];
    [self setHeight:_memberView.height + kVMargin * 2];
}

- (void)layoutSubviews{
//    [_addButton setCenterY:self.height / 2];
}

- (void)onAddButtonClicked{
    if(self.addBlk){
        self.addBlk();
    }
}
@end
