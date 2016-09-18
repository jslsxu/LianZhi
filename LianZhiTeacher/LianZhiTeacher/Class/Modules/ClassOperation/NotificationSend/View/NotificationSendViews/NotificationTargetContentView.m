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

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        UILabel*    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 15, 55, 20)];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [titleLabel setFont:[UIFont systemFontOfSize:15]];
        [titleLabel setText:@"收件人:"];
        [titleLabel sizeToFit];
        [self addSubview:titleLabel];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, titleLabel.bottom + 5, 55, 20)];
        [_numLabel setTextColor:kCommonTeacherTintColor];
        [_numLabel setFont:[UIFont systemFontOfSize:12]];
        [_numLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_numLabel setNumberOfLines:0];
        [_numLabel setText:[NSString stringWithFormat:@"(%zd人)",[self.targets count]]];
        [self addSubview:_numLabel];
        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:[UIImage imageNamed:@"add_target"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(onAddButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_addButton setFrame:CGRectMake(self.width - 40, 5, 40, 40)];
        [self addSubview:_addButton];
        
        @weakify(self)
        _memberView = [[NotificationSendTargetView alloc] initWithFrame:CGRectMake(70, kVMargin, self.width - 40 - 70, 32)];
        [_memberView setDeleteCallback:^(UserInfo *userInfo) {
            @strongify(self)
            if(self.deleteDataCallback){
                self.deleteDataCallback(userInfo);
            }
        }];
        [self addSubview:_memberView];
        [self setHeight:MAX(_memberView.height + kVMargin * 2, 70)];
        UIView* bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [bottomLine setBackgroundColor:kSepLineColor];
        [bottomLine setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [self addSubview:bottomLine];
    }
    return self;
}

- (void)setTargets:(NSArray *)targets{
    _targets = targets;
    [_memberView setSendArray:_targets];
    [_numLabel setText:[NSString stringWithFormat:@"(%zd人)",[targets count]]];
    [self setHeight:MAX(_memberView.height + kVMargin * 2, 70)];
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    [_addButton setCenterY:self.height / 2];
}

- (void)onAddButtonClicked{
    if(self.addBlk){
        self.addBlk();
    }
}
@end
