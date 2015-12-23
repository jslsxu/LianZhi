//
//  SurroundingVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/5/27.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"
#import "ClassZoneItemCell.h"
@interface SurroundingListModel : TNListModel

@end

@interface SurroundingVC : TNBaseTableViewController<ReplyBoxDelegate, ClassZoneItemCellDelegate>
{
    ReplyBox*                       _replyBox;
}
@end
