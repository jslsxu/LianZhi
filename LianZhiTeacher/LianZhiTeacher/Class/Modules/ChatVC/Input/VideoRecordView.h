//
//  VideoRecordView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoRecordView : UIView
{
    UIButton*       _bgButton;
    UIView*         _contentView;
    UIView*         _previewView;
    UIView*         _progressView;
    UIButton*       _captureButton;
}
+ (void)showWithCompletion:(void (^)(NSURL *videoPath))completion;
- (void)dismiss;
@end
