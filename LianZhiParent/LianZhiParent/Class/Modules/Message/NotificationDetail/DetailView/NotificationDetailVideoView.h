//
//  NotificationDetailVideoView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSPieProgressView.h"
@interface VideoItemView : UIView

@property (nonatomic, strong)VideoItem *videoItem;
@end

@interface NotificationDetailVideoView : UIView
@property (nonatomic, strong)NSArray *videoArray;
@end
