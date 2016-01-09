//
//  MyHomeworkList.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/11/27.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "HomeWorkHistoryModel.h"
#import "HomeWorkHistoryVC.h"
#import "HomeWorkCollectionVC.h"
@interface MyHomeworkList : TNBaseViewController
{
    UISegmentedControl*     _segmentControl;
    HomeWorkHistoryVC*      _historyVC;
    HomeWorkCollectionVC*   _collectionVC;
}
@property (nonatomic, copy)void (^completion)(HomeWorkItem *homeWorkItem);
@end
