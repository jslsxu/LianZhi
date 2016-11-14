//
//  MarkHomeworkVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "HomeworkTeacherMark.h"
#import "HomeworkPhotoImageView.h"
#import "HomeworkItem.h"

@interface HomeworkMarkPhotoCell : UICollectionViewCell
@property (nonatomic, strong)HomeworkStudentInfo*   studentInfo;
@property (nonatomic, strong)HomeworkMarkItem*      markItem;
@end

@interface MarkHomeworkVC : TNBaseViewController
@property (nonatomic, strong)HomeworkItem*  homeworkItem;
@property (nonatomic, strong)NSArray*   homeworkArray;
@property (nonatomic, assign)NSInteger  curIndex;
@property (nonatomic, copy)void (^markFinishedCallback)();
@end
