//
//  HomeworkListModel.h
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNListModel.h"
#import "HomeworkItem.h"
@interface HomeworkListModel : TNListModel
@property (nonatomic, strong)NSDate* date;
@property (nonatomic, strong)NSArray*   unread_days;
@end
