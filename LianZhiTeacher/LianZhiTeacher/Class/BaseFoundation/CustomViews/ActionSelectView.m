//
//  ActionSelectView.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/7.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ActionSelectView.h"

#define kActionHeight                   200

@interface ActionSelectView()
@property (nonatomic, assign)NSInteger component;
@property (nonatomic, assign)NSInteger row;

@end

@implementation ActionSelectView

- (instancetype)init
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgButton setFrame:self.bounds];
        [_bgButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        [_bgButton addTarget:self action:@selector(onBGButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bgButton];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0,self.height, self.width, kActionHeight)];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_contentView];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentView.width, 1)];
        [sepLine setBackgroundColor:[UIColor colorWithHexString:@"666666"]];
        [_contentView addSubview:sepLine];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"fc6e82"] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateHighlighted];
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_cancelButton setFrame:CGRectMake(0, 0, 60, 36)];
        [_contentView addSubview:_cancelButton];
        
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setFrame:CGRectMake(self.width - 60, (36 - 20) / 2, 50, 20)];
        [_confirmButton addTarget:self action:@selector(onConfirm) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton setBackgroundImage:[UIImage imageWithColor:kCommonTeacherTintColor size:_confirmButton.size cornerRadius:10] forState:UIControlStateNormal];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateHighlighted];
        [_confirmButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_contentView addSubview:_confirmButton];
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 36, self.width, 200)];
        [_pickerView setShowsSelectionIndicator:NO];
        [_pickerView setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
        [_pickerView setDelegate:self];
        [_pickerView setDataSource:self];
        [_contentView addSubview:_pickerView];
        [_contentView setHeight:36 + _pickerView.height];
    }
    return self;
}

- (void)onCancel
{
    [self dismiss];
}

- (void)onConfirm
{
    [self dismiss];
    if([self.delegate respondsToSelector:@selector(pickerViewFinished:didSelectRow:inComponent:)])
        [self.delegate pickerViewFinished:self didSelectRow:self.row inComponent:self.component];
}

- (void)onBGButtonClicked
{
    [self dismiss];
}

- (void)show
{
    _bgButton.alpha = 0.f;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        _bgButton.alpha = 1.f;
        [_contentView setY:self.height - _contentView.height];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        _bgButton.alpha = 0.f;
        [_contentView setY:self.height];
    }completion:^(BOOL finished) {
        [self  removeFromSuperview];
    }];
}


#pragma mark - UIPickerDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if([self.delegate respondsToSelector:@selector(numberOfComponentsInPickerView:)])
        return [self.delegate numberOfComponentsInPickerView:self];
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([self.delegate respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)])
        return [self.delegate pickerView:self numberOfRowsInComponent:component];
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if([self.delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)])
        return [self.delegate pickerView:self titleForRow:row forComponent:component];
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.row = row;
    self.component = component;
    if([self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)])
        [self.delegate pickerView:self didSelectRow:row inComponent:component];
}
@end
