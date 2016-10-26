//
//  HomeworkReplyView.h
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/14.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkStudentAnswer.h"
#import "HomeworkItem.h"
@interface HomeworkPhotoItemView : UIView
@property (nonatomic, strong)PhotoItem *photoItem;
@property (nonatomic, copy)void (^deleteCallback)();
@end

@interface HomeworkReplyView : UIView
@property (nonatomic, strong)HomeworkItem*  homeworkItem;
@end
