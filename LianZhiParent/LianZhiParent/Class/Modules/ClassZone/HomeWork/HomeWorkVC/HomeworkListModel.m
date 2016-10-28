//
//  HomeworkListModel.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkListModel.h"

@implementation HomeworkListModel

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type{
    if(type == REQUEST_REFRESH){
        [self.modelItemArray removeAllObjects];
    }
    TNDataWrapper *itemsWrapper = [data getDataWrapperForKey:@"items"];
    NSArray *items = [HomeworkItem nh_modelArrayWithJson:itemsWrapper.data];
    if([items count] > 0){
        HomeworkItem *homeworkItem = items[0];
        NSString* ctime = homeworkItem.ctime;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [formatter dateFromString:ctime];
        if(date.year == self.date.year && date.month == self.date.month && date.day == self.date.day){
            [self.modelItemArray addObjectsFromArray:items];
        }
    }
    return YES;
}
@end
