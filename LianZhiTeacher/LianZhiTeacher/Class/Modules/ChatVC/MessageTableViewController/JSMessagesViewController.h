

#import <UIKit/UIKit.h>
#import "InputBarView.h"
#import "MessageCell.h"
#import "ChatMessageModel.h"
#import "GiftDetailView.h"
@interface JSMessagesViewController : TNBaseViewController <InputBarViewDelegate, MessageCellDelegate, UITableViewDelegate, UITableViewDataSource>
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
+ (NSString *)curChatID;//当前聊天页面id
- (ChatMessageModel *)curChatMessageModel;
- (void)scrollToSearchResult:(MessageItem *)messageItem;
- (void)endTimer;
@end
