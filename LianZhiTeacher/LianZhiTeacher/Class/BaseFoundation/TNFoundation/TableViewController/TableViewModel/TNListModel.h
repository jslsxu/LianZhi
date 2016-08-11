//
//  TNListModel.h
//  TNFoundation
//
//  Created by jslsxu on 14-9-4.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNDataWrapper.h"
#import "AFHTTPRequestOperation+Associative.h"
#import "TNBaseObject.h"
#import "TNModelItem.h"
@interface TNListModel : TNBaseObject
@property (nonatomic, copy)NSString *nextPage;
@property (nonatomic, strong)NSMutableArray* modelItemArray;

- (NSInteger)numOfSections;
- (NSInteger)numOfRowsInSection:(NSInteger)section;
- (TNModelItem *)itemForIndexPath:(NSIndexPath *)indexPath;
- (id)dataOfHeaderForSection:(NSInteger)section;
- (id)dataOfFooterForSection:(NSInteger)section;


- (BOOL)hasMoreData;
- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type;
@end
