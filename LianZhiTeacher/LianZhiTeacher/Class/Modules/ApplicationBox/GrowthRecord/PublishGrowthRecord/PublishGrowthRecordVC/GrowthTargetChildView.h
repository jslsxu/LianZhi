//
//  GrowthTargetChildView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 17/2/8.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GrowthTargetChildItemView : UICollectionViewCell
@property (nonatomic, copy)void (^itemRemoved)();
@end

@interface GrowthTargetChildView : UIView
@property (nonatomic, strong)NSArray* studentArray;
@end
