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
#import "FunctionView.h"
#import "UUProgressHUD.h"
typedef NS_ENUM(NSInteger, InputType)
{
    InputTypeNone = -1,
    InputTypeNormal = 0,
    InputTypeFace,
    InputTypeSound,
    InputTypeAdd
};

@protocol InputBarViewDelegate <NSObject>
- (void)inputBarViewDidChangeHeight:(NSInteger)height;
- (void)inputBarViewDidCommit:(NSString *)text;
- (void)inputBarViewDidFaceSelect:(NSString *)face;
- (void)inputBarViewDidSendPhoto:(UIImage *)image;
- (void)inputBarViewDidSendVoice:(NSData *)amrData;
@end

@interface InputBarView : UIView<HPGrowingTextViewDelegate, FaceSelectViewDelegate, FunctionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIView*             _contentView;
    UIButton*           _soundButton;
    UIButton*           _recordButton;
    UIButton*           _exchangeButton;
    UIButton*           _addButton;
    HPGrowingTextView*  _inputView;
    FaceSelectView*     _faceSelectView;
    FunctionView*       _functionView;
}
@property (nonatomic, assign)InputType inputType;
@property (nonatomic, weak)id<InputBarViewDelegate> inputDelegate;
- (instancetype)initWithFrame:(CGRect)frame;
@end
