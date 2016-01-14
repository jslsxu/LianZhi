//
//  SurroundingVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/5/27.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"
#import "ClassZoneItemCell.h"

@interface SurroundingCell : ClassZoneItemCell

@end

@interface SurroundingListModel : TNListModel
@property (nonatomic, assign)BOOL hasMore;
@property (nonatomic, copy)NSString *minID;
@end

@interface SurroundingVC : TNBaseTableViewController<ReplyBoxDelegate, ClassZoneItemCellDelegate>
{
    ReplyBox*                       _replyBox;
}
@end
