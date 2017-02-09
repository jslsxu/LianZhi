//
//  RecordPublishCommentView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 17/2/9.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "RecordPublishCommentView.h"
#define kNumLabelHeight         30
#define kMaxTextNum             150
#define kMinHeight              135
@implementation RecordPublishCommentView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.maxWordsNum = 150;
        _commentTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(10, 10, self.width - 10 * 2, kMinHeight - kNumLabelHeight)];
        [_commentTextView setFont:[UIFont systemFontOfSize:15]];
        [_commentTextView setDelegate:self];
        [_commentTextView setReturnKeyType:UIReturnKeyDone];
        [_commentTextView setMinHeight:kMinHeight - kNumLabelHeight - 10];
        [_commentTextView setMaxNumberOfLines:10];
        [_commentTextView sizeToFit];
        [self addSubview:_commentTextView];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.height - kNumLabelHeight, self.width - 10 * 2, kNumLabelHeight)];
        [_numLabel setTextAlignment:NSTextAlignmentRight];
        [_numLabel setFont:[UIFont systemFontOfSize:15]];
        [_numLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_numLabel setText:[NSString stringWithFormat:@"0/%zd",self.maxWordsNum]];
        [_numLabel setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [self addSubview:_numLabel];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [sepLine setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
    }
    return self;
}

- (void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = [placeHolder copy];
    [_commentTextView setPlaceholder:_placeHolder];
}

- (void)setMaxWordsNum:(NSInteger)maxWordsNum{
    _maxWordsNum = maxWordsNum;
    
    [self formatContent];
}

- (NSString *)content{
    return [[_commentTextView text] copy];
}

- (void)setContent:(NSString *)content{
    [_commentTextView setText:content];
    [self formatContent];
}

- (void)formatContent{
    NSInteger length = _commentTextView.text.length;
    NSString *resultText = _commentTextView.text;
    if(length > self.maxWordsNum){
        resultText = [_commentTextView.text substringToIndex:self.maxWordsNum];
        _commentTextView.text = resultText;
        length = self.maxWordsNum;
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:kStringFromValue(length) attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"28c4d8"]}];
    [attrStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"/%zd",self.maxWordsNum] attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"333333"]}]];
    [_numLabel setAttributedText:attrStr];
    if(self.textViewTextChanged){
        self.textViewTextChanged(resultText);
    }
    
}

#pragma mark - HPGrowingTextViewDelegate

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView{
    if([[MLAmrPlayer shareInstance] isPlaying]){
        [[MLAmrPlayer shareInstance] stopPlaying];
    }
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height{
    [self setHeight:height + kNumLabelHeight + 10];
    if(self.textViewWillChangeHeight){
        self.textViewWillChangeHeight(height);
    }
    //    [UIView animateWithDuration:0.3 animations:^{
    //        [self setHeight:height + kNumLabelHeight + 10];
    //    } completion:^(BOOL finished) {
    //
    //    }];
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView{
    [self formatContent];
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
