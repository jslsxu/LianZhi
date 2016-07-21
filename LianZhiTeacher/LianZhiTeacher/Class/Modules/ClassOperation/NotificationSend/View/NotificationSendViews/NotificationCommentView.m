//
//  NotificationCommentView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/20.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationCommentView.h"

#define kNumLabelHeight         25
#define kMaxTextNum             150
#define kMinHeight              135

@implementation NotificationCommentView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _commentTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(10, 10, self.width - 10 * 2, kMinHeight - kNumLabelHeight)];
        [_commentTextView setFont:[UIFont systemFontOfSize:15]];
        [_commentTextView setPlaceholder:@"请输入正文内容"];
        [_commentTextView setDelegate:self];
        [_commentTextView setMinHeight:kMinHeight - kNumLabelHeight - 10];
        [_commentTextView setMaxNumberOfLines:10];
        [_commentTextView sizeToFit];
        [self addSubview:_commentTextView];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.height - kNumLabelHeight, self.width - 10 * 2, kNumLabelHeight)];
        [_numLabel setTextAlignment:NSTextAlignmentRight];
        [_numLabel setFont:[UIFont systemFontOfSize:15]];
        [_numLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_numLabel setText:[NSString stringWithFormat:@"0/%d",kMaxTextNum]];
        [_numLabel setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [self addSubview:_numLabel];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [sepLine setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
    }
    return self;
}

#pragma mark - HPGrowingTextViewDelegate
- (void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height{
    if(self.textViewWillChangeHeight){
        self.textViewWillChangeHeight(height);
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self setHeight:height + kNumLabelHeight + 10];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView{
    NSInteger length = growingTextView.text.length;
    if(length > kMaxTextNum){
        growingTextView.text = [growingTextView.text substringToIndex:kMaxTextNum];
        length = kMaxTextNum;
    }
    [_numLabel setText:[NSString stringWithFormat:@"%zd/%d",length, kMaxTextNum]];
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]){
        [growingTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
