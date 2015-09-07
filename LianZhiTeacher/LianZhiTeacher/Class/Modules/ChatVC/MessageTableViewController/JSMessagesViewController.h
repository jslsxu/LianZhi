

#import <UIKit/UIKit.h>
#import "ChatModel.h"
#import "InputBarView.h"
@interface JSMessagesViewController : TNBaseViewController <InputBarViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    ChatModel*              _chatModel;
    InputBarView*           _inputView;
    UITableView*            _tableView;
    CGFloat                 _previousTextViewContentHeight;
}
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *userID;
@end