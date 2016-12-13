//
//  ThroughTrainingVC.h
//  LianZhiParent
//
//  Created by Chen Qi on 2016/9/28.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResourceBaseVC.h"
#import "LZQuestionsModel.h"

@class EDStarRating;
@class HKPieChartView;

@interface ThroughTrainingCell : UICollectionViewCell
{
    
    UIView*         _mainContentView;
    UIImageView*    _bgView;
    UILabel*        _nameLabel;
    UILabel*        _statusLabel;

}
@property (nonatomic, strong) QuestionItem *questionItem;

@end

// 未完成样式单元格
@interface ThroughTrainingNotComplatedCell : ThroughTrainingCell
{
    
    HKPieChartView *_pieChartView;
}

@end

// 已经完成样式单元格
@interface ThroughTrainingComplatedCell : ThroughTrainingCell
{
    // 星星视图
    EDStarRating *starRating;
}

@end

// 未解锁样式单元格
@interface ThroughTrainingLockCell : ThroughTrainingCell
{

}

@end

@interface ThroughTrainingVC : ResourceBaseVC

@end
