//
//  HomeworkNumView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/9.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkNumView.h"
#import "NumOperationView.h"
#import "HomeworkDetailHintView.h"
@interface HomeworkNumView ()
@property(nonatomic, strong)NumOperationView *numView;
@end
@implementation HomeworkNumView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [titleLabel setFont:[UIFont systemFontOfSize:15]];
        [titleLabel setText:@"题目数量"];
        [titleLabel sizeToFit];
        [titleLabel setOrigin:CGPointMake(12, (self.height - titleLabel.height) / 2)];
        [self addSubview:titleLabel];
        
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [detailButton setImage:[UIImage imageNamed:@"explainIcon"] forState:UIControlStateNormal];
        [detailButton setFrame:CGRectMake(titleLabel.right, (self.height - 30) / 2, 30, 30)];
        [detailButton addTarget:self action:@selector(showDetailHint) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:detailButton];
        
        __weak typeof(self) wself = self;
        _numView = [[NumOperationView alloc] initWithMin:1 max:99];
        [_numView setOrigin:CGPointMake(self.width - 10 - _numView.width, (self.height - _numView.height) / 2)];
        [_numView setNumChangedCallback:^(NSInteger num) {
            if(wself.numChangedCallback){
                wself.numChangedCallback(num);
            }
        }];
        [self addSubview:_numView];
        
        UIView* bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [bottomLine setBackgroundColor:kSepLineColor];
        [self addSubview:bottomLine];
    }
    return self;
}
- (void)setNumOfHomework:(NSInteger)numOfHomework{
    _numOfHomework = numOfHomework;
    [_numView setNum:_numOfHomework];
}

- (void)showDetailHint{
    [HomeworkDetailHintView showWithTitle:@"题目数量" description:@"对于开启回复的作业，是方便您在批阅后，可以得到学生作业的正确率." completion:nil];
}
@end
