//
//  HomeworkExplainView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkExplainView.h"

@interface HomeworkExplainView ()
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
        
        UIView* sepLine = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setHomeworkExplain)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setHomeworkExplain{
    if(self.explainClick){
        self.explainClick();
    }
}

@end
