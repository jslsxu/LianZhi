//
//  SurroundingVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"

@interface SurroundingListModel : TNListModel

@end

@interface SurroundingVC : TNBaseTableViewController<ReplyBoxDelegate, ClassZoneItemCellDelegate>
{
    ReplyBox*                       _replyBox;
}
@end
