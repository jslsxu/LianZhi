//
//  PublishHomeWorkBaseVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/31.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "HomeworkItem.h"
@protocol PublishHomeWorkDelegate <NSObject>
@optional
- (void)publishHomeWorkFinished:(HomeWorkItem *)homeWorkItem;

@end

@interface PublishHomeWorkBaseVC : TNBaseViewController
@property (nonatomic, weak)id<PublishHomeWorkDelegate> delegate;

@end
