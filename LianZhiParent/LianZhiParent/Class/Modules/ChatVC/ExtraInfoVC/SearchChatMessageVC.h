//
//  SearchChatMessageVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/2.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface SearchChatItemCell : TNTableViewCell
{
    AvatarView*     _avatarView;
    UILabel*        _nameLabel;
    UILabel*        _timeLabel;
    UILabel*        _contentLabel;
    UIView*         _sepLine;
}

@property (nonatomic, strong)MessageItem* messageItem;
@property (nonatomic, copy)NSString* keyword;
- (void)updateWithMessage:(MessageItem *)messageItem keyword:(NSString *)keyword;
@end

@interface SearchChatMessageVC : TNBaseViewController

@end
