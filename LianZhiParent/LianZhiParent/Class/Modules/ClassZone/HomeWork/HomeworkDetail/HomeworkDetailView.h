//
//  HomeworkDetailView.h
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/13.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkItem.h"
@interface HomeworkDetailView : UIView{
    UIScrollView*   _scrollView;
}
@property (nonatomic, strong)HomeworkItem *homeworkItem;
@end
