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
#import "MyGiftVC.h"
#import "NotificationSendEntity.h"
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
- (void)inputBarViewDidCommit:(NSString *)text atArray:(NSArray *)atArray;
- (void)inputBarViewDidFaceSelect:(NSString *)face;
- (void)inputBarViewDidSendPhoto:(PhotoItem *)photoItem;
- (void)inputBarViewDidSendPhotoArray:(NSArray *)photoArry;
- (void)inputBarViewDidSendVoice:(AudioItem *)audioItem;
- (void)inputBarViewDidSendGift:(GiftItem *)giftItem;
- (void)inputBarViewDidSendVideo:(VideoItem *)videoItem;
- (void)inputBarViewDidCallTelephone;
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
@property (nonatomic, copy)NSString *classID;
@property (nonatomic, copy)NSString *groupID;
@property (nonatomic, assign)BOOL canSendGift;
@property (nonatomic, assign)BOOL canCallTelephone;
@property (nonatomic, assign)BOOL imDisabled;
@property (nonatomic, assign)InputType inputType;
@property (nonatomic, weak)id<InputBarViewDelegate> inputDelegate;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)addAtUser:(UserInfo *)userInfo;
@end
