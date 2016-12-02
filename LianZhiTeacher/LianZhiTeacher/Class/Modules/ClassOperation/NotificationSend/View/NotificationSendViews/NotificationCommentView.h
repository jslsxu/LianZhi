//
//  NotificationCommentView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/20.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationContentBaseView.h"
@interface NotificationCommentView : NotificationContentBaseView<HPGrowingTextViewDelegate>
{
    HPGrowingTextView*      _commentTextView;
    UILabel*                _numLabel;
}
@property (nonatomic, readonly)HPGrowingTextView* commentTextView;
@property (nonatomic, copy)NSString *placeHolder;
@property (nonatomic, assign)NSInteger maxWordsNum;
@property (nonatomic, copy)void (^textViewWillChangeHeight)(CGFloat height);
@property (nonatomic, copy)void (^textViewTextChanged)(NSString *text);
@property (nonatomic, copy)NSString *content;
@end
