//
//  HomeworkPhotoImageView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkTeacherMark.h"

@interface HomeworkMarkItemView : UIView
@property (nonatomic, strong)HomeworkPhotoMark *photoMark;
@property (nonatomic, copy)void (^deleteCallback)();
- (instancetype)initWithMark:(HomeworkPhotoMark *)photoMark parentSize:(CGSize)parentSize;

@end

@interface HomeworkPhotoImageView : UIScrollView
@property (nonatomic, strong)HomeworkMarkItem* markItem;
@property (nonatomic, strong)void (^photoViewSingleTap)(CGPoint location);
- (void)setupMarks;
@end
