//
//  SurroundingVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"
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
