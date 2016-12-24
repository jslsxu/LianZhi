//
//  StatisticsMonthHeaderView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/23.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "StatisticsMonthHeaderView.h"

@interface StatisticsMonthHeaderView ()
@property (nonatomic, strong)UIButton* preButton;
@property (nonatomic, strong)UIButton* nextButton;
@property (nonatomic, strong)UILabel* dateLabel;
@property (nonatomic, strong)UILabel* numLabel;
@end

@implementation StatisticsMonthHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.width - 140) / 2, 5, 140, 25)];
        [self.dateLabel setTextAlignment:NSTextAlignmentCenter];
        [self.dateLabel setFont:[UIFont systemFontOfSize:15]];
        [self.dateLabel setTextColor:kColor_33];
        [self.dateLabel setText:@"2016年12月"];
        [self addSubview:self.dateLabel];
        
        self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.width - 140) / 2, self.dateLabel.bottom, 140, 25)];
        [self.numLabel setTextAlignment:NSTextAlignmentCenter];
        [self.numLabel setFont:[UIFont systemFontOfSize:15]];
        [self.numLabel setTextColor:kColor_33];
        [self.numLabel setText:@"应出勤天数:22天"];
        [self addSubview:self.numLabel];
        
        self.preButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.preButton setFrame:CGRectMake(self.dateLabel.left - 30, 0, 30, self.height)];
        [self.preButton setImage:[UIImage imageNamed:@"PreArrowNormal"] forState:UIControlStateNormal];
        [self.preButton addTarget:self action:@selector(onPre) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.preButton];
        
        self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.nextButton setFrame:CGRectMake(self.dateLabel.right, 0, 30, self.height)];
        [self.nextButton setImage:[UIImage imageNamed:@"NextArrowNormal"] forState:UIControlStateNormal];
        [self.nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.nextButton];
    }
    return self;
}

- (void)onPre{
    
}

- (void)onNext{
    
}

@end
