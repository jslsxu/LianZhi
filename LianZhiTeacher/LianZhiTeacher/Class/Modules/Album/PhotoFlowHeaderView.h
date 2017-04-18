//
//  PhotoFlowHeaderView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 2017/4/18.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kYearHeight             50
#define kDayHeight              30

@interface PhotoFlowHeaderView : UICollectionReusableView

- (void)setYear:(NSString *)year;
- (void)setDay:(NSString *)day;
@end
