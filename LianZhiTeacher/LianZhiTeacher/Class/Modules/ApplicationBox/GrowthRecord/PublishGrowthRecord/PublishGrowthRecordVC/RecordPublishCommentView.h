//
//  RecordPublishCommentView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 17/2/9.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordPublishBaseView.h"
@interface RecordPublishCommentView : RecordPublishBaseView<HPGrowingTextViewDelegate>
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
