//
//  HomeworkResultView.h
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/14.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkStudentAnswer.h"
#import "HomeworkItem.h"
@interface HomeworkResultView : UIView{
    UIScrollView*   _scrollView;
}
@property (nonatomic, strong)HomeworkItem*  homeworkItem;
@end
