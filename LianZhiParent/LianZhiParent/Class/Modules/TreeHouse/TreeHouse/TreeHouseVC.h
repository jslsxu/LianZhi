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

extern NSString *const kPublishPhotoItemFinishedNotification;
extern NSString *const kPublishPhotoItemKey;
@interface TreeHouseVC : TNBaseTableViewController<PublishTreeHouseDelegate>
{
    TreeHouseHeaderView*    _headerView;
    UIButton*               _publishButton;
}
- (void)startUploading:(TreehouseItem *)item;
@end
