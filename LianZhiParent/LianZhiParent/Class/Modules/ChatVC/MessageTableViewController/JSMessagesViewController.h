

#import <UIKit/UIKit.h>
#import "ChatModel.h"
#import "InputBarView.h"
#import "ClassMemberVC.h"
@interface JSMessagesViewController : TNBaseViewController <InputBarViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    BOOL                    _isLoading;
    ChatModel*              _chatModel;
    InputBarView*           _inputView;
    UITableView*            _tableView;
    CGFloat                 _previousTextViewContentHeight;
}
@property (nonatomic, copy)NSString *userID;
@property (nonatomic, copy)NSString *name;
@end