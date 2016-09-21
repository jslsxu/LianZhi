//
//  GrowthContentView.h
//  LianZhiParent
//
//  Created by qingxu zhou on 16/9/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrowthTimelineModel.h"
@interface GrowthContentView : UIView{
    AvatarView*     _avatarView;
    UILabel*        _nameLabel;
    UILabel*        _dateLabel;
    NSMutableArray* _statusViewArray;
    UIView*         _sepLine;
    UILabel*        _commentLabel;
}
@property (nonatomic, strong)GrowthTimelineItem *growthTimelineItem;
@end

