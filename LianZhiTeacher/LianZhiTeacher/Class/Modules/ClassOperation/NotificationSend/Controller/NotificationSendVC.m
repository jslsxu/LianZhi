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
#import "NotificationManager.h"
#import "NotificationDraftManager.h"
#import "NotificationScopeVC.h"
#define kNotificationMaxPhotoNum        9

@interface NotificationSendVC ()<NotificationInputDelegate,
UIGestureRecognizerDelegate,
UIScrollViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
DNImagePickerControllerDelegate>
@property (nonatomic, strong)NotificationSendEntity *sendEntity;
@property (nonatomic, strong)NotificationSendEntity *compareEntity;
@property (nonatomic, strong)NotificationTargetContentView*  targetContentView;
@property (nonatomic, strong)NotificationSendChoiceView*     smsChoiceView;
@property (nonatomic, strong)NotificationSendChoiceView*     timerSendView;
@property (nonatomic, strong)NotificationCommentView*        commentView;
@property (nonatomic, strong)NotificationVoiceView*          voiceView;
@property (nonatomic, strong)NotificationPhotoView*          photoView;
@property (nonatomic, strong)NotificationVideoView*          videoView;
@end

@implementation NotificationSendVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.interactivePopDisabled = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWindowShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWindowShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWindowHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (instancetype)initWithSendEntity:(NotificationSendEntity *)sendEntity{
    self = [super init];
    if(self){
        self.sendEntity = sendEntity;
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

- (void)back{
    [self stopPlayAudio];
    if([self.sendEntity isSame:self.compareEntity]){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        if(self.sendType == NotificationSendDraft){
            //草稿，覆盖
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提醒" message:@"草稿已存在，是否覆盖?" style:LGAlertViewStyleAlert buttonTitles:@[ @"放弃修改",@"覆盖"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
            [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
            [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
            [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
            [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                if(index == 0){
                
                }
                else if (index == 1){
                    [[NotificationDraftManager sharedInstance] updateDraft:self.sendEntity];
//                    [self.sendEntity updateClientID];
//                    [[NotificationDraftManager sharedInstance] addDraft:self.sendEntity];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertView setCancelHandler:^(LGAlertView *alertView) {
            }];
            [alertView showAnimated:YES completionHandler:nil];
        }
        else{
            //是否保存到草稿
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提醒" message:@"是否存入草稿箱?" style:LGAlertViewStyleAlert buttonTitles:@[@"不保存", @"保存"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
            [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
            [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
            [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
            [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                if(index == 0){
                    
                }
                else if (index == 1){
                    [[NotificationDraftManager sharedInstance] addDraft:self.sendEntity];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertView setCancelHandler:^(LGAlertView *alertView) {
            }];
            [alertView showAnimated:YES completionHandler:nil];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!self.sendEntity){
        self.sendEntity = [[NotificationSendEntity alloc] init];
        [self.sendEntity setWords:[NSString stringWithFormat:@"%@教师发来通知:",[UserCenter sharedInstance].userInfo.name]];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.sendEntity];
        self.compareEntity = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    });
    self.title = @"发布通知";
    [self.view setBackgroundColor:[UIColor whiteColor]];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"预览" style:UIBarButtonItemStylePlain target:self action:@selector(onPreview)];
    _scrollView = [[UITouchScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
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
    
    @weakify(self)
    _inputView = [[NotificationInputView alloc] initWithFrame:CGRectMake(0, self.view.height - 64 - kActionBarHeight, self.view.width, kActionBarHeight)];
    [_inputView setPhotoNum:^NSInteger{
        @strongify(self)
        return self.sendEntity.imageArray.count;
    }];
    [_inputView setVideoNum:^NSInteger{
        @strongify(self)
        return self.sendEntity.videoArray.count;
    }];
    [_inputView setCanRecord:^BOOL{
        @strongify(self)
        return self.sendEntity.voiceArray.count == 0;
    }];
    [_inputView setDelegate:self];
    [self.view addSubview:_inputView];

}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onPreview{
    [self stopPlayAudio];
//    self.sendEntity.words = self.commentView.content;
//    if(self.sendEntity.delaySend){
//        if(self.sendEntity.delaySendTime == 0){
//            [ProgressHUD showHintText:@"还没有选择延迟发送的时间"];
//            return;
//        }
//    }
    if([self checkNotification]){
        @weakify(self)
        NotificationPreviewVC *previewVC = [[NotificationPreviewVC alloc] init];
        [previewVC setSendCallback:^{
            @strongify(self)
            [self sendNotification];
        }];
        [previewVC setSendEntity:self.sendEntity];
        [self.navigationController pushViewController:previewVC animated:YES];
    }
}

- (void)onSwipe{
    if(_inputView.actionType != ActionTypeNone){
        [_inputView setActionType:ActionTypeNone];
    }
}

- (void)sendNotification{
    [self stopPlayAudio];
    if([self checkNotification]){
        YYReachability *reachability = [YYReachability reachability];
        YYReachabilityStatus status = reachability.status;
        if(status == YYReachabilityStatusNone){
            [ProgressHUD showHintText:@"网络异常，存入到草稿"];
            if(self.sendType == NotificationSendDraft){
                [[NotificationDraftManager sharedInstance] updateDraft:self.sendEntity];
            }
            else{
                [[NotificationDraftManager sharedInstance] addDraft:self.sendEntity];//存入草稿
            }
        }
        else{
            [[NotificationManager sharedInstance] addNotification:self.sendEntity];
            if(self.sendType == NotificationSendDraft){//如果是草稿，则删除草稿
                [[NotificationDraftManager sharedInstance] removeDraft:self.sendEntity];
            }
        }
        NSArray *vcArray = [self.navigationController viewControllers];
        for (UIViewController *vc in vcArray) {
            if([vc isKindOfClass:NSClassFromString(@"NotificationHistoryVC")]){
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
    }
}

- (void)setupScrollView{
    [_scrollView addSubview:self.targetContentView];
    [_scrollView addSubview:self.smsChoiceView];
    [_scrollView addSubview:self.timerSendView];
    [_scrollView addSubview:self.commentView];
    [_scrollView addSubview:self.voiceView];
    [_scrollView addSubview:self.photoView];
    [_scrollView addSubview:self.videoView];
    [self.targetContentView setTargets:self.sendEntity.targets];
    [self.commentView setContent:self.sendEntity.words];
    [self.smsChoiceView setIsOn:self.sendEntity.sendSms];
    [self.timerSendView setIsOn:self.sendEntity.delaySend];
    [self.timerSendView setInfoStr:[self.sendEntity delaySendTimeStr]];
    [self.voiceView setVoiceArray:self.sendEntity.voiceArray];
    [self.photoView setPhotoArray:self.sendEntity.imageArray];
    [self.videoView setVideoArray:self.sendEntity.videoArray];
    [self adjustPosition];
}

- (void)adjustPosition{
    [self.smsChoiceView setTop:self.targetContentView.bottom];
    [self.timerSendView setTop:self.smsChoiceView.bottom];
    [self.commentView setTop:self.timerSendView.bottom];
    [self.voiceView setTop:self.commentView.bottom];
    [self.photoView setTop:self.voiceView.bottom];
    [self.videoView setTop:self.photoView.bottom];
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, self.videoView.bottom)];
}

- (NotificationTargetContentView *)targetContentView{
    if(_targetContentView == nil){
         @weakify(self);
        _targetContentView = [[NotificationTargetContentView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, 0)];
        [_targetContentView setAddBlk:^{
            @strongify(self)
            [self onAddTarget];
            }];
        [_targetContentView setDeleteDataCallback:^(id userInfo) {
            @strongify(self)
            [self deleteUserInfo:userInfo];
        }];
        
    }
    return _targetContentView;
}

- (NotificationSendChoiceView *)smsChoiceView{
    if(_smsChoiceView == nil){
        @weakify(self)
        _smsChoiceView = [[NotificationSendChoiceView alloc] initWithFrame:CGRectMake(0, _targetContentView.bottom, _scrollView.width, 54) title:@"连枝代发短信"];
        [_smsChoiceView setSwitchCallback:^(BOOL on) {
            @strongify(self)
            self.sendEntity.sendSms = on;
            [self.commentView setMaxWordsNum:[self.sendEntity maxCommentWordsNum]];
        }];
    }
    return _smsChoiceView;
}

- (NotificationSendChoiceView *)timerSendView{
    @weakify(self);
    if(_timerSendView == nil){
        _timerSendView = [[NotificationSendChoiceView alloc] initWithFrame:CGRectMake(0, _smsChoiceView.bottom, _scrollView.width, 0) title:@"定时发送"];
        [_timerSendView setInfoAction:^{
            [NotificationSelectTimeView showWithCompletion:^(NSInteger timeInterval) {
                @strongify(self);
                [self updateDate:timeInterval];
            } defaultDate:nil];
        }];
        [_timerSendView setSwitchCallback:^(BOOL isOn) {
            @strongify(self);
            if(isOn){
                self.sendEntity.delaySend = YES;
                [NotificationSelectTimeView showWithCompletion:^(NSInteger timeInterval) {
                    @strongify(self);
                    [self updateDate:timeInterval];
                } defaultDate:nil];
            }
            else{
                [self updateDate:0];
            }
        }];
    }
    return _timerSendView;
}

- (NotificationCommentView *)commentView{
    if(_commentView == nil){
        @weakify(self)
        _commentView = [[NotificationCommentView alloc] initWithFrame:CGRectMake(0, _timerSendView.bottom, _scrollView.width, 135)];
        [_commentView setPlaceHolder:@"请输入正文内容"];
        [_commentView setMaxWordsNum:[self.sendEntity maxCommentWordsNum]];
        [_commentView setContent:self.sendEntity.words];
        [_commentView setTextViewWillChangeHeight:^(CGFloat height) {
            @strongify(self)
            [self adjustPosition];
        }];
        [_commentView setTextViewTextChanged:^(NSString *text) {
            @strongify(self)
            self.sendEntity.words = text;
        }];
    }
    return _commentView;
}

- (NotificationVoiceView *)voiceView{
    if(_voiceView == nil){
        _voiceView = [[NotificationVoiceView alloc] initWithFrame:CGRectMake(0, _commentView.bottom, _scrollView.width, 0)];
        @weakify(self)
        [_voiceView setDeleteDataCallback:^(id voiceItem) {
            @strongify(self)
            [self deleteAudioItem:voiceItem];
        }];
    }
    return _voiceView;
}

- (NotificationPhotoView *)photoView{
    if(_photoView == nil){
        @weakify(self)
        _photoView = [[NotificationPhotoView alloc] initWithFrame:CGRectMake(0, _voiceView.bottom, _scrollView.width, 0)];
        [_photoView setDeleteDataCallback:^(id image) {
            @strongify(self)
            [self deleteImage:image];
        }];
    }
    return _photoView;
}

- (NotificationVideoView *)videoView{
    if(_videoView == nil){
        _videoView = [[NotificationVideoView alloc] initWithFrame:CGRectMake(0, _photoView.bottom, _scrollView.width, 0)];
        @weakify(self)
        [_videoView setDeleteDataCallback:^(VideoItem *videoItem) {
            @strongify(self)
            [self deleteVideo:videoItem];
        }];
    }
    return _videoView;
}

- (void)onAddTarget{
    [self stopPlayAudio];
    NotificationMemberSelectVC *targetSelectVC = [[NotificationMemberSelectVC alloc] initWithOriginalArray:self.sendEntity.targets];
    [targetSelectVC setSelectCompletion:^(NSArray *classArray, NSArray *groupArray) {
        NSMutableArray *selectedClassArray = [NSMutableArray array];
        for (ClassInfo *classInfo in classArray) {
            BOOL groupSelected = NO;
            for (StudentInfo *studentInfo in classInfo.students) {
                if(studentInfo.selected){
                    groupSelected = YES;
                }
            }
            if(groupSelected){
                [selectedClassArray addObject:classInfo];
            }
        }
        NSMutableArray *selectedGroupArray = [NSMutableArray array];
        for (TeacherGroup *teacherGroup in groupArray) {
            BOOL groupSelected = NO;
            for (TeacherInfo *teacherInfo in teacherGroup.teachers) {
                if(teacherInfo.selected){
                    groupSelected = YES;
                }
            }
            if(groupSelected){
                [selectedGroupArray addObject:teacherGroup];
            }
        }
        if([selectedClassArray count] > 0){
            [self.sendEntity setClassArray:selectedClassArray];
        }
        else{
            [self.sendEntity setClassArray:nil];
        }
        if([selectedGroupArray count] > 0){
            [self.sendEntity setGroupArray:selectedGroupArray];
        }
        else{
            [self.sendEntity setGroupArray:nil];
        }
        [self.targetContentView setTargets:self.sendEntity.targets];
        [self adjustPosition];
    }];
    [self.navigationController pushViewController:targetSelectVC animated:YES];

//    NotificationScopeVC* scopeVC = [[NotificationScopeVC alloc] init];
//    [self.navigationController pushViewController:scopeVC animated:YES];
}

- (void)deleteUserInfo:(UserInfo *)userInfo{
    [self.sendEntity removeTarget:userInfo];
    [_targetContentView setTargets:self.sendEntity.targets];
    [self adjustPosition];
}

- (void)deleteAudioItem:(AudioItem *)audioItem{
    [self.sendEntity.voiceArray removeObject:audioItem];
    [_voiceView setVoiceArray:self.sendEntity.voiceArray];
    [self adjustPosition];
}

- (void)deleteImage:(PhotoItem *)photoItem{
    [self.sendEntity.imageArray removeObject:photoItem];
    [_photoView setPhotoArray:self.sendEntity.imageArray];
    [self adjustPosition];
}

- (void)deleteVideo:(VideoItem *)videoItem{
    [self.sendEntity.videoArray removeObject:videoItem];
    [_videoView setVideoArray:self.sendEntity.videoArray];
    [self adjustPosition];
}

- (void)updateDate:(NSInteger)timeInterval{
    if(timeInterval > 0){
        self.sendEntity.delaySend = YES;
        self.sendEntity.delaySendTime = timeInterval;
    }
    else{
        self.sendEntity.delaySendTime = 0;
        self.sendEntity.delaySend = NO;
    }
    NSString *dateStr = nil;
    if(timeInterval > 0){
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd HH:mm"];
        dateStr = [formater stringFromDate:date];
    }
    [_timerSendView setInfoStr:dateStr];
    [_timerSendView setIsOn:self.sendEntity.delaySend];
}

- (void)addImage:(NSArray *)imageArray{
    NSMutableArray *sendImageArray = self.sendEntity.imageArray;
    NSInteger originalCount = sendImageArray.count;
    for (NSInteger i = 0; i < MIN(kNotificationMaxPhotoNum - originalCount, imageArray.count); i++) {
        [sendImageArray addObject:imageArray[i]];
    }
    [self.photoView setPhotoArray:sendImageArray];
    [self adjustPosition];
}

- (void)addVideo:(NSArray *)videoArray{
    NSMutableArray *sendVideoArray = self.sendEntity.videoArray;
    [sendVideoArray addObjectsFromArray:videoArray];
    [self.videoView setVideoArray:sendVideoArray];
    [self adjustPosition];
}

- (void)stopPlayAudio{
    if([MLAmrPlayer shareInstance].isPlaying){
        [[MLAmrPlayer shareInstance] stopPlaying];
    }
}

- (BOOL)checkNotification{
    if(self.sendEntity.targets.count == 0){
        [ProgressHUD showHintText:@"请选择发送对象"];
        return NO;
    }
    
    if([self.sendEntity.words length] == 0){
        [ProgressHUD showHintText:@"请输入通知内容"];
        return NO;
    }
    
    if(self.sendEntity.delaySend && self.sendEntity.delaySendTime == 0){
        [ProgressHUD showHintText:@"请选择时间"];
        return NO;
    }
    return YES;
}

#pragma mark - NotificationInputDelegate

- (void)notificationInputDidWillChangeHeight:(CGFloat)height{
    [self.navigationItem.rightBarButtonItem setEnabled:height < 100];
    [UIView animateWithDuration:kActionAnimationDuration animations:^{
        [_inputView setY:self.view.height - height];
        [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, height, 0)];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)notificationInputPhoto:(NotificationInputView *)inputView{
    DNImagePickerController *imagePicker = [[DNImagePickerController alloc] init];
    [imagePicker setImagePickerDelegate:self];
    [imagePicker setMaxImageCount:9 - self.sendEntity.imageArray.count];
    [imagePicker setMaxVideoCount:1 - self.sendEntity.videoArray.count];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)notificationInputQuickPhoto:(NSArray *)photoArray fullImage:(BOOL)isFullImage{
    [_inputView setActionType:ActionTypeNone];
    NSMutableArray* addImageArray = [NSMutableArray array];
    NSMutableArray* addVideoArray = [NSMutableArray array];
    if(photoArray.count > 0){
        for (XMNAssetModel *asset in photoArray) {
            if(asset.type == XMNAssetTypeVideo){
                if(self.sendEntity.videoArray.count > 0){
                    continue;
                }
                NSString *tmpPath = [NHFileManager tmpVideoPathForPath:asset.filepath];
                if([[NSFileManager defaultManager] fileExistsAtPath:tmpPath]){
                    NSData *data = [NSData dataWithContentsOfFile:tmpPath];
                    NSLog(@"data length is %zd",data.length);
                }
                else{
                    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在压缩" toView:[UIApplication sharedApplication].keyWindow];
                    AVAsset *avAsset = [AVAsset assetWithURL:[NSURL URLWithString:asset.filepath]];
                    AVAssetExportSession * exportSession = [AVAssetExportSession exportSessionWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
                    exportSession.outputFileType = AVFileTypeMPEG4;
                    exportSession.shouldOptimizeForNetworkUse = YES;
                    exportSession.outputURL = [NSURL fileURLWithPath:tmpPath];
                    [exportSession exportAsynchronouslyWithCompletionHandler:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [hud hide:YES];
                            if(AVAssetExportSessionStatusCompleted == exportSession.status){
                                
                            }
                            else{
                                [ProgressHUD showHintText:@"压缩失败"];
                            }
                        });
                    }];
                }
                VideoItem *videoItem = [[VideoItem alloc] init];
                [videoItem setVideoUrl:tmpPath];
                [videoItem setCoverImage:asset.previewImage];
                [addVideoArray addObject:videoItem];
            }
            else if(asset.type == XMNAssetTypePhoto){
                UIImage *image;
                if(isFullImage){
                    image = [UIImage imageWithCGImage:[[asset.asset defaultRepresentation] fullResolutionImage] scale:1.f orientation:UIImageOrientationUp];
                }
                else{
                    image = [UIImage imageWithCGImage:[[asset.asset defaultRepresentation] fullScreenImage] scale:1.f orientation:UIImageOrientationUp];
                }
                if(image && self.sendEntity.imageArray.count + addImageArray.count < 9){
                    [addImageArray addObject:image];
                }
            }
        }
    }
    if(addImageArray.count > 0)
    {
        MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在压缩" toView:[UIApplication sharedApplication].keyWindow];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray *photoItemArray = [NSMutableArray array];
            for (UIImage *image in addImageArray) {
                NSString *tmpImagePath = [NHFileManager getTmpImagePath];
                NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
                [imageData writeToFile:tmpImagePath atomically:YES];
                PhotoItem *photoItem = [[PhotoItem alloc] init];
                [photoItem setWidth:image.size.width];
                [photoItem setHeight:image.size.height];
                [photoItem setBig:tmpImagePath];
                [photoItem setSmall:tmpImagePath];
                [photoItemArray addObject:photoItem];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                [self addImage:photoItemArray];
            });
        });

    }
    if(addVideoArray.count > 0){
        [self addVideo:addVideoArray];
    }
    if(addImageArray.count + addVideoArray.count > 0)
        [_inputView setActionType:ActionTypeNone];
}

- (void)notificationInputVideo:(NotificationInputView *)inputView
{
//    [VideoRecordView showWithCompletion:^(NSURL *videoPath) {
//        
//    }];
    [_inputView setActionType:ActionTypeNone];
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    [imagePicker setMediaTypes:@[(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage]];
    [imagePicker setVideoMaximumDuration:10];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self.navigationController presentViewController:imagePicker animated:YES completion:^{

    }];
}

- (void)notificationInputAudio:(NotificationInputView *)inputView audioItem:(AudioItem *)audioItem{
    if(audioItem){
        [self.sendEntity.voiceArray addObject:audioItem];
        [_voiceView setVoiceArray:self.sendEntity.voiceArray];
        [self adjustPosition];
        [_inputView setActionType:ActionTypeNone];
    }
}

- (void)notificationInputSend{
    [self sendNotification];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(_inputView.actionType != ActionTypeNone)
        [_inputView setActionType:ActionTypeNone];
}

#pragma mark - UIImagePicerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    @weakify(self)
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //        MJPhoto *photo = _photos[_currentPhotoIndex];
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        });
        if(self.sendEntity.imageArray.count >= 9){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"最多只能选择9张图片，拍摄内容已保存" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        else{
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            if(image){
                MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在压缩" toView:[UIApplication sharedApplication].keyWindow];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImage *resultImage = [image formatImage];
                    NSString *tmpImagePath = [NHFileManager getTmpImagePath];
                    NSData *imageData = UIImageJPEGRepresentation(resultImage, 0.8);
                    [imageData writeToFile:tmpImagePath atomically:YES];
                    PhotoItem *photoItem = [[PhotoItem alloc] init];
                    [photoItem setWidth:resultImage.size.width];
                    [photoItem setHeight:resultImage.size.height];
                    [photoItem setBig:tmpImagePath];
                    [photoItem setSmall:tmpImagePath];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hide:YES];
                        [self addImage:@[photoItem]];
                    });
                });
            }

        }
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        NSURL *url = info[UIImagePickerControllerMediaURL];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UISaveVideoAtPathToSavedPhotosAlbum(url.path, nil, nil, nil);
        });
        if(self.sendEntity.videoArray.count > 0){
            [picker dismissViewControllerAnimated:YES completion:^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"一次只能发送1个视频,拍摄内容已保存" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }];
        }
        else{
            NSURL *url = info[UIImagePickerControllerMediaURL];
            NSString *extasion = url.pathExtension;
            NSString *finalPath = [[NHFileManager getTmpVideoPath] stringByAppendingPathExtension:extasion];
            [FCFileManager moveItemAtPath:url.path toPath:finalPath overwrite:YES];
            url = [NSURL fileURLWithPath:finalPath];
            NSData *data = [NSData dataWithContentsOfURL:url];
            if(data.length > 1024 * 1024 * 10){
                LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提示" message:@"视频文件过大" style:LGAlertViewStyleAlert buttonTitles:@[@"确定"] cancelButtonTitle:nil destructiveButtonTitle:nil];
                [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
                [alertView showAnimated:YES completionHandler:nil];
                return;
            }
            NSString *sizeStr = [Utility sizeStrForSize:data.length];
            NSInteger duration = [self getVideoDuration:url];
            LGAlertView*    alertView = [[LGAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"视频压缩后文件大小为%@",sizeStr] style:LGAlertViewStyleAlert buttonTitles:@[@"确定"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
            [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
            [alertView setButtonsFont:[UIFont boldSystemFontOfSize:18]];
            [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
            [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
            [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                @strongify(self);
                VideoItem *videoItem = [[VideoItem alloc] init];
                [videoItem setVideoUrl:finalPath];
                [videoItem setCoverImage:[UIImage coverImageForVideo:url]];
                [videoItem setVideoTime:duration];
                [self addVideo:@[videoItem]];
                [picker dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertView setCancelHandler:^(LGAlertView *alertView) {
                [picker dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertView showAnimated:YES completionHandler:nil];

        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DNImagePickerControllerDelegate
- (void)dnImagePickerController:(DNImagePickerController *)imagePicker sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage{
    if(imageAssets.count > 0){
        NSMutableArray *addImageArray = [NSMutableArray array];
        NSMutableArray *addVideoArray = [NSMutableArray array];
        for (ALAsset *asset in imageAssets) {
            if([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]){
                UIImage *image;
                if(fullImage)
                    image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage] scale:1.f orientation:UIImageOrientationUp];
                else
                    image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage] scale:1.f orientation:UIImageOrientationUp];
                if(image)
                {
                    [addImageArray addObject:image];
                }
            }
            else if([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]){
                if(self.sendEntity.videoArray.count > 0){
                    continue;
                }
                NSString *filePath = [[asset.defaultRepresentation url] absoluteString];
                NSString *tmpPath = [NHFileManager tmpVideoPathForPath:filePath];
                NSInteger duration = [[asset valueForProperty:ALAssetPropertyDuration] integerValue];
                if([[NSFileManager defaultManager] fileExistsAtPath:tmpPath]){
                }
                else{
                    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在压缩" toView:self.view];
                    AVAsset *avAsset = [AVAsset assetWithURL:[NSURL URLWithString:filePath]];
                    AVAssetExportSession * exportSession = [AVAssetExportSession exportSessionWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
                    exportSession.outputFileType = AVFileTypeMPEG4;
                    exportSession.shouldOptimizeForNetworkUse = YES;
                    exportSession.outputURL = [NSURL fileURLWithPath:tmpPath];
                    [exportSession exportAsynchronouslyWithCompletionHandler:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(AVAssetExportSessionStatusCompleted == exportSession.status){
                                [hud hide:YES];
                            }
                            else{
                                [ProgressHUD showHintText:@"压缩失败"];
                            }
                        });
                        
                    }];
                }
                VideoItem *videoItem = [[VideoItem alloc] init];
                [videoItem setVideoUrl:tmpPath];
                [videoItem setCoverImage:[UIImage imageWithCGImage:[asset.defaultRepresentation fullScreenImage] scale:1.f orientation:UIImageOrientationUp]];
                [videoItem setVideoTime:duration];
                [addVideoArray addObject:videoItem];
            }
        }
        if(addImageArray.count > 0){
            MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在压缩" toView:[UIApplication sharedApplication].keyWindow];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSMutableArray *photoItemArray = [NSMutableArray array];
                for (UIImage *image in addImageArray) {
                    NSString *tmpImagePath = [NHFileManager getTmpImagePath];
                    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
                    [imageData writeToFile:tmpImagePath atomically:YES];
                    PhotoItem *photoItem = [[PhotoItem alloc] init];
                    [photoItem setWidth:image.size.width];
                    [photoItem setHeight:image.size.height];
                    [photoItem setBig:tmpImagePath];
                    [photoItem setSmall:tmpImagePath];
                    [photoItemArray addObject:photoItem];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    [self addImage:photoItemArray];
                });
            });
        }
        if(addVideoArray.count > 0){
            [self addVideo:addVideoArray];
        }
        [_inputView setActionType:ActionTypeNone];
    }
}

- (void)dnImagePickerControllerDidCancel:(DNImagePickerController *)imagePicker{
    
}

- (CGFloat) getVideoDuration:(NSURL*) URL
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    return second;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
