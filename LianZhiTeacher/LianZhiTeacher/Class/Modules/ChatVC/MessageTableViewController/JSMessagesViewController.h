

#import <UIKit/UIKit.h>
#import "InputBarView.h"
#import "MessageCell.h"
#import "ChatMessageModel.h"
@interface JSMessagesViewController : TNBaseTableViewController <InputBarViewDelegate, MessageCellDelegate>
{
    InputBarView*           _inputView;
    CGFloat                 _previousTextViewContentHeight;
    NSTimer*                _timer;
}
@property (nonatomic, copy)NSString *targetID;
@property (nonatomic, copy)NSString *to_objid;
@property (nonatomic, assign)ChatType chatType;
@property (nonatomic, copy)NSString *userID;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *mobile;
@end