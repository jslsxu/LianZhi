//
//  NotificationVideoView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/29.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationSendEntity.h"
#import "NotificationContentBaseView.h"
#import "SSPieProgressView.h"
typedef NS_ENUM(NSInteger, VideoViewType){
    VideoViewTypeEdit,
    VideoViewTypePreview
};
@interface VideoItemView : UIView

@property (nonatomic, assign)VideoViewType videoViewType;
@property (nonatomic, strong)VideoItem *videoItem;
@property (nonatomic, copy)void (^deleteCallback)();
@end

@interface NotificationVideoView : NotificationContentBaseView
@property (nonatomic, strong)NSMutableArray *videoArray;
@end
