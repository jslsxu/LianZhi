//
//  ActionSelectView.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/7.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ActionSelectView;
@protocol ActionSelectViewDelegate <NSObject>
@optional
- (NSInteger)numberOfComponentsInPickerView:(ActionSelectView *)pickerView;
- (NSInteger)pickerView:(ActionSelectView *)pickerView numberOfRowsInComponent:(NSInteger)component;
- (NSString *)pickerView:(ActionSelectView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (void)pickerView:(ActionSelectView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)pickerViewFinished:(ActionSelectView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
@end

@interface ActionSelectView : UIView<UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIButton*       _bgButton;
    UIView*         _contentView;
    UIButton*       _cancelButton;
    UIButton*       _confirmButton;
    UIPickerView*   _pickerView;
}
@property (nonatomic, readonly)UIPickerView *pickerView;
@property (nonatomic, weak)id<ActionSelectViewDelegate> delegate;
- (void)show;
- (void)dismiss;
@end
