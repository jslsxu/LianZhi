//
//  InputBarView.h
//  LianZhiParent
//
//  Created by jslsxu on 15/9/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "FaceSelectView.h"
#import "ExtraMessageView.h"
typedef NS_ENUM(NSInteger, InputType)
{
    InputTypeNormal,
    InputTypeFace,
    InputTypeSound,
    InputTypeAdd
};

@protocol InputBarViewDelegate <NSObject>
- (void)inputBarViewWillChangeHeight:(NSInteger)height;
- (void)inputBarViewDidChangeHeight:(NSInteger)height;
- (void)inputBarViewDidCommit:(NSString *)text;
@end

@interface InputBarView : UIToolbar<HPGrowingTextViewDelegate, ContentActionInputDelegate, ExtraMessageViewDelegate>
{
    UIView*             _contentView;
    UIButton*           _soundButton;
    UIButton*           _exchangeButton;
    UIButton*           _sendButton;
    HPGrowingTextView*  _inputView;
    FaceSelectView*     _faceSelectView;
    ExtraMessageView*   _extraMessageView;
}
@property (nonatomic, assign)InputType inputType;
@property (nonatomic, weak)id<InputBarViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame;
@end
