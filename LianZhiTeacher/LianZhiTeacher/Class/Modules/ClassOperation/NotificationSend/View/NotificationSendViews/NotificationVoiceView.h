//
//  NotificationVoiceView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/29.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationContentBaseView.h"
#import "ChatVoiceButton.h"

@interface AudioItemView : UIView{
    UIImageView*    _bgImageView;
    UIImageView*    _animateImageView;
    UIActivityIndicatorView*    _loadingIndicator;
}
@property (nonatomic, strong)AudioItem *audioItem;
@end

@interface AudioContentView : UIView
{
    ChatVoiceButton*        _voiceButton;
    UILabel*                _durationLabel;
    UIButton*               _removeButton;
}
@property (nonatomic, strong)AudioItem *audioItem;
@property (nonatomic, copy)void (^deleteCallback)();
- (instancetype)initWithMaxWidth:(CGFloat)maxWidth;
@end

@interface NotificationVoiceView : NotificationContentBaseView
@property (nonatomic, strong)NSArray *voiceArray;
@property (nonatomic, assign)BOOL    editDisable;
@end
