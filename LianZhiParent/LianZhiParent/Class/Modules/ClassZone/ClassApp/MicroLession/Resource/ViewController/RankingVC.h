//
//  [词典]	ranking; RankingVC.h
//  LianZhiParent
//
//  Created by Chen Qi on 2016/9/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZGradientProcessView.h"
#import "LZRankingModel.h"

// 排名Cell的布局
@interface RankingCell : UITableViewCell
{
    UILabel*        _idLabel;
    UILabel*        _nameLabel;
    UIImageView*    _headerImageView;
    LZGradientProcessView* _processView;
    UILabel*        _levelLabel;
    UILabel *_unitLabel;
}
@property (nonatomic, strong) RankingItem *rankingItem;
@property (nonatomic, assign) NSUInteger total;
- (void)setStyle:(BOOL)isTop;
@end


@interface RankingVC : TNBaseViewController

@end
