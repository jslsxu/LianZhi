//
//  MessageGroupItemCell.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/23.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"
#import "MessageGroupListModel.h"
@interface MessageGroupItemCell : DAContextMenuCell
{
    LogoView*       _logoView;
    UIImageView*    _redDot;
    UILabel*        _numLabel;
    UIImageView*    _soundOff;
    UILabel*        _nameLabel;
    UILabel*        _courseLabel;
    UILabel*        _timeLabel;
    UILabel*        _contentLabel;
    UIView*         _sepLine;
}
@property (nonatomic, strong)MessageGroupItem *messageItem;
- (void)setData:(MessageGroupItem *)messageItem;
+ (NSNumber *)cellHeight:(MessageGroupItem *)messageItem cellWidth:(NSInteger)width;
@end
