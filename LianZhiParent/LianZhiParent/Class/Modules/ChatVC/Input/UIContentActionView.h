//
//  UIContentActionView.h
//  Photographer
//
//  Created by  dong jianbo on 12-4-10.
//  Copyright (c) 2012年 mafengwo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceSelectView.h"
#import "HPGrowingTextView.h"
#import "MFWFace.h"
#define CONTENT_ACTION_WIDTH        kScreenWidth
#define CONTENT_TEXTINPUT_HEIGHT    44
#define CONTENT_ACTION_HEIGHT       (CONTENT_TEXTINPUT_HEIGHT + FACESELECT_HEIGHT)


typedef enum {
    ActionViewMoveByDefault = 0,
    ActionViewMoveByKeyBoardWillShow,
    ActionViewMoveByKeyBoardWillHiden,
    ActionViewMoveByFacePanelWillShow
}enumActionViewMoveType;

typedef enum {
    InputType_Sound,
    InputType_Keyboard,
    InputType_Face
}InputType;

@class UIContentActionView;
@protocol UIContentActionViewDelegate <NSObject>
@optional
- (void) onActionViewInputChange:(NSString*)content;  // 编辑框内容改变
- (void) onActionViewHeightChanged:(CGFloat)height;
- (void) onActionViewCommit:(NSString*)content;       // 确认发送
- (void) onActionViewYChanged:(CGFloat)newY;
- (void) keyboardDidShow;
- (void) keyboardDidScrollToPoint:(CGPoint)pt;
- (void) keyboardWillBeDismissed;
- (void) keyboardWillSnapBackToPoint:(CGPoint)pt;
@end

@interface UIContentActionView : UIView <HPGrowingTextViewDelegate, ContentActionInputDelegate>
{
    UIView*                 _contentView;
    UIButton*               _soundButton;
    UIButton*               _switchKeyboardButton;
    FaceSelectView*         _faceView;
    HPGrowingTextView*      _expandingTextView;
    NSRange                 _selectRange;
}

@property (nonatomic, weak)id<UIContentActionViewDelegate> delegate;
@property (nonatomic, retain)UIView*    keyboard;
@property (nonatomic, assign)CGFloat originalKeyboardY;
@property (nonatomic, assign)InputType inputType;
@property (nonatomic, readonly)CGFloat inputHeight;
- (void) setText:(NSString *)text;

@end
