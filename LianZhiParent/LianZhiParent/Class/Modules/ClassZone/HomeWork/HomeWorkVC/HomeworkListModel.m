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
    [self.modelItemArray addObjectsFromArray:[HomeworkItem nh_modelArrayWithJson:itemsWrapper.data]];
    return YES;
}
@end
