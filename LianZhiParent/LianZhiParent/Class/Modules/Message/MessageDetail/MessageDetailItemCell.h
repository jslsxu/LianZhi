//
//  MessageDetailItemCell.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/24.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"
#import "MessageDetailModel.h"
#import "MessageVoiceButton.h"
#import "CollectionImageCell.h"
extern NSString *const kMessageDeleteNotitication;
extern NSString *const kMessageDeleteModelItemKey;

@interface MessageDetailItemCell : TNTableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>
{
    UIView*                 _bgView;
    LogoView*               _logoView;
    UILabel*                _nameLabel;
    UILabel*                _timeLabel;
    UIView*                 _sepLine;
    UILabel*                _contentLabel;
    MessageVoiceButton*     _voiceButton;
    UILabel*                _voiceSpanLabel;
    UICollectionView*       _collectionView;
}
@end
