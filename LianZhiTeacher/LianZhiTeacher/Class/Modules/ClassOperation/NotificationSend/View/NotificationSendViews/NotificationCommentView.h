//
//  NotificationCommentView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/20.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCommentView : UIView<HPGrowingTextViewDelegate>
{
    HPGrowingTextView*      _commentTextView;
    UILabel*                _numLabel;
}
@property (nonatomic, copy)void (^textViewWillChangeHeight)(CGFloat height);
@end
