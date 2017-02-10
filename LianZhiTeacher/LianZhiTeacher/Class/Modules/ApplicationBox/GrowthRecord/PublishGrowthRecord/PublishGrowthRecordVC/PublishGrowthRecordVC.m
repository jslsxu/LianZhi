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
#import "NotificationInputView.h"
#import "GrowthTargetChildView.h"
@interface PublishGrowthRecordVC ()<NotificationInputDelegate, UIScrollViewDelegate>
@property (nonatomic, strong)UITouchScrollView* scrollView;
@property (nonatomic, strong)GrowthTargetChildView* targetView;
@property (nonatomic, strong)RecordPublishCommentView* commentView;
@property (nonatomic, strong)RecordPublishVoiceView* voiceView;
@property (nonatomic, strong)RecordPublishPhotoView* photoView;
@property (nonatomic, strong)NotificationInputView* inputView;

@property (nonatomic, strong)NSMutableArray* studentArray;
@end

@implementation PublishGrowthRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"家园手册";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    self.studentArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 36; i++) {
        StudentInfo* studentInfo = [[StudentInfo alloc] init];
        [studentInfo setName:@"学生"];
        [studentInfo setAvatar:@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=895009738,1542646259&fm=116&gp=0.jpg"];
        [self.studentArray addObject:studentInfo];
    }
    [self addHeaderView];
    
    [self.view addSubview:[self scrollView]];
    
    [self.view addSubview:[self inputView]];
}

- (void)addHeaderView{
    UILabel* dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    [dateLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
    [dateLabel setFont:[UIFont systemFontOfSize:16]];
    [dateLabel setTextAlignment:NSTextAlignmentCenter];
    [dateLabel setText:[self.date stringWithFormat:@"yyyy年MM月dd日"]];
    [self.view addSubview:dateLabel];
    UIView* sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, dateLabel.height - kLineHeight, self.view.width, kLineHeight)];
    [sepLine setBackgroundColor:kSepLineColor];
    [dateLabel addSubview:sepLine];
}

- (UIScrollView *)scrollView{
    if(nil == _scrollView){
        _scrollView = [[UITouchScrollView alloc] initWithFrame:CGRectMake(0, 40, self.view.width, self.view.height - 40)];
        [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_scrollView setAlwaysBounceVertical:YES];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setDelegate:self];
        
        [_scrollView addSubview:[self targetView]];
        [_scrollView addSubview:[self commentView]];
        [_scrollView addSubview:[self voiceView]];
        [_scrollView addSubview:[self photoView]];
        [self updateContentView];
    }
    return _scrollView;
}

- (GrowthTargetChildView *)targetView{
    if(nil == _targetView){
        _targetView = [[GrowthTargetChildView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 215)];
        [_targetView setStudentArray:self.studentArray];
    }
    return _targetView;
}

- (NotificationInputView *)inputView{
    if(nil == _inputView){
        @weakify(self)
        _inputView = [[NotificationInputView alloc] initWithFrame:CGRectMake(0, self.view.height - 64 - kActionBarHeight, self.view.width, kActionBarHeight)];
        [_inputView setSendHidden:YES];
        [_inputView setOnlyPhotoLibrary:YES];
//        [_inputView setPhotoNum:^NSInteger{
//            @strongify(self)
//            return self.sendEntity.imageArray.count;
//        }];
//        [_inputView setVideoNum:^NSInteger{
//            @strongify(self)
//            return self.sendEntity.videoArray.count;
//        }];
//        [_inputView setCanRecord:^BOOL{
//            @strongify(self)
//            return self.sendEntity.voiceArray.count == 0;
//        }];
        [_inputView setDelegate:self];
    }
    return _inputView;
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
    
    [self.targetView setY:spaceYStart];
    spaceYStart = self.targetView.bottom;
    
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(_inputView.actionType != ActionTypeNone)
        [_inputView setActionType:ActionTypeNone];
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
