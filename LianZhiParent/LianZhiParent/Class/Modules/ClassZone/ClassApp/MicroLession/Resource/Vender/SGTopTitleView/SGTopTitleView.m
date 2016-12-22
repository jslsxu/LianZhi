//
//  SGTopTitleView.m
//  SGTopTitleViewExample
//
//  Created by Sorgle on 16/8/24.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

// 欢迎来GitHub下载最新Demo
// GitHub下载地址：https://github.com/kingsic/SGTopTitleView.git

#import "SGTopTitleView.h"
#import "UIView+SGExtension.h"
#import "ResourceDefine.h"

#define labelFontOfSize [UIFont systemFontOfSize:17]
#define SG_screenWidth [UIScreen mainScreen].bounds.size.width
#define selectedTitleAndIndicatorViewColor [UIColor redColor]

@interface SGTopTitleView ()
/** 静止标题Label */
@property (nonatomic, strong) UILabel *staticTitleLabel;

@property (nonatomic, strong) UILabel *sepLabel;
/** 滚动标题Label */
@property (nonatomic, strong) UILabel *scrollTitleLabel;
/** 选中标题时的Label */
@property (nonatomic, strong) UILabel *selectedTitleLabel;
/** 指示器 */
@property (nonatomic, strong) UIView *indicatorView;
@end

@implementation SGTopTitleView

/** label之间的间距(滚动时TitleLabel之间的间距) */
static CGFloat const labelMargin = 15;
/** 指示器的高度 */
static CGFloat const indicatorHeight = 2;

- (NSMutableArray *)allTitleLabel {
    if (_allTitleLabel == nil) {
        _allTitleLabel = [NSMutableArray array];
    }
    return _allTitleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.sepLabel=[[UILabel alloc]initWithFrame:CGRectMake(0 ,0, self.width , 1)];
        
        [self.sepLabel setBackgroundColor:SepLineColor];
        [self addSubview:self.sepLabel];
        
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
    }
    return self;
}

+ (instancetype)topTitleViewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}


/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


#pragma mark - - - 重写静止标题数组的setter方法
- (void)setStaticTitleArr:(NSArray *)staticTitleArr {
    _staticTitleArr = staticTitleArr;
    
    // 计算scrollView的宽度
    CGFloat scrollViewWidth = self.frame.size.width;
    CGFloat labelX = 0;
    CGFloat labelY = 5;
//    CGFloat labelW = scrollViewWidth / self.staticTitleArr.count;
//    CGFloat labelH = self.frame.size.height - indicatorHeight * 0.5;
    
    CGFloat labelW = 35;
    CGFloat labelH = 35;
    CGFloat labelSpace = 25;
    
    for (NSInteger j = 0; j < self.staticTitleArr.count; j++) {
        // 创建静止时的标题Label
        self.staticTitleLabel = [[UILabel alloc] init];
        _staticTitleLabel.userInteractionEnabled = YES;
        _staticTitleLabel.text = self.staticTitleArr[j];
        _staticTitleLabel.textAlignment = NSTextAlignmentCenter;
        _staticTitleLabel.tag = j;
        
        // 设置高亮文字颜色
        _staticTitleLabel.highlightedTextColor = selectedTitleAndIndicatorViewColor;
        
        // 计算staticTitleLabel的x值
        labelX = j * labelW + labelSpace;
        
        _staticTitleLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        // 添加到titleLabels数组
        [self.allTitleLabel addObject:_staticTitleLabel];
        
        // 添加点按手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(staticTitleClick:)];
        [_staticTitleLabel addGestureRecognizer:tap];
        
        [_staticTitleLabel.layer setCornerRadius:(_selectedTitleLabel.frame.size.width /2 )];
        [_staticTitleLabel.layer setMasksToBounds:YES];
        [_staticTitleLabel setFont:[UIFont boldSystemFontOfSize:22]];
        [_staticTitleLabel setBackgroundColor:GreenLblColor];
        [_staticTitleLabel setTextColor:WhiteColor];
        _staticTitleLabel.layer.borderColor=[UIColor whiteColor].CGColor;
        
        // 默认选中第0个label
        if (j == 0) {
            [self staticTitleClick:tap];
        }
        
        [self addSubview:_staticTitleLabel];
    }
    
    // 取出第一个子控件
    UILabel *firstLabel = self.subviews.firstObject;
    
    // 添加指示器
    self.indicatorView = [[UIView alloc] init];
    _indicatorView.backgroundColor = selectedTitleAndIndicatorViewColor;
    _indicatorView.SG_height = indicatorHeight;
    _indicatorView.SG_y = self.frame.size.height - indicatorHeight;
    [self addSubview:_indicatorView];
    
    
    // 指示器默认在第一个选中位置
    // 计算TitleLabel内容的Size
    CGSize labelSize = [self sizeWithText:firstLabel.text font:labelFontOfSize maxSize:CGSizeMake(MAXFLOAT, labelH)];
    _indicatorView.SG_width = labelSize.width;
    _indicatorView.SG_centerX = firstLabel.SG_centerX;
}

/** staticTitleClick的点击事件 */
- (void)staticTitleClick:(UITapGestureRecognizer *)tap {
    // 0.获取选中的label
    UILabel *selLabel = (UILabel *)tap.view;
    
    // 1.标题颜色变成红色,设置高亮状态下的颜色， 以及指示器位置
    [self staticTitleLabelSelecteded:selLabel];
    
    // 2.代理方法实现
    NSInteger index = selLabel.tag;
    if ([self.delegate_SG respondsToSelector:@selector(SGTopTitleView:didSelectTitleAtIndex:)]) {
        [self.delegate_SG SGTopTitleView:self didSelectTitleAtIndex:index];
    }
}

/** 静止标题选中颜色改变以及指示器位置变化 */
- (void)staticTitleLabelSelecteded:(UILabel *)label {
    // 取消高亮
    _selectedTitleLabel.highlighted = NO;
    
    // 颜色恢复
    _selectedTitleLabel.textColor = [UIColor blackColor];
    
    // 高亮
    label.highlighted = YES;
    
    _selectedTitleLabel = label;
    
    // 改变指示器位置
    [UIView animateWithDuration:0.20 animations:^{
        // 计算内容的Size
        CGSize labelSize = [self sizeWithText:_selectedTitleLabel.text font:labelFontOfSize maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height - indicatorHeight)];
        self.indicatorView.SG_width = labelSize.width;
        self.indicatorView.SG_centerX = label.SG_centerX;
    }];
}


#pragma mark - - - 重写滚动标题数组的setter方法
- (void)setScrollTitleArr:(NSArray *)scrollTitleArr {
    _scrollTitleArr = scrollTitleArr;
    
    CGFloat labelX = 25;
    CGFloat labelY = 5;
//    CGFloat labelH = self.frame.size.height - indicatorHeight * 0.5;
    
    CGFloat labelH = 35;
    CGFloat labelSpace = 25;
    CGFloat labelW = 35;
    for (NSUInteger i = 0; i < self.scrollTitleArr.count; i++) {
        /** 创建滚动时的标题Label */
        self.scrollTitleLabel = [[UILabel alloc] init];
        _scrollTitleLabel.userInteractionEnabled = YES;
        _scrollTitleLabel.text = self.scrollTitleArr[i];
        _scrollTitleLabel.textAlignment = NSTextAlignmentCenter;
        _scrollTitleLabel.tag = i;
        
        
        
        // 设置高亮文字颜色
//        _scrollTitleLabel.highlightedTextColor = selectedTitleAndIndicatorViewColor;
        
        // 计算内容的Size
//        CGSize labelSize = [self sizeWithText:_scrollTitleLabel.text font:labelFontOfSize maxSize:CGSizeMake(MAXFLOAT, labelH)];
        // 计算内容的宽度
//        CGFloat labelW = labelSize.width + 2 * labelMargin;
        
        
        _scrollTitleLabel.frame = CGRectMake(labelX , labelY, labelW, labelH);
        [self setTitleStyle:LZTestNoAnswer  Label:_scrollTitleLabel];
        // 计算每个label的X值
        labelX = labelX + labelW  + labelSpace;
        
        // 添加到titleLabels数组
        [self.allTitleLabel addObject:_scrollTitleLabel];
        
        // 添加点按手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTitleClick:)];
        [_scrollTitleLabel addGestureRecognizer:tap];
        
        // 默认选中第0个label
//        if (i == 0) {
//            [self scrollTitleClick:tap];
//        }
        [self setTitleStyle:LZTestNoAnswer  Label:_scrollTitleLabel];
        [self addSubview:_scrollTitleLabel];
    }
    
    // 计算scrollView的宽度
    CGFloat scrollViewWidth = CGRectGetMaxX(self.subviews.lastObject.frame) + labelSpace;
    scrollViewWidth = scrollViewWidth < self.frame.size.width ? self.frame.size.width : scrollViewWidth;
    self.contentSize = CGSizeMake(scrollViewWidth, self.frame.size.height);
    self.sepLabel.frame = CGRectMake(0 ,0, scrollViewWidth , 1);
//    // 取出第一个子控件
//    UILabel *firstLabel = self.subviews.firstObject;
//    
//    // 添加指示器
//    self.indicatorView = [[UIView alloc] init];
//    _indicatorView.backgroundColor = selectedTitleAndIndicatorViewColor;
//    _indicatorView.SG_height = indicatorHeight;
//    _indicatorView.SG_y = self.frame.size.height - indicatorHeight;
//    [self addSubview:_indicatorView];
//    
//    
//    // 指示器默认在第一个选中位置
//    // 计算TitleLabel内容的Size
//    CGSize labelSize = [self sizeWithText:firstLabel.text font:labelFontOfSize maxSize:CGSizeMake(MAXFLOAT, labelH)];
//    _indicatorView.SG_width = labelSize.width;
//    _indicatorView.SG_centerX = firstLabel.SG_centerX;
}

/** scrollTitleClick的点击事件 */
- (void)scrollTitleClick:(UITapGestureRecognizer *)tap {
    // 0.获取选中的label
    UILabel *selLabel = (UILabel *)tap.view;
    
    // 1.标题颜色变成红色,设置高亮状态下的颜色， 以及指示器位置
    [self scrollTitleLabelSelecteded:selLabel];
    
    // 2.让选中的标题居中 (当contentSize 大于self的宽度才会生效)
    [self scrollTitleLabelSelectededCenter:selLabel];
    
    // 3.代理方法实现
    NSInteger index = selLabel.tag;
    if ([self.delegate_SG respondsToSelector:@selector(SGTopTitleView:didSelectTitleAtIndex:)]) {
        [self.delegate_SG SGTopTitleView:self didSelectTitleAtIndex:index];
    }
}


-(void) setLabelStyle:(UILabel *)label  TestStatus:(LZTestStatus)status
{
    switch (status) {
        case LZTestCorrect:
            [label setBackgroundColor:GreenResultInstructionColor];
            [label setTextColor:WhiteColor];
            label.layer.borderColor = ClearColor.CGColor;
            break;
        case LZTestNoAnswer:
            [label setBackgroundColor:ClearColor];
            label.layer.borderWidth = 1;
            label.layer.borderColor = GreenLblColor.CGColor;
            [label setTextColor:GreenLblColor];
            break;
        default:
        {
            [label setBackgroundColor:RedResultColor];
            [label setTextColor:WhiteColor];
            label.layer.borderColor = ClearColor.CGColor;
        }
            break;
    }
}

/** 滚动标题选中颜色改变以及指示器位置变化 */
- (void)scrollTitleLabelSelecteded:(UILabel *)label {
    
    // 取消高亮
//    _selectedTitleLabel.highlighted = NO;
    
    // 颜色恢复
//    [self setTitleStyle:LZTestNoAnswer  Label:label];
    // 高亮
//    label.highlighted = YES;
    
//    [label.layer setCornerRadius:(_selectedTitleLabel.frame.size.width /2 )];
//    [label.layer setMasksToBounds:YES];
//    [label setFont:[UIFont boldSystemFontOfSize:22]];
//    [label setBackgroundColor:GreenLblColor];
//    [label setTextColor:WhiteColor];
    
    _selectedTitleLabel = label;
    
//    // 改变指示器位置
//    if (_showsTitleBackgroundIndicatorStyle == YES) {
//        [UIView animateWithDuration:0.20 animations:^{
//            self.indicatorView.SG_width = label.SG_width - labelMargin;
//            self.indicatorView.SG_centerX = label.SG_centerX;
//        }];
//    } else {
//        [UIView animateWithDuration:0.20 animations:^{
//            self.indicatorView.SG_width = label.SG_width - 2 * labelMargin;
//            self.indicatorView.SG_centerX = label.SG_centerX;
//        }];
//    }
}

/** 滚动标题选中居中 */
- (void)scrollTitleLabelSelectededCenter:(UILabel *)centerLabel {
    // 计算偏移量
    CGFloat offsetX = centerLabel.center.x - SG_screenWidth * 0.5;
    
    if (offsetX < 0) offsetX = 0;
    
    // 获取最大滚动范围
    CGFloat maxOffsetX = self.contentSize.width - SG_screenWidth;
    
    if (offsetX > maxOffsetX) offsetX = maxOffsetX;
    
    // 滚动标题滚动条
    [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}


#pragma mark - - - setter
- (void)setIsHiddenIndicator:(BOOL)isHiddenIndicator {
    if (isHiddenIndicator == YES) {
        [self.indicatorView removeFromSuperview];
    }
}

- (void)setTitleAndIndicatorColor:(UIColor *)titleAndIndicatorColor {
    _titleAndIndicatorColor = titleAndIndicatorColor;
    
    for (UIView *subViews in self.allTitleLabel) {
        UILabel *label = (UILabel *)subViews;
        label.highlightedTextColor = titleAndIndicatorColor;
    }
    _indicatorView.backgroundColor = titleAndIndicatorColor;
}

//- (void)setShowsTitleBackgroundIndicatorStyle:(BOOL)showsTitleBackgroundIndicatorStyle {
//    _showsTitleBackgroundIndicatorStyle = showsTitleBackgroundIndicatorStyle;
//    
//    if (showsTitleBackgroundIndicatorStyle == YES) {
//        
//        [self.indicatorView removeFromSuperview];
//        
//        // 取出第一个子控件
//        UILabel *firstLabel = self.subviews.firstObject;
//        
//        // 添加指示器
//        self.indicatorView = [[UIView alloc] init];
//        _indicatorView.backgroundColor = selectedTitleAndIndicatorViewColor;
//        _indicatorView.SG_height = indicatorHeight;
//        _indicatorView.SG_y = self.frame.size.height - indicatorHeight;
//        [self addSubview:_indicatorView];
//        
//        // 指示器默认在第一个选中位置
//        // 计算TitleLabel内容的Size
//        CGSize labelSize = [self sizeWithText:firstLabel.text font:labelFontOfSize maxSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
//        _indicatorView.SG_width = labelSize.width + labelMargin;
//        _indicatorView.SG_centerX = firstLabel.SG_centerX;
//        
//        CGFloat indicatorViewHeight = 25;
//        self.indicatorView.SG_height = indicatorViewHeight;
//        self.indicatorView.SG_y = (self.frame.size.height - indicatorViewHeight) * 0.5;
//    }
//    
//    self.indicatorView.alpha = 0.3;
//    self.indicatorView.layer.cornerRadius = 5;
//    self.indicatorView.layer.masksToBounds = YES;
//}

- (void)setTitleStyle:(LZTestStatus)btnStatus  Label:(UILabel *)label {
    
    switch (btnStatus) {
        case LZTestCorrect:
            [label.layer setCornerRadius:(label.frame.size.width /2 )];
            [label.layer setMasksToBounds:YES];
            [label setFont:[UIFont boldSystemFontOfSize:22]];
            [label setBackgroundColor:GreenResultColor];
            [label setTextColor:WhiteColor];
            
            break;
        case LZTestWrong:
            [label.layer setCornerRadius:(label.frame.size.width /2 )];
            [label.layer setMasksToBounds:YES];
            [label setFont:[UIFont boldSystemFontOfSize:22]];
            [label setBackgroundColor:RedResultColor];
            [label setTextColor:WhiteColor];
            label.layer.borderColor=RedResultColor.CGColor;
            label.layer.borderWidth = 1;
            break;
        case LZTestWithAnswer:
            [label.layer setCornerRadius:(label.frame.size.width /2 )];
            [label.layer setMasksToBounds:YES];
            [label setFont:[UIFont boldSystemFontOfSize:22]];
            label.layer.borderWidth = 1;
            [label setBackgroundColor:WhiteColor];
            [label setTextColor:GreenLblColor];
            label.layer.borderColor=GreenLblColor.CGColor;
            break;
        default:
            [label.layer setCornerRadius:(label.frame.size.width /2 )];
            [label.layer setMasksToBounds:YES];
            [label setFont:[UIFont boldSystemFontOfSize:22]];
            label.layer.borderWidth = 1;
            [label setBackgroundColor:WhiteColor];
            [label setTextColor:GreenLblColor];
            label.layer.borderColor=GreenLblColor.CGColor;
            break;
    }
}
@end




