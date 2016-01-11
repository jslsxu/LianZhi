//
//  HomeWorkListModel.h
//  LianZhiParent
//
//  Created by jslsxu on 15/10/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNListModel.h"

@interface HomeWorkItem : TNModelItem
@property (nonatomic, copy)NSString *content;
@property (nonatomic, strong)PhotoItem *photoItem;
@property (nonatomic, strong)AudioItem *audioItem;

@end

@interface HomeWorkListModel : TNListModel
@property (nonatomic, assign)BOOL has;
@property (nonatomic, copy)NSString *maxID;
@end
