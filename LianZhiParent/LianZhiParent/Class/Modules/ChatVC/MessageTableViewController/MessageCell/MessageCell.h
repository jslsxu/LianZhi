//
//  MessageCell.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"
#import "ChatContentSendGiftView.h"
@protocol MessageCellDelegate <NSObject>
- (void)onRevokeMessage:(MessageItem *)messageItem;
- (void)onDeleteMessage:(MessageItem *)messageItem;
- (void)onResendMessage:(MessageItem *)messageItem;
- (void)onReceiveGift:(MessageItem *)messageItem;
@end
@interface MessageCell : TNTableViewCell{
    UILabel*                    _timeLabel;
    UILabel*                    _nameLabel;
    AvatarView*                 _avatarView;
    UIActivityIndicatorView*    _indicatorView;
    UIImageView*                _sendFailImageView;
}
@property (nonatomic, strong)MessageItem*   messageItem;
@property (nonatomic, weak)id<MessageCellDelegate> delegate;
- (instancetype)initWithModel:(MessageItem *)messageItem reuseID:(NSString *)reuseID;
+ (CGFloat)cellHeightForModel:(MessageItem *)messageItem;
@end
