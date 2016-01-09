//
//  HomeWorkHistoryCell.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/31.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//


#import "HomeWorkHistoryModel.h"

extern NSString *const kAddFavNotification;
extern NSString *const kPractiseItemKey;

@interface HomeWorkHistoryCell : TNTableViewCell<UICollectionViewDataSource, UICollectionViewDelegate>
{
    UILabel*        _dateLabel;
    UIView*         _bgView;
    UILabel*        _courseLabel;
    UILabel*        _timeLabel;
    UIView*         _sepLine;
    UILabel*        _contentLabel;
    UICollectionView*   _collectionView;
    MessageVoiceButton* _voiceButton;
    UILabel*            _spanLabel;
    UIButton*       _likeButton;          //收藏
    UIButton*       _moreButton;
}
@end
