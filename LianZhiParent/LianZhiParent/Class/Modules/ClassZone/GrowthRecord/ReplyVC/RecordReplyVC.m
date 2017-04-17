//
//  RecordReplyVC.m
//  LianZhiParent
//
//  Created by jslsxu on 17/2/8.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "RecordReplyVC.h"
#import "RecordReplyCommentView.h"
#import "RecordReplyVoiceView.h"
#import "RecordReplyPhotoView.h"
#import "NotificationInputView.h"
@interface RecordReplyVC ()<NotificationInputDelegate, UIScrollViewDelegate>
@property (nonatomic, strong)UITouchScrollView* scrollView;
@property (nonatomic, strong)RecordReplyCommentView* commentView;
@property (nonatomic, strong)RecordReplyVoiceView* voiceView;
@property (nonatomic, strong)RecordReplyPhotoView* photoView;
@property (nonatomic, strong)NotificationInputView* inputView;
@end

@implementation RecordReplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"回复";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    
    [self.view addSubview:[self inputView]];
    [self.view addSubview:[self scrollView]];
    [self.scrollView setFrame:CGRectMake(0, 0, self.view.width, self.inputView.top)];
    [self.view bringSubviewToFront:self.inputView];
}

- (UIScrollView *)scrollView{
    if(nil == _scrollView){
        __weak typeof(self) wself = self;
        _scrollView = [[UITouchScrollView alloc] initWithFrame:self.view.bounds];
        [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [_scrollView setAlwaysBounceVertical:YES];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setDelegate:self];
        [_scrollView setOnTouch:^{
            [wself onSwipe];
        }];
        
        [_scrollView addSubview:[self commentView]];
        [_scrollView addSubview:[self voiceView]];
        [_scrollView addSubview:[self photoView]];
        [self updateContentView];
    }
    return _scrollView;
}

- (void)updateContentView{
    CGFloat spaceYStart = 0;
    [self.commentView setY:spaceYStart];
    spaceYStart = self.commentView.bottom;
    
    [self.voiceView setY:spaceYStart];
    spaceYStart = self.voiceView.bottom;
    
    [self.photoView setY:spaceYStart];
    spaceYStart = self.photoView.bottom;
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, spaceYStart)];
}

- (RecordReplyCommentView *)commentView{
    if(nil == _commentView){
        _commentView = [[RecordReplyCommentView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 120)];
        [_commentView setTextViewTextChanged:^(NSString *text) {
            
        }];
        [_commentView setTextViewWillChangeHeight:^(CGFloat height) {
            
        }];
    }
    return _commentView;
}

- (RecordReplyVoiceView *)voiceView{
    if(nil == _voiceView){
        _voiceView = [[RecordReplyVoiceView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    }
    return _voiceView;
}

- (RecordReplyPhotoView *)photoView{
    if(nil == _photoView){
        _photoView = [[RecordReplyPhotoView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    }
    return _photoView;
}

- (NotificationInputView *)inputView{
    if(nil == _inputView){
        _inputView = [[NotificationInputView alloc] initWithFrame:CGRectMake(0, self.view.height - 64 - kActionBarHeight, self.view.width, kActionBarHeight)];
        [_inputView setSendHidden:YES];
        [_inputView setOnlyPhotoLibrary:YES];
        [_inputView setDelegate:self];
    }
    return _inputView;
}

- (void)onSwipe{
    if(_inputView.actionType != ActionTypeNone){
        [_inputView setActionType:ActionTypeNone];
    }
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)send{
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self onSwipe];
}

#pragma mark - NotificationInputViewDelegate

- (void)notificationInputDidWillChangeHeight:(CGFloat)height{
    [UIView animateWithDuration:kActionAnimationDuration animations:^{
        [_inputView setY:self.view.height - height];
        [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, height, 0)];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)notificationInputPhoto:(NotificationInputView *)inputView{
    
}

- (void)notificationInputQuickPhoto:(NSArray *)photoArray fullImage:(BOOL)isFullImage{
    
}

- (void)notificationInputVideo:(NotificationInputView *)inputView
{
    
}

- (void)notificationInputAudio:(NotificationInputView *)inputView audioItem:(AudioItem *)audioItem{
    
}

- (void)notificationInputSend{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
