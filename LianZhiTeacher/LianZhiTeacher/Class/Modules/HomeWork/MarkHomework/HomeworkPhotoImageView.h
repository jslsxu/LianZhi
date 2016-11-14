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
- (instancetype)initWithMark:(HomeworkPhotoMark *)photoMark parentSize:(CGSize)parentSize canEdit:(BOOL)canEdit;

@end

@interface HomeworkPhotoImageView : UIScrollView
@property (nonatomic, strong)HomeworkMarkItem* markItem;
@property (nonatomic, assign)BOOL canEdit;
@property (nonatomic, strong)void (^photoViewSingleTap)(CGPoint location);
@property (nonatomic, copy)void (^addMarkCallback)();
- (void)prepareForReuse;
- (void)setupMarks;
@end
