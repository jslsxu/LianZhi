//
//  HomeworkMarkHeaderView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkItem.h"
@protocol HomeworkMarkHeaderDelegate <NSObject>

- (void)requestPreHomework;
- (void)requestNextHomework;

@end

@interface HomeworkMarkHeaderView : UIView
@property (nonatomic, strong)HomeworkItem*  homeworkItem;
@property (nonatomic, weak)id<HomeworkMarkHeaderDelegate> delegate;
@end
