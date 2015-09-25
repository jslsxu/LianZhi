//
//  TreeHouseHeaderView.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/22.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeHouseAlbumVC.h"

@interface NewMessageIndicator : UIView
{
    AvatarView* _avatarView;
    UILabel*    _indicatorLabel;
    UIButton*   _coverButton;
}
@property (nonatomic, strong)TimelineCommentItem *commentItem;
@property (nonatomic, copy)void (^clickAction)();
@end

@interface TreeHouseHeaderView : UIView
{
    UIImageView*            _bannerImageView;
    AvatarView*             _avatar;
    UILabel*                _titleLabel;
    UIButton*               _albumButton;
    NewMessageIndicator*    _msgIndicator;
}
@property (nonatomic, strong)TimelineCommentItem *commentItem;
- (void)setupHeaderView;
@end
