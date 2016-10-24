//
//  HomeworkItemAnswerView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/19.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkItemAnswerView.h"
#import "NotificationVoiceView.h"
#import "HomeworkPhotoView.h"
@interface HomeworkItemAnswerView ()
@property (nonatomic, strong)UILabel*           wordslabel;
@property (nonatomic, strong)AudioContentView*  audioView;
@end

@implementation HomeworkItemAnswerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setClipsToBounds:YES];
        [self setHeight:0];
        
        UIView* titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
        [titleView setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, titleView.width - 10 * 2, titleView.height)];
        [titleLabel setFont:[UIFont systemFontOfSize:13]];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [titleLabel setText:@"作业解析:"];
        [titleView addSubview:titleLabel];
        [self addSubview:titleView];
        
        
    }
    return self;
}

- (void)setAnswer:(HomeworkItemAnswer *)answer{
    _answer = answer;
    CGFloat margin = 10;
    NSInteger spaceYStart = 30 + margin;
    if(_answer.words.length > 0){
        _wordslabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, spaceYStart, self.width - margin * 2, 0)];
        [_wordslabel setFont:[UIFont systemFontOfSize:14]];
        [_wordslabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [_wordslabel setNumberOfLines:0];
        [_wordslabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_wordslabel setText:_answer.words];
        [_wordslabel sizeToFit];
        [self addSubview:_wordslabel];
        
        spaceYStart = _wordslabel.bottom + margin;
    }
    
    if(_answer.voice){
        _audioView = [[AudioContentView alloc] initWithMaxWidth:self.width - margin * 2];
        [_audioView setOrigin:CGPointMake(margin, spaceYStart)];
        [_audioView setAudioItem:_answer.voice];
        [self addSubview:_audioView];
        
        spaceYStart = _audioView.bottom + margin;
    }
    
    if([_answer.pics count] > 0){
        HomeworkPhotoView *photoView = [[HomeworkPhotoView alloc] initWithFrame:CGRectMake(0, spaceYStart, self.width, 0)];
        [photoView setPhotoArray:_answer.pics];
        [self addSubview:photoView];
        spaceYStart = photoView.bottom;
    }
    [self setHeight:spaceYStart];
}

@end
