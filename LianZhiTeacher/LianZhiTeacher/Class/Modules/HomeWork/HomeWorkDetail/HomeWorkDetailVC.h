//
//  HomeWorkDetailVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/11/28.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "HomeWorkItem.h"
@interface HomeWorkDetailVC : TNBaseViewController
{
    UIView*         _headerView;
    MessageVoiceButton *_voiceButton;
    UITableView*    _tableView;
}
@property (nonatomic, copy)NSString *homeworkID;
@property (nonatomic, copy)void (^completion)(HomeWorkItem *homeWorkItem);
@end
