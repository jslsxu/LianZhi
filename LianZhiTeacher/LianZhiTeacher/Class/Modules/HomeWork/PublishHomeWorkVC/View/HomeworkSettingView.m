//
//  HomeworkSettingView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkSettingView.h"

@interface HomeworkSettingView ()
@property (nonatomic, strong)UIImageView*   timeImageView;
@property (nonatomic, strong)UIImageView*   sendSmsImageView;
@property (nonatomic, strong)UIImageView*   rightArrow;
@end

@implementation HomeworkSettingView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [titleLabel setFont:[UIFont systemFontOfSize:15]];
        [titleLabel setText:@"高级设置"];
        [titleLabel sizeToFit];
        [titleLabel setOrigin:CGPointMake(12, (self.height - titleLabel.height) / 2)];
        [self addSubview:titleLabel];
        
        self.rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]];
        [self.rightArrow setOrigin:CGPointMake(self.width - 10 - self.rightArrow.width, (self.height - self.rightArrow.height) / 2)];
        [self addSubview:self.rightArrow];
        
        self.sendSmsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settingSendSms"]];
        [self.sendSmsImageView setHidden:YES];
        [self addSubview:self.sendSmsImageView];
        
        self.timeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settingReplyEndOn"]];
        [self.timeImageView setHidden:YES];
        [self addSubview:self.timeImageView];
        
        UIView* sepLine = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setHomeworkSetting)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setHomeworkEntity:(HomeWorkEntity *)homeworkEntity{
    _homeworkEntity = homeworkEntity;
    NSInteger spaceXEnd = self.rightArrow.left - 10;
    if(_homeworkEntity.sendSms){
        [self.sendSmsImageView setHidden:NO];
        [self.sendSmsImageView setOrigin:CGPointMake(spaceXEnd - self.sendSmsImageView.width, (self.height - self.sendSmsImageView.height) / 2)];
        spaceXEnd = self.sendSmsImageView.left - 10;
    }
    else{
        [self.sendSmsImageView setHidden:YES];
    }
    if(_homeworkEntity.reply_close){
        [self.timeImageView setHidden:NO];
        [self.timeImageView setOrigin:CGPointMake(spaceXEnd - self.timeImageView.width, (self.height - self.timeImageView.height) / 2)];
    }
    else{
        [self.timeImageView setHidden:YES];
    }
}

- (void)setHomeworkSetting{
    if(self.settingClick){
        self.settingClick();
    }
}
@end
