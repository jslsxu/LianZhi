//
//  HomeWorkCollectionVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/11/27.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"
#import "HomeWorkCollectionModel.h"
#import "HomeWorkHistoryCell.h"
@interface HomeWorkCollectionVC : TNBaseTableViewController
@property (nonatomic, copy)void (^completion)(HomeWorkItem *homeWorkItem);
@end
