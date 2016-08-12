//
//  NotificationDetailVideoView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VideoViewType){
    VideoViewTypeEdit,
    VideoViewTypePreview
};
@interface VideoItemView : UIView
{
    UIImageView*        _coverImageView;
    UIView*             _darkCoverView;
    UIButton*           _deleteButton;
    UIButton*           _playButton;
}
@property (nonatomic, assign)VideoViewType videoViewType;
@property (nonatomic, strong)VideoItem *videoItem;
@property (nonatomic, copy)void (^deleteCallback)();
@end

@interface NotificationDetailVideoView : UIView
@property (nonatomic, strong)NSArray *videoArray;
@end
