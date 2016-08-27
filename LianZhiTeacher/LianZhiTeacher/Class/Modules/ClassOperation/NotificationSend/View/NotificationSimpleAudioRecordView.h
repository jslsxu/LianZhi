//
//  NotificationSimpleAudioRecordView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/27.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationSimpleAudioRecordView : UIView{
    UILabel*        _titleLabel;
    UIButton*    _recordButton;
}
@property (nonatomic, assign)BOOL canRecord;
@property (nonatomic, copy)void (^recordCallback)(AudioItem *audioItem);
@end
