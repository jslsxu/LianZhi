//
//  ReplyBox.h
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

typedef enum {
    ActionViewMoveByDefault = 0,
    ActionViewMoveByKeyBoardWillShow,
    ActionViewMoveByKeyBoardWillHiden,
    ActionViewMoveByFacePanelWillShow
}enumActionViewMoveType;

// 回复框高度为100px
#define REPLY_BOX_HEIGHT 50.0f

@protocol ReplyBoxDelegate <NSObject>
@optional
// 界面移动
- (void) onActionViewMove:(UIView*)actionView Duration:(CGFloat)duration Type:(enumActionViewMoveType)type;
// 取消输入
- (void) onActionViewCancel;
// 编辑框内容改变
- (void) onActionViewInputChange:(NSString*)content;
// 确认发送
- (void) onActionViewCommit:(NSString*)content;
@end

@interface ReplyBox : UIView
@property(nonatomic, weak)id<ReplyBoxDelegate> delegate;
- (void) setText:(NSString *)text;
- (void) setTextAndBecomeFirstResponder:(NSString *)text;
- (void) setPlaceHolder:(NSString *)text;
- (NSString*) getText;
- (void) assignFocus;
- (void) resignFocus;
@end
