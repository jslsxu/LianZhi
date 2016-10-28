//
//  TNListModel.m
//  TNFoundation
//
//  Created by jslsxu on 14-9-4.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNListModel.h"

@implementation TNListModel

- (id)init
{
    self = [super init];
    if(self) {
        self.modelItemArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (BOOL)hasMoreData
{
    return NO;
}

- (NSInteger)numOfSections
{
    return 1;
}
- (NSInteger)numOfRowsInSection:(NSInteger)section
{
    return [_modelItemArray count];
}
- (TNModelItem *)itemForIndexPath:(NSIndexPath *)indexPath
{
    if(_modelItemArray.count > 0 && indexPath.row <= _modelItemArray.count - 1)
    {
        return [_modelItemArray objectAtIndex:indexPath.row];
    }
    else
        return nil;
}
- (id)dataOfHeaderForSection:(NSInteger)section
{
    return nil;
}
- (id)dataOfFooterForSection:(NSInteger)section
{
    return nil;
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    return YES;
}

- (void)clear{
    [self.modelItemArray removeAllObjects];
}

@end
