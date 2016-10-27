//
//  HomeworkExplainView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkExplainView.h"

@interface HomeworkExplainView ()
@property (nonatomic, strong)UILabel*       stateLabel;
@property (nonatomic, strong)UIImageView*   rightArrow;
@end

@implementation HomeworkExplainView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [titleLabel setFont:[UIFont systemFontOfSize:15]];
        [titleLabel setText:@"添加作业解析"];
        [titleLabel sizeToFit];
        [titleLabel setOrigin:CGPointMake(12, (self.height - titleLabel.height) / 2)];
        [self addSubview:titleLabel];

        
        self.rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]];
        [self.rightArrow setOrigin:CGPointMake(self.width - 10 - self.rightArrow.width, (self.height - self.rightArrow.height) / 2)];
        [self addSubview:self.rightArrow];
        
        self.stateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.stateLabel setFont:[UIFont systemFontOfSize:14]];
        [self.stateLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [self.stateLabel setText:@"已添加"];
        [self.stateLabel sizeToFit];
        [self.stateLabel setOrigin:CGPointMake(self.rightArrow.left - 10 - self.stateLabel.width , (self.height - self.stateLabel.height) / 2)];
        [self.stateLabel setHidden:YES];
        [self addSubview:self.stateLabel];
        
        UIView* sepLine = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setHomeworkExplain)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setHasExplain:(BOOL)hasExplain{
    _hasExplain = hasExplain;
    [self.stateLabel setHidden:!_hasExplain];
}

- (void)setHomeworkExplain{
    if(self.explainClick){
        self.explainClick();
    }
}

@end
