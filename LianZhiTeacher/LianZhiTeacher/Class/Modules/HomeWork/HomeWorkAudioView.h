//
//  HomeWorkAudioView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/12/7.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeWorkAudioView : UIView
{
    BOOL            _isPlaying;
    UIImageView*    _audioImageView;
    UILabel*        _timeSpanLabel;
    UIButton*       _playButton;
    UIButton*       _deleteButton;
}
@property (nonatomic, strong)NSData* audioData;
@property (nonatomic, assign)NSInteger timeSpan;
@property (nonatomic, copy)void (^deleteCompletion)(void);
@end
