//
//  ClassAppVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseCollectionViewController.h"
#import "ClassAppModel.h"
#import "RequestVacationVC.h"
#import "SDCycleScrollView.h"
@interface ApplicationBoxHeaderView : UICollectionReusableView
{
    SDCycleScrollView*  _cycleScrollView;
}
@property (nonatomic, readonly)SDCycleScrollView*  cycleScrollView;
- (void)updateWithHeight:(CGFloat)height;
@end

@interface ClassAppVC : TNBaseCollectionViewController
@end
