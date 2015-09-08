//
//  TreeHouseVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"
#import "TreeHouseHeaderView.h"
#import "TreeHouseCell.h"
#import "PublishArticleVC.h"
#import "PublishPhotoVC.h"
#import "PublishAudioVC.h"
#import "ReplyBox.h"
extern NSString *const kPublishPhotoItemFinishedNotification;
extern NSString *const kPublishPhotoItemKey;
@interface TreeHouseVC : TNBaseTableViewController<PublishTreeHouseDelegate, TreeHouseCellDelegate, ReplyBoxDelegate>
{
    TreeHouseHeaderView*    _headerView;
    UIButton*               _publishButton;
    ReplyBox*                _replyBox;
}
- (void)startUploading:(TreehouseItem *)item;
@end
