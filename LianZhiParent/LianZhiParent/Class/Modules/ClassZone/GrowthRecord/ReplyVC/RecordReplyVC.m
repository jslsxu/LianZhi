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
@interface RecordReplyVC ()
@property (nonatomic, strong)UIScrollView* scrollView;
@property (nonatomic, strong)RecordReplyCommentView* commentView;
@property (nonatomic, strong)RecordReplyVoiceView* voiceView;
@property (nonatomic, strong)RecordReplyPhotoView* photoView;
@end

@implementation RecordReplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"回复";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    
    [self.view addSubview:[self scrollView]];
}

- (UIScrollView *)scrollView{
    if(nil == _scrollView){
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [_scrollView setAlwaysBounceVertical:YES];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        
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

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)send{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
