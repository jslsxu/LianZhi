//
//  HomeWorkCell.h
//  LianZhiParent
//
//  Created by jslsxu on 15/10/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"

@interface HomeWorkCell : TNTableViewCell<UICollectionViewDataSource, UICollectionViewDelegate>
{
    UILabel*        _dateLabel;
    UILabel*        _courseLabel;
    UIView*         _bgView;
    UILabel*        _contentLabel;
    NSMutableArray* _photoViewArray;
    MessageVoiceButton* _voiceButton;
    UILabel*        _timespanLabel;
    UICollectionView*   _collectionView;
    UILabel*        _timeLabel;
    UIView*         _bottomLine;
    UILabel*        _fromLabel;
}
@end
