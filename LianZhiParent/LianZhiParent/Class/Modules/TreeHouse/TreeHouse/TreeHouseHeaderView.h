//
//  TreeHouseHeaderView.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/22.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeHouseAlbumVC.h"
@interface TreeHouseHeaderView : UIView
{
    UIImageView*        _bannerImageView;
    AvatarView*         _avatar;
    UILabel*            _titleLabel;
    UIButton*           _albumButton;
}
- (void)setupHeaderView;
@end
