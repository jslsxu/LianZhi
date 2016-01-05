//
//  HomeWorkCollectionVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/11/27.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"
#import "HomeWorkHistoryModel.h"
@interface HomeWorkCollectionVC : TNBaseTableViewController
@property (nonatomic, copy)void (^completion)(HomeWorkHistoryItem *homeWorkItem);
@end
