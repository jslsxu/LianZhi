//
//  PhotoFlowHeaderView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 2017/4/18.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "PhotoFlowHeaderView.h"

@interface PhotoFlowHeaderView ()
@property (nonatomic, strong)UIView* line;
@property (nonatomic, strong)UILabel* yearLabel;
@property (nonatomic, strong)UILabel* dayLabel;
@end

@implementation PhotoFlowHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.line = [[UIView alloc] initWithFrame:CGRectMake(20, (kYearHeight - kLineHeight) / 2, self.width - 20 * 2, kLineHeight)];
        [self.line setBackgroundColor:kSepLineColor];
        [self addSubview:self.line];
        
        self.yearLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.yearLabel setBackgroundColor:[UIColor whiteColor]];
        [self.yearLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [self.yearLabel setTextColor:kColor_33];
        [self.yearLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.yearLabel];
        
        self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, kYearHeight, self.width - 8 * 2, kDayHeight)];
        [self.dayLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [self addSubview:self.dayLabel];
    }
    return self;
}

- (void)setYear:(NSString *)year{
    if([year length] == 0){
        [self setHeight:kDayHeight];
        [self.line setHidden:YES];
        [self.yearLabel setHidden:YES];
    }
    else{
        [self setHeight:kDayHeight + kYearHeight];
        [self.line setHidden:NO];
        [self.yearLabel setHidden:NO];
        [self.yearLabel setText:year];
        [self.yearLabel sizeToFit];
        [self.yearLabel setWidth:self.yearLabel.width + 20];
        [self.yearLabel setCenter:CGPointMake(self.width / 2, kYearHeight / 2)];
    }
    [self.dayLabel setBottom:self.height];
}

- (void)setDay:(NSString *)day{
    [self.dayLabel setText:day];
}
@end
