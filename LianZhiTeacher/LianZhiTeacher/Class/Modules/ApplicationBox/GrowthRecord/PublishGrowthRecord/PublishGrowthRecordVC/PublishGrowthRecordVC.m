//
//  EditGrowthRecordVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 17/2/8.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "PublishGrowthRecordVC.h"
#import "RecordPublishCommentView.h"
#import "RecordPublishVoiceView.h"
#import "RecordPublishPhotoView.h"
@interface PublishGrowthRecordVC ()
@property (nonatomic, strong)UIScrollView* scrollView;
@property (nonatomic, strong)RecordPublishCommentView* commentView;
@property (nonatomic, strong)RecordPublishVoiceView* voiceView;
@property (nonatomic, strong)RecordPublishPhotoView* photoView;
@end

@implementation PublishGrowthRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"家园手册";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    
    UILabel* dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    [dateLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
    [dateLabel setFont:[UIFont systemFontOfSize:16]];
    [dateLabel setTextAlignment:NSTextAlignmentCenter];
    [dateLabel setText:[self.date stringWithFormat:@"yyyy年MM月dd日"]];
    [self.view addSubview:dateLabel];
    
    [self.view addSubview:[self scrollView]];
    [self.scrollView setFrame:CGRectMake(0, dateLabel.bottom, self.view.width, self.view.height - dateLabel.bottom)];
}

- (UIScrollView *)scrollView{
    if(nil == _scrollView){
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_scrollView setAlwaysBounceVertical:YES];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        
        [_scrollView addSubview:[self commentView]];
        [_scrollView addSubview:[self voiceView]];
        [_scrollView addSubview:[self photoView]];
        [self updateContentView];
    }
    return _scrollView;
}

- (RecordPublishCommentView *)commentView{
    if(nil == _commentView){
        _commentView = [[RecordPublishCommentView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 120)];
        [_commentView setTextViewTextChanged:^(NSString *text) {
            
        }];
        [_commentView setTextViewWillChangeHeight:^(CGFloat height) {
            
        }];
    }
    return _commentView;
}

- (RecordPublishVoiceView *)voiceView{
    if(nil == _voiceView){
        _voiceView = [[RecordPublishVoiceView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    }
    return _voiceView;
}

- (RecordPublishPhotoView *)photoView{
    if(nil == _photoView){
        _photoView = [[RecordPublishPhotoView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    }
    return _photoView;
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

- (void)send{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
