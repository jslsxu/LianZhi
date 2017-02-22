//
//  PublishGrowthRecordVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 17/2/8.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "GrowthRecordDetailVC.h"
#import "Calendar.h"
#import "GrowthRecordChildSwitchView.h"
#import "RecordInfoView.h"
#import "ParentReplyView.h"
#import "RecordPublishCommentView.h"
#import "RecordPublishVoiceView.h"
#import "RecordPublishPhotoView.h"
#import "NotificationInputView.h"
@interface GrowthRecordDetailVC ()<CalendarDelegate, UIScrollViewDelegate, NotificationInputDelegate>
@property (nonatomic, strong)Calendar* calendar;
@property (nonatomic, strong)GrowthRecordChildSwitchView* switchView;
@property (nonatomic, strong)UITouchScrollView* scrollView;
@property (nonatomic, strong)RecordInfoView* recordInfoView;
@property (nonatomic, strong)RecordPublishCommentView* commentView;
@property (nonatomic, strong)RecordPublishVoiceView* voiceView;
@property (nonatomic, strong)RecordPublishPhotoView* photoView;
@property (nonatomic, strong)NotificationInputView* inputView;
@property (nonatomic, strong)ParentReplyView* parentReplyView;

@end

@implementation GrowthRecordDetailVC

- (void)dealloc{
    [self resignKeyboard];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        [self addKeyboardNotifications];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"家园手册";
    
    [self.view addSubview:[self calendar]];
    [self.view addSubview:[self switchView]];
    [self.view addSubview:[self scrollView]];
    [self.switchView setY:self.calendar.bottom];
    [self.scrollView setFrame:CGRectMake(0, self.switchView.bottom, self.view.width, self.view.height - self.switchView.bottom)];
}

- (Calendar *)calendar{
    if(_calendar == nil){
        _calendar = [[Calendar alloc] initWithDate:[NSDate date]];
        [_calendar setDelegate:self];
    }
    return _calendar;
}

- (GrowthRecordChildSwitchView *)switchView{
    if(nil == _switchView){
        _switchView = [[GrowthRecordChildSwitchView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
        [_switchView setIndexChanged:^(NSInteger selectedIndex) {
            
        }];
        [_switchView setGrowthRecordArray:self.studentArray];
        [_switchView setSelectedIndex:[self.studentArray indexOfObject:self.studentInfo]];
    }
    return _switchView;
}

- (UITouchScrollView *)scrollView{
    if(nil == _scrollView){
        _scrollView = [[UITouchScrollView alloc] initWithFrame:CGRectMake(0, 40, self.view.width, self.view.height - 40)];
        [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_scrollView setAlwaysBounceVertical:YES];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setDelegate:self];
        
        [_scrollView addSubview:[self recordInfoView]];
        [_scrollView addSubview:[self commentView]];
        [_scrollView addSubview:[self voiceView]];
        [_scrollView addSubview:[self photoView]];
        [_scrollView addSubview:[self inputView]];
        [_scrollView addSubview:[self parentReplyView]];
        [self updateContentView];
    }
    return _scrollView;
}

- (RecordInfoView *)recordInfoView{
    if(nil == _recordInfoView){
        _recordInfoView = [[RecordInfoView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
        [_recordInfoView setShowTitle:NO];
    }
    return _recordInfoView;
}

- (NotificationInputView *)inputView{
    if(nil == _inputView){
        @weakify(self)
        _inputView = [[NotificationInputView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kActionBarHeight)];
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
        [_commentView.layer setBorderColor:[UIColor redColor].CGColor];
        [_commentView.layer setBorderWidth:1];
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

- (ParentReplyView *)parentReplyView{
    if(nil == _parentReplyView){
        _parentReplyView = [[ParentReplyView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    }
    return _parentReplyView;
}

- (void)updateContentView{
    CGFloat spaceYStart = 0;
    
    [self.recordInfoView setY:spaceYStart];
    spaceYStart = self.recordInfoView.bottom;
    
    [self.commentView setY:spaceYStart];
    spaceYStart = self.commentView.bottom;
    
    [self.voiceView setY:spaceYStart];
    spaceYStart = self.voiceView.bottom;
    
    [self.photoView setY:spaceYStart];
    spaceYStart = self.photoView.bottom;
    
    [self.inputView setY:spaceYStart];
    spaceYStart = self.inputView.bottom;
    
    [self.parentReplyView setY:spaceYStart];
    spaceYStart = self.parentReplyView.bottom;
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, spaceYStart)];
}

- (void)onKeyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    NSInteger keyboardHeight = keyboardRect.size.height;
    [self onSwipe];
    [UIView animateWithDuration:animationDuration animations:^{
        [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, keyboardHeight, 0)];
    }completion:^(BOOL finished) {
    }];
    
}

- (void)onKeyboardWillHide:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        [_scrollView setContentInset:UIEdgeInsetsZero];
    }completion:^(BOOL finished) {
        
    }];
}

- (void)onSwipe{
//    if(_inputView.actionType != ActionTypeNone){
//        [_inputView setActionType:ActionTypeNone];
//    }
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


#pragma mark - CalendarDelegate
- (void)calendarDateDidChange:(NSDate *)selectedDate{
    
}

- (void)calendarHeightWillChange:(CGFloat)height{
    [UIView animateWithDuration:0.3 animations:^{
        [self.switchView setY:height];
        [self.scrollView setFrame:CGRectMake(0, self.switchView.bottom, self.view.width, self.view.height - self.switchView.bottom)];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
