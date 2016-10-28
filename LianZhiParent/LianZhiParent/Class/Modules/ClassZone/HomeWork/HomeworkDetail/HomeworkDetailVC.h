//
//  HomeworkDetailVC.h
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/13.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "HomeworkDetailView.h"
#import "HomeworkFinishView.h"
@interface HomeworkDetailVC : TNBaseViewController{

}
@property(nonatomic, copy)NSString* eid;
@property (nonatomic, copy)void (^deleteCallback)(NSString *eid);
@end
