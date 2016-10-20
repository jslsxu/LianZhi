//
//  HomeworkDetailView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkItem.h"
@interface HomeworkDetailView : UIView{
    UIScrollView*   _scrollView;
}
@property (nonatomic, strong)HomeworkItem* homeworkItem;
@end
