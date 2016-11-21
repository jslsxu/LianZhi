//
//  PersonalHomeController.h
//  DailyRanking
//
//  Created by ymy on 15/11/12.
//  Copyright © 2015年 com.xianlaohu.multipeer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadImageView : UIView
@property(nonatomic,weak) IBOutlet  UIImageView * imageFirstView;
@property(nonatomic,weak) IBOutlet  UILabel * nameFirstLbl;
@property(nonatomic,weak) IBOutlet  UILabel * contentFirstLbl;

@property(nonatomic,weak) IBOutlet   UIImageView * imageSecondView;
@property(nonatomic,weak) IBOutlet   UILabel * nameSecondLbl;
@property(nonatomic,weak) IBOutlet   UILabel * contentSecondLbl;

@property(nonatomic,weak)IBOutlet   UIImageView * imageThirdView;
@property(nonatomic,weak)IBOutlet   UILabel * nameThirdLbl;
@property(nonatomic,weak)IBOutlet   UILabel * contentThirdLbl;

@end
