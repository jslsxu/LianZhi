//
//  ClassBatOperationView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/5.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ClassBatOperationView.h"

@implementation ClassBatOperationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        _bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:(@"BlueBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [_bgImageView setUserInteractionEnabled:YES];
        [_bgImageView setFrame:self.bounds];
        [self addSubview:_bgImageView];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setFrame:CGRectMake(_bgImageView.width - 48, 6, 48, 48)];
        [_cancelButton setImage:[UIImage imageNamed:@"CancelOperation.png"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(onCancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_bgImageView addSubview:_cancelButton];
        
        _growthButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_growthButton setFrame:CGRectMake(_cancelButton.left - 48, 6, 48, 48)];
        [_growthButton setImage:[UIImage imageNamed:@"GrowthOperation.png"] forState:UIControlStateNormal];
        [_growthButton setBackgroundImage:[UIImage imageNamed:@"OperationBG.png"] forState:UIControlStateNormal];
        [_growthButton addTarget:self action:@selector(onGrowthButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_growthButton setImageEdgeInsets:UIEdgeInsetsMake(-12, 0, 0, 0)];
        [self addTitle:@"成长手册" forButton:_growthButton];
        [_bgImageView addSubview:_growthButton];
        
        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoButton setFrame:CGRectMake(_growthButton.left - 54, 6, 48, 48)];
        [_photoButton setImage:[UIImage imageNamed:@"PhotoOperation.png"] forState:UIControlStateNormal];
        [_photoButton setBackgroundImage:[UIImage imageNamed:@"OperationBG.png"] forState:UIControlStateNormal];
        [_photoButton addTarget:self action:@selector(onPhotoButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_photoButton setImageEdgeInsets:UIEdgeInsetsMake(-12, 0, 0, 0)];
        [self addTitle:@"照片分享" forButton:_photoButton];
        [_bgImageView addSubview:_photoButton];
        
        _messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageButton setFrame:CGRectMake(_photoButton.left - 54, 6, 48, 48)];
        [_messageButton setImage:[UIImage imageNamed:@"MessageOperation.png"] forState:UIControlStateNormal];
        [_messageButton setBackgroundImage:[UIImage imageNamed:@"OperationBG.png"] forState:UIControlStateNormal];
        [_messageButton addTarget:self action:@selector(onMessageButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_messageButton setImageEdgeInsets:UIEdgeInsetsMake(-12, 0, 0, 0)];
        [self addTitle:@"消息通知" forButton:_messageButton];
        [_bgImageView addSubview:_messageButton];
        
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 18)];
        [_numLabel setBackgroundColor:[UIColor clearColor]];
        [_numLabel setTextColor:[UIColor whiteColor]];
        [_numLabel setFont:[UIFont systemFontOfSize:14]];
        [_numLabel setTextAlignment:NSTextAlignmentCenter];
        [_bgImageView addSubview:_numLabel];
        
        
         _selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectAllButton addTarget:self action:@selector(onSelectAllButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_selectAllButton setBackgroundColor:[UIColor whiteColor]];
        [_selectAllButton.layer setCornerRadius:8];
        [_selectAllButton.layer setMasksToBounds:YES];
         [_selectAllButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateNormal];
        [_selectAllButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_selectAllButton setTitle:@"选择全部" forState:UIControlStateNormal];
         [_selectAllButton setFrame:CGRectMake(15, _numLabel.bottom + 4, 60, 20)];
         [_bgImageView addSubview:_selectAllButton];
        
        _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - 20, self.width, 20)];
        [_hintLabel setBackgroundColor:[UIColor clearColor]];
        [_hintLabel setFont:[UIFont systemFontOfSize:14]];
        [_hintLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_hintLabel setText:@"下拉屏幕可批量操作哦"];
        [_hintLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_hintLabel];
        
        _bgImageView.alpha = 0.f;
    }
    return self;
}

- (void)setGrowthRecord:(BOOL)growthRecord
{
    _growthRecord = growthRecord;
    _growthButton.hidden = !_growthRecord;
    
    if(_growthRecord)
    {
        [_growthButton setFrame:CGRectMake(_cancelButton.left - 48, 6, 48, 48)];
        [_photoButton setFrame:CGRectMake(_growthButton.left - 54, 6, 48, 48)];
        [_messageButton setFrame:CGRectMake(_photoButton.left - 54, 6, 48, 48)];
    }
    else
    {
        CGFloat width = _cancelButton.left - _selectAllButton.right;
        [_photoButton setFrame:CGRectMake(_selectAllButton.right + width / 2 + 10, 6, 48, 48)];
        [_messageButton setFrame:CGRectMake(_selectAllButton.right + width / 2 - 10 - 48, 6, 48, 48)];
    }
    
}

- (void)setSourceArray:(NSArray *)sourceArray
{
    _sourceArray = sourceArray;
    id obj = [sourceArray objectAtIndex:0];
    if([obj isKindOfClass:[StudentInfo class]])
    {
        NSInteger num = 0;
        for (StudentInfo *student in sourceArray) {
            if(student.selected)
                num++;
        }
        if(num < sourceArray.count || sourceArray.count == 0)
            [_selectAllButton setTitle:@"选择全部" forState:UIControlStateNormal];
        else
            [_selectAllButton setTitle:@"取消选择" forState:UIControlStateNormal];
        [_numLabel setText:[NSString stringWithFormat:@"%ld人",(long)num]];
    }
    else if([obj isKindOfClass:[ClassInfo class]])
    {
        NSInteger num = 0;
        for (ClassInfo *classInfo in sourceArray) {
            if(classInfo.canSelected && classInfo.selected)
                num++;
        }
        if(num < sourceArray.count || sourceArray.count == 0)
            [_selectAllButton setTitle:@"选择全部" forState:UIControlStateNormal];
        else
            [_selectAllButton setTitle:@"取消选择" forState:UIControlStateNormal];
        [_numLabel setText:[NSString stringWithFormat:@"%ld个班",(long)num]];
    }
}

- (void)reset
{
    [self setShow:NO];
    [self setSourceArray:nil];
    [_numLabel setText:nil];
}

- (void)addTitle:(NSString *)title forButton:(UIButton *)button
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setUserInteractionEnabled:NO];
    [titleLabel setTextColor:kCommonTeacherTintColor];
    [titleLabel setFont:[UIFont systemFontOfSize:9]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:title];
    [titleLabel sizeToFit];
    [titleLabel setCenter:CGPointMake(button.width / 2, button.height * 3 / 4)];
    [button addSubview:titleLabel];
}

- (void)setShow:(BOOL)show
{
    _show = show;
    if(_show)
    {
        _bgImageView.alpha = 1.f;
        _hintLabel.alpha = 0.f;
    }
    else
    {
        _bgImageView.alpha = 0.f;
        _hintLabel.alpha = 1.f;
    }
}

- (void)onSelectAllButtonClicked
{
    if([[_selectAllButton titleForState:UIControlStateNormal] isEqualToString:@"选择全部"])
    {
        for (id obj in self.sourceArray) {
            [obj setSelected:YES];
        }
        [self setSourceArray:self.sourceArray];
        if([self.delegate respondsToSelector:@selector(classBatOperationSelectAll)])
            [self.delegate classBatOperationSelectAll];
    }
    else
    {
        for (id obj in self.sourceArray) {
            [obj setSelected:NO];
        }
        [self setSourceArray:self.sourceArray];
        if([self.delegate respondsToSelector:@selector(classBatOperationSelectAll)])
            [self.delegate classBatOperationSelectAll];
    }
}

- (void)onMessageButtonClicked
{
    if([self.delegate respondsToSelector:@selector(classBatOperationOnMessage)])
        [self.delegate classBatOperationOnMessage];
}

- (void)onPhotoButtonClicked
{
    if([self.delegate respondsToSelector:@selector(classBatOperationOnPhotoShare)])
        [self.delegate classBatOperationOnPhotoShare];
}

- (void)onGrowthButtonClicked
{
    if([self.delegate respondsToSelector:@selector(classBatOperationOnGrowthTimeline)])
        [self.delegate classBatOperationOnGrowthTimeline];
}

- (void)onCancelButtonClicked
{
    if([self.delegate respondsToSelector:@selector(classBatOperationCancel)])
        [self.delegate classBatOperationCancel];
}


@end
