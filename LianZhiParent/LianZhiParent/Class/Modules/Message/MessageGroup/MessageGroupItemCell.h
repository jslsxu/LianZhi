//
//  MessageGroupItemCell.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/23.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"
#import "MessageGroupListModel.h"
#import "NumIndicator.h"
@interface MessageGroupItemCell : DAContextMenuCell
{
    LogoView*       _logoView;
    NumIndicator*   _numIndicator;
    UILabel*        _numLabel;
    UIImageView*    _soundOff;
    UILabel*        _nameLabel;
    UILabel*        _schoolLabel;
    UILabel*        _timeLabel;
//    UIImageView*    _notificationIndicator;
    UIImageView*    _massChatIndicator;
    UILabel*        _contentLabel;
    UIView*         _sepLine;
}
@property (nonatomic, strong)MessageGroupItem *messageItem;
+ (NSNumber *)cellHeight:(MessageGroupItem *)messageItem cellWidth:(NSInteger)width;
@end
