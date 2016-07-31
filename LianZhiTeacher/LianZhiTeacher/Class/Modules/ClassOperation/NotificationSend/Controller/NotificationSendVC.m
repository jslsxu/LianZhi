//
//  NotificationSendVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/6/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationSendVC.h"
#import "NotificationSelectTimeView.h"
#import "NotificationSendEntity.h"
#import "NotificationMemberSelectVC.h"
#import "VideoRecordView.h"
#import "DNAsset.h"
#import "DNImagePickerController.h"
#import "NotificationPreviewVC.h"
@interface NotificationSendVC ()<NotificationInputDelegate,
UIGestureRecognizerDelegate,
UIScrollViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>
@property (nonatomic, strong)NotificationSendEntity *sendEntity;

@property (nonatomic, strong)NotificationTargetContentView*  targetContentView;
@property (nonatomic, strong)NotificationSendChoiceView*     smsChoiceView;
@property (nonatomic, strong)NotificationSendChoiceView*     timerSendView;
@property (nonatomic, strong)NotificationCommentView*        commentView;
@property (nonatomic, strong)NotificationVoiceView*          voiceView;
@property (nonatomic, strong)NotificationPhotoView*          photoView;

@end

@implementation NotificationSendVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.sendEntity = [[NotificationSendEntity alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWindowShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWindowShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWindowHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)onKeyboardWindowShow:(NSNotification *)notification{
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

- (void)onKeyboardWindowHide:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, kActionBarHeight, 0)];
    }completion:^(BOOL finished) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布通知";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"预览" style:UIBarButtonItemStylePlain target:self action:@selector(onPreview)];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, kActionBarHeight, 0)];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setAlwaysBounceVertical:YES];
    [_scrollView setDelegate:self];
    [self setupScrollView];
    [self.view addSubview:_scrollView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe)];
    [tapGesture setDelegate:self];
    [tapGesture setCancelsTouchesInView:NO];
    [_scrollView addGestureRecognizer:tapGesture];
    
    _inputView = [[NotificationInputView alloc] initWithFrame:CGRectMake(0, self.view.height - 64 - kActionBarHeight, self.view.width, kActionBarHeight)];
    [_inputView setDelegate:self];
    [self.view addSubview:_inputView];

}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onPreview{
    NotificationPreviewVC *previewVC = [[NotificationPreviewVC alloc] init];
    [self.navigationController pushViewController:previewVC animated:YES];
}

- (void)onSwipe{
    if(_inputView.actionType != ActionTypeNone){
        [_inputView setActionType:ActionTypeNone];
    }
}

- (void)setupScrollView{
    [_scrollView addSubview:self.targetContentView];
    [_scrollView addSubview:self.smsChoiceView];
    [_scrollView addSubview:self.timerSendView];
    [_scrollView addSubview:self.commentView];
    [_scrollView addSubview:self.voiceView];
    [_scrollView addSubview:self.photoView];
    [self adjustPosition];
}

- (void)adjustPosition{
    [self.smsChoiceView setTop:self.targetContentView.bottom];
    [self.timerSendView setTop:self.smsChoiceView.bottom];
    [self.commentView setTop:self.timerSendView.bottom];
    [self.voiceView setTop:self.commentView.bottom];
    [self.photoView setTop:self.voiceView.bottom];
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, _photoView.bottom)];
}

- (NotificationTargetContentView *)targetContentView{
    if(_targetContentView == nil){
         @weakify(self);
        UserInfo *userInfo = [UserCenter sharedInstance].userInfo;
        _targetContentView = [[NotificationTargetContentView alloc] initWithWidth:_scrollView.width targets:@[userInfo,userInfo,userInfo,userInfo,userInfo,userInfo,userInfo,userInfo,userInfo,userInfo,userInfo,userInfo,userInfo,userInfo]];
        [_targetContentView setAddBlk:^{
            @strongify(self);
            NotificationMemberSelectVC *targetSelectVC = [[NotificationMemberSelectVC alloc] init];
            [targetSelectVC setSelectCompletion:^(NSArray *selectArray) {
                
            }];
            [self.navigationController pushViewController:targetSelectVC animated:YES];
        }];
        
    }
    return _targetContentView;
}

- (NotificationSendChoiceView *)smsChoiceView{
    if(_smsChoiceView == nil){
        _smsChoiceView = [[NotificationSendChoiceView alloc] initWithFrame:CGRectMake(0, _targetContentView.bottom, _scrollView.width, 54) title:@"连枝代发短信"];
    }
    return _smsChoiceView;
}

- (NotificationSendChoiceView *)timerSendView{
    @weakify(self);
    if(_timerSendView == nil){
        _timerSendView = [[NotificationSendChoiceView alloc] initWithFrame:CGRectMake(0, _smsChoiceView.bottom, _scrollView.width, 54) title:@"定时发送"];
        [_timerSendView setInfoAction:^{
            [NotificationSelectTimeView showWithCompletion:^(NSDate *date) {
                @strongify(self);
                [self updateDate:date];
            }];
        }];
    }
    return _timerSendView;
}

- (NotificationCommentView *)commentView{
    if(_commentView == nil){
        _commentView = [[NotificationCommentView alloc] initWithFrame:CGRectMake(0, _timerSendView.bottom, _scrollView.width, 135)];
        [_commentView setTextViewWillChangeHeight:^(CGFloat height) {
            
        }];
    }
    return _commentView;
}

- (NotificationVoiceView *)voiceView{
    if(_voiceView == nil){
        _voiceView = [[NotificationVoiceView alloc] initWithFrame:CGRectMake(0, _commentView.bottom, _scrollView.width, 0)];
    }
    return _voiceView;
}

- (NotificationPhotoView *)photoView{
    if(_photoView == nil){
        _photoView = [[NotificationPhotoView alloc] initWithFrame:CGRectMake(0, _voiceView.bottom, _scrollView.width, 0)];
    }
    return _photoView;
}

- (void)updateDate:(NSDate *)date{
    self.sendEntity.date = date;
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [formater stringFromDate:date];
    [_timerSendView setInfoStr:dateStr];
}

#pragma mark - NotificationInputDelegate

- (void)notificationInputDidWillChangeHeight:(CGFloat)height{
    [UIView animateWithDuration:kActionAnimationDuration animations:^{
        [_inputView setY:self.view.height - height];
        [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, height, 0)];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)notificationInputPhoto:(NotificationInputView *)inputView{
    DNImagePickerController *imagePicker = [[DNImagePickerController alloc] init];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)notificationInputQuickPhoto:(NSArray *)photoArray fullImage:(BOOL)isFullImage{
    [_inputView setActionType:ActionTypeNone];
    NSMutableArray *imageArray = self.sendEntity.imageArray;
    NSInteger originalCount = imageArray.count;
    if(photoArray.count > 0){
        for (XMNAssetModel *asset in photoArray) {
            UIImage *image;
            if(isFullImage){
                image = asset.originImage;
            }
            else{
                image = asset.previewImage;
            }
            if(imageArray.count < 9 && image){
                [imageArray addObject:image];
            }
        }
        if(imageArray.count > originalCount){
            [_photoView setPhotoArray:imageArray];
            [self adjustPosition];
        }
    }
}

- (void)notificationInputVideo:(NotificationInputView *)inputView
{
    [VideoRecordView showWithCompletion:^(NSURL *videoPath) {
        
    }];
}

- (void)notificationInputAudio:(NotificationInputView *)inputView audioItem:(AudioItem *)audioItem{
    if(audioItem){
        [self.sendEntity.voiceArray addObject:audioItem];
        [_voiceView setVoiceArray:self.sendEntity.voiceArray];
        [self adjustPosition];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isTracking]) {
        [_inputView setActionType:ActionTypeNone];
    }
}


#pragma mark - DNImagePickerControllerDelegate
- (void)dnImagePickerController:(DNImagePickerController *)imagePicker sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage{

}

- (void)dnImagePickerControllerDidCancel:(DNImagePickerController *)imagePicker{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
