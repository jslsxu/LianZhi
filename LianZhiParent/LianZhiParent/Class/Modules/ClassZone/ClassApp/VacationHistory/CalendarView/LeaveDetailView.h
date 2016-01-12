//
//  LeaveDetailView.h
//  LianZhiParent
//
//  Created by jslsxu on 16/1/12.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VacationHistoryModel.h"
@interface LeaveDetailView : UIView
{
    UIButton*     _bgButton;
    UIView*         _contentView;
}
@property (nonatomic, strong)VacationHistoryItem *leaveItem;
- (instancetype)initWithVacationItem:(VacationHistoryItem *)leaveItem;
- (void)show;
@end
