//
//  HomeWorkCell.h
//  LianZhiParent
//
//  Created by jslsxu on 15/10/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"

@interface HomeWorkCell : TNTableViewCell
{
    UILabel*        _contentLabel;
    UIImageView*    _photoView;
    MessageVoiceButton* _voiceButton;
    UILabel*        _timeLabel;
    UIView*         _bottomLine;
}
@end
