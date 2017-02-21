//
//  RecordInfoView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 17/2/21.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "RecordInfoView.h"
#import "HYBStarEvaluationView.h"
@interface DailyStatusItemView ()
@property (nonatomic, strong)LogoView* logoView;
@property (nonatomic, strong)UILabel* titleLabel;
@property (nonatomic, strong)HYBStarEvaluationView* starView;
@property (nonatomic, strong)UILabel* commentLabel;
@property (nonatomic, strong)UILabel* evaluteLabel;
@end

@implementation DailyStatusItemView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        UIView* bottomLine = [[UIView alloc] initWithFrame:CGRectMake(10, self.height - kLineHeight, self.width - 10, kLineHeight)];
        [bottomLine setBackgroundColor:kSepLineColor];
        [self addSubview:bottomLine];
        
        UIView* leftLine = [[UIView alloc] initWithFrame:CGRectMake(100, 0, kLineHeight, 50)];
        [leftLine setBackgroundColor:kSepLineColor];
        [self addSubview:leftLine];
        
        UIView* rightLine = [[UIView alloc] initWithFrame:CGRectMake(self.width - 70, 0, kLineHeight, self.height)];
        [rightLine setBackgroundColor:kSepLineColor];
        [self addSubview:rightLine];
        
        UIView* sepLine = [[UIView alloc] initWithFrame:CGRectMake(leftLine.right, self.height / 2, rightLine.left - leftLine.right, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
        
        self.logoView = [[LogoView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [self addSubview:self.logoView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.logoView.right + 10, 0, leftLine.left - (self.logoView.right + 10), 50)];
        [self.titleLabel setText:@"睡觉"];
        [self.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.titleLabel setTextColor:kColor_33];
        [self addSubview:self.titleLabel];
        
        self.starView = [[HYBStarEvaluationView alloc] initWithFrame:CGRectMake(leftLine.right + 5, (sepLine.y - 20) / 2, 70, 20) numberOfStars:3 isVariable:NO];
        [self.starView setIsContrainsHalfStar:YES];
        [self.starView setActualScore:0.6];
        [self addSubview:self.starView];
        
        self.commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLine.right + 5, 25, rightLine.left - leftLine.right - 5 * 2, 25)];
        [self.commentLabel setText:@"教师没有说明"];
        [self.commentLabel setFont:[UIFont systemFontOfSize:13]];
        [self.commentLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [self addSubview:self.commentLabel];
        
        self.evaluteLabel = [[UILabel alloc] initWithFrame:CGRectMake(rightLine.right, 0, 70, 50)];
        [self.evaluteLabel setTextAlignment:NSTextAlignmentCenter];
        [self.evaluteLabel setFont:[UIFont systemFontOfSize:15]];
        [self.evaluteLabel setTextColor:kColor_33];
        [self.evaluteLabel setText:@"非常棒"];
        [self addSubview:self.evaluteLabel];
    }
    return self;
}
@end

@interface RecordInfoView ()
@property (nonatomic, strong)UILabel* hintLabel;
@property (nonatomic, strong)HYBStarEvaluationView* startView;
@property (nonatomic, strong)UIButton* showRuleButton;

@property (nonatomic, strong)NSMutableArray* itemViews;
@end

@implementation RecordInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        self.hintLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.hintLabel setTextColor:kColor_33];
        [self.hintLabel setFont:[UIFont systemFontOfSize:16]];
        [self.hintLabel setText:@"总星星:"];
        [self.hintLabel sizeToFit];
        [self.hintLabel setOrigin:CGPointMake(10, (70 - self.hintLabel.height) / 2)];
        [self addSubview:self.hintLabel];
        
        self.startView = [[HYBStarEvaluationView alloc] initWithFrame:CGRectMake(self.hintLabel.right + 10, (70 - 30) / 2, 90, 30) numberOfStars:3 isVariable:NO];
        [self.startView setIsContrainsHalfStar:YES];
        [self.startView setFullScore:1.f];
        [self.startView setActualScore:0.5];
        [self addSubview:self.startView];
        
        self.showRuleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.showRuleButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateNormal];
        [self.showRuleButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.showRuleButton setTitle:@"查看规则" forState:UIControlStateNormal];
        [self.showRuleButton addTarget:self action:@selector(showRule) forControlEvents:UIControlEventTouchUpInside];
        [self.showRuleButton sizeToFit];
        [self.showRuleButton setOrigin:CGPointMake(self.width - 10 - self.showRuleButton.width, (70 - self.showRuleButton.height) / 2)];
        [self addSubview:self.showRuleButton];
        
        UIView* sepLine = [[UIView alloc] initWithFrame:CGRectMake(10, 70 - kLineHeight, self.width - 10, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
        
        self.itemViews = [NSMutableArray array];
        CGFloat spaceYStart = 70;
        for (NSInteger i = 0; i < 6; i++) {
            DailyStatusItemView* itemView = [[DailyStatusItemView alloc] initWithFrame:CGRectMake(0, spaceYStart, self.width, 50)];
            [self addSubview:itemView];
            [self.itemViews addObject:itemView];
            spaceYStart = itemView.bottom;
        }
        [self setHeight:spaceYStart];
    }
    return self;
}

- (void)setShowTitle:(BOOL)showTitle{
    _showTitle = showTitle;
    [self.hintLabel setHidden:!_showTitle];
    [self.startView setHidden:!_showTitle];
}

- (void)showRule{
    TNBaseWebViewController* webVC = [[TNBaseWebViewController alloc] initWithUrl:[NSURL URLWithString:@"https://www.baidu.com"]];
    [CurrentROOTNavigationVC pushViewController:webVC animated:YES];
}


@end
