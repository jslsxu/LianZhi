//
//  @"高手"  LZStudyLevelModel.h
//  LianZhiParent
//
//  Created by Chen Qi on 2016/10/11.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResourceDefine.h"


@interface RankingItem : TNModelItem

@property (nonatomic, assign)int rank;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *head;
@property (nonatomic, copy)NSString *score;

- (void)parseData:(TNDataWrapper *)data;
@end


@interface RankingModel : TNModelItem
@property (nonatomic, copy)NSString *total;
@property (nonatomic, assign)NSUInteger isTop;
@property (nonatomic, copy)TNListModel *topThree;
@property (nonatomic, copy)TNListModel *rankList;

- (void)parseData:(TNDataWrapper *)data;

@end



