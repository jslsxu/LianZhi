//
//  HomeWorkDraftVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/9/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "HomeworkDraftManager.h"
@interface HomeworkDraftItemCell : TNTableViewCell
{
    UILabel*        _titleLabel;
    UILabel*        _timeLabel;
    UIImageView*    _audioImageView;
    UIImageView*    _photoImageView;
    UIView*         _sepLine;
}
@property (nonatomic, strong)HomeWorkEntity* homeworkEntity;
@end
@interface HomeWorkDraftVC : TNBaseViewController

- (void)clear;
@end
