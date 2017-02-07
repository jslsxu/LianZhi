//
//  GrowthSegmentCtrl.h
//  LianZhiTeacher
//
//  Created by jslsxu on 17/2/6.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GrowthSegmentItem : TNBaseObject
@property (nonatomic, copy)NSString* title;
@property (nonatomic, assign)BOOL hasNew;
+ (GrowthSegmentItem *)itemWithTitle:(NSString* )title hasNew:(BOOL)hasNew;
@end

@interface GrowthSegmentCell : UICollectionViewCell
@property (nonatomic, strong)GrowthSegmentItem* item;
@property (nonatomic, assign)BOOL itemSelected;
@end

@interface GrowthSegmentCtrl : UIView
@property (nonatomic, assign)NSInteger selectedIndex;
@property (nonatomic, copy)void (^indexChanged)(NSInteger index);
@property (nonatomic, strong)NSArray* segments;
@end
