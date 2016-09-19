//
//  ClassSelectionVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/12/22.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface ClassSelectionVC : TNBaseViewController
{
    UITableView*    _tableView;
}
@property (nonatomic, assign)BOOL isHomework;
@property (nonatomic, copy)NSString *originalClassID;
@property (nonatomic, copy)void (^selection)(ClassInfo *classInfo);
@property (nonatomic, strong)NSDictionary *classDic;
@property (nonatomic, copy)NSDictionary* (^validateStatus)(void);
@end
