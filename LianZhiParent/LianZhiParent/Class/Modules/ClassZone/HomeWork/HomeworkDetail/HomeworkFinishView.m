//
//  HomeworkFinishView.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/13.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkFinishView.h"

@interface HomeworkFinishView ()
@property (nonatomic, strong)HomeworkReplyView*     replyView;
@property (nonatomic, strong)HomeworkResultView*    resultView;
@end

@implementation HomeworkFinishView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self addSubview:[self resultView]];
        [self addSubview:[self replyView]];
        [self.resultView setHidden:YES];
    }
    return self;
}

- (HomeworkResultView *)resultView{
    if(_resultView == nil){
        _resultView = [[HomeworkResultView alloc] initWithFrame:self.bounds];
        [_resultView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    }
    return _resultView;
}

- (HomeworkReplyView *)replyView{
    if(_replyView == nil){
        _replyView = [[HomeworkReplyView alloc] initWithFrame:self.bounds];
        [_replyView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    }
    return _replyView;
}

- (void)setHomeworkItem:(HomeworkItem *)homeworkItem{
    _homeworkItem = homeworkItem;
    [self.resultView setHomeworkItem:_homeworkItem];
    [self.replyView setHomeworkItem:_homeworkItem];
    if(_homeworkItem.s_answer){//以及恢复了显示result
        [self.resultView setHidden:NO];
        [self.replyView setHidden:YES];
    }
    else{
        [self.resultView setHidden:YES];
        [self.replyView setHidden:NO];
    }
}


@end
