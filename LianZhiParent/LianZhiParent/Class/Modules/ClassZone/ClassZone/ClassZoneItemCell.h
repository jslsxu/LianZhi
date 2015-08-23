//
//  ClassZoneItemCell.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/23.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"
#import "ClassZoneModel.h"
#import "MessageVoiceButton.h"
#import "ResponseView.h"
@interface ClassZoneItemCell : TNTableViewCell<UICollectionViewDataSource, UICollectionViewDelegate>
{
    AvatarView*         _avatar;
    UILabel*            _nameLabel;
    UILabel*            _timeLabel;
    UILabel*            _contentLabel;
    UICollectionView*   _collectionView;
    MessageVoiceButton* _voiceButton;
    UIButton*           _addressButton;
    UIButton*           _actionButton;
    ResponseView*       _responseView;
    UIView*             _sepLine;
}
@end
