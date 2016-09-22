//
//  CalanderView.h
//  LianZhiParent
//
//  Created by qingxu zhou on 16/9/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CalanderViewStyle){
    CalanderViewStyleMonth = 0,
    CalanderViewStyleWeek = 1,
};

@interface CalanderViewCell : UICollectionViewCell
@property (nonatomic, strong)NSDate *date;
@end

@interface CalanderView : UIView
@property (nonatomic, assign)CalanderViewStyle calanderStyle;
@property (nonatomic, strong)NSDate *selectedDate;
@property (nonatomic, strong)NSDate *curMonth;
@property (nonatomic, copy)void (^calanderDateCallback)(NSDate *date);
@end
