//
//  HomeworkMarkHeaderView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkMarkHeaderView.h"

@interface HomeworkMarkHeaderView ()
@property (nonatomic, strong)UIButton*  preButton;
@property (nonatomic, strong)UIButton*  nextButton;
@property (nonatomic, strong)AvatarView*    avatarView;
@property (nonatomic, strong)UILabel*   nameLabel;
@property (nonatomic, strong)UILabel*   classLabel;
@property (nonatomic, strong)UILabel*   rateLabel;
@property (nonatomic, strong)UILabel*   timeLabel;
@property (nonatomic, strong)UILabel*   commentLabel;
@end

@implementation HomeworkMarkHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _preButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_preButton setFrame:CGRectMake(0, 20, 36, 40)];
        [_preButton setImage:[UIImage imageNamed:@"preHomework"] forState:UIControlStateNormal];
        [_preButton addTarget:self action:@selector(onPre) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_preButton];
        
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setFrame:CGRectMake(self.width - 36, 20, 36, 40)];
        [_nextButton setImage:[UIImage imageNamed:@"nextHomework"] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nextButton];
        
        _avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(50, 15, 60, 60)];
        [self addSubview:_avatarView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextColor:[UIColor blackColor]];
        [self addSubview:_nameLabel];
        
        _classLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_classLabel setFont:[UIFont systemFontOfSize:14]];
        [_classLabel setTextColor:kCommonTeacherTintColor];
        [self addSubview:_classLabel];
        
        _rateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_rateLabel setFont:[UIFont systemFontOfSize:13]];
        [_rateLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self addSubview:_rateLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_timeLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:_timeLabel];
        
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, self.width, self.height - 80)];
        [_commentLabel setFont:[UIFont systemFontOfSize:13]];
        [_commentLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self addSubview:_commentLabel];
    }
    return self;
}

- (void)setHomeworkItem:(HomeworkItem *)homeworkItem{
    _homeworkItem = homeworkItem;
    [_nameLabel setText:@"陈琦"];
    [_nameLabel sizeToFit];
    [_nameLabel setOrigin:CGPointMake(_avatarView.right + 10, _avatarView.top)];
    [_classLabel setText:@"13级01班"];
    [_classLabel sizeToFit];
    [_classLabel setFrame:CGRectMake(_nameLabel.right + 5, _avatarView.top, _nextButton.left - 10, _classLabel.height)];
    [_rateLabel setText:@"正确率:--"];
    [_rateLabel sizeToFit];
    [_rateLabel setOrigin:CGPointMake(_avatarView.right + 10, _avatarView.centerY - _rateLabel.height / 2)];
    
    [_timeLabel setText:@"提交时间"];
    [_timeLabel sizeToFit];
    [_timeLabel setOrigin:CGPointMake(_avatarView.right + 10, _avatarView.bottom - _timeLabel.height)];
    
    [_commentLabel setText:@"评语：作业完成一半"];
}

- (void)onPre{
    if([self.delegate respondsToSelector:@selector(requestPreHomework)]){
        [self.delegate requestPreHomework];
    }
}

- (void)onNext{
    if([self.delegate respondsToSelector:@selector(requestNextHomework)]){
        [self.delegate requestNextHomework];
    }
}

@end
