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
#define kNotificationMaxPhotoNum        9

@interface NotificationSendVC ()<NotificationInputDelegate,
UIGestureRecognizerDelegate,
UIScrollViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
DNImagePickerControllerDelegate>
@property (nonatomic, strong)NotificationSendEntity *sendEntity;

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
        if(!self.sendEntity){
            self.sendEntity = [[NotificationSendEntity alloc] init];
        }
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

- (void)viewDidLoad {
    [super viewDidLoad];
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
//    self.sendEntity.words = self.commentView.content;
//    if(self.sendEntity.delaySend){
//        if(self.sendEntity.delaySendTime == 0){
//            [ProgressHUD showHintText:@"还没有选择延迟发送的时间"];
//            return;
//        }
//    }
    if([self checkNotification]){
        NotificationPreviewVC *previewVC = [[NotificationPreviewVC alloc] init];
        [previewVC setSendEntity:self.sendEntity];
        [self.navigationController pushViewController:previewVC animated:YES];
    }
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
            [self.commentView setMaxWordsNum:on ? 150 : 500];
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
            }];
        }];
        [_timerSendView setSwitchCallback:^(BOOL isOn) {
            @strongify(self);
            if(isOn){
                self.sendEntity.delaySend = YES;
                [NotificationSelectTimeView showWithCompletion:^(NSInteger timeInterval) {
                    @strongify(self);
                    [self updateDate:timeInterval];
                }];
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
        [_commentView setContent:self.sendEntity.words];
        [_commentView setTextViewWillChangeHeight:^(CGFloat height) {
            
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
    NotificationMemberSelectVC *targetSelectVC = [[NotificationMemberSelectVC alloc] initWithOriginalArray:self.sendEntity.targets];
    [targetSelectVC setSelectCompletion:^(NSArray *classArray, NSArray *groupArray) {
//        NSMutableArray *targetArray = [NSMutableArray array];
//        for (ClassInfo *classInfo in classArray) {
//            for (StudentInfo *studentInfo in classInfo.students) {
//                if(studentInfo.selected){
//                    [targetArray addObject:studentInfo];
//                }
//            }
//        }
//        for (TeacherGroup *teacherGroup in groupArray) {
//            for (TeacherInfo *teacherInfo in teacherGroup.teachers) {
//                if(teacherInfo.selected){
//                    [targetArray addObject:teacherInfo];
//                }
//            }
//        }
        [self.sendEntity setClassArray:[NSMutableArray arrayWithArray:classArray]];
        [self.sendEntity setGroupArray:[NSMutableArray arrayWithArray:groupArray]];
        [self.targetContentView setTargets:self.sendEntity.targets];
        [self adjustPosition];
    }];
    [self.navigationController pushViewController:targetSelectVC animated:YES];

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

- (BOOL)checkNotification{
    if(self.sendEntity.targets.count == 0){
        [ProgressHUD showHintText:@"请选择发送对象"];
        return NO;
    }
    
    if([self.sendEntity.words length] == 0){
        [ProgressHUD showHintText:@"请输入通知内容"];
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
                [videoItem setLocalVideoPath:tmpPath];
                [videoItem setCoverImage:asset.previewImage];
                [addVideoArray addObject:videoItem];
            }
            else if(asset.type == XMNAssetTypePhoto){
                UIImage *image;
                if(isFullImage){
                    image = asset.originImage;
                }
                else{
                    image = asset.previewImage;
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
    [self presentViewController:imagePicker animated:YES completion:^{
        
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
    if([self checkNotification]){
        [[NotificationManager sharedInstance] addNotification:self.sendEntity];
        if([[NotificationDraftManager sharedInstance].draftArray containsObject:self.sendEntity]){
            [[NotificationDraftManager sharedInstance] removeDraft:self.sendEntity];
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
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if(image){
            image = [image resize:[UIScreen mainScreen].bounds.size];
            [self addImage:@[image]];
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        if(self.sendEntity.videoArray.count > 0){
            return;
        }
        NSURL *url = info[UIImagePickerControllerMediaURL];
        NSString *extasion = url.pathExtension;
        NSString *finalPath = [[NHFileManager getTmpVideoPath] stringByAppendingPathExtension:extasion];
        [FCFileManager moveItemAtPath:url.path toPath:finalPath overwrite:YES];
        url = [NSURL fileURLWithPath:finalPath];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSString *sizeStr = [Utility sizeStrForSize:data.length];
        NSInteger duration = [self getVideoDuration:url];
        @weakify(self)
        LGAlertView*    alertView = [[LGAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"视频压缩后文件大小为%@",sizeStr] style:LGAlertViewStyleAlert buttonTitles:@[@"发送"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
        [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
        [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
        [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
            @strongify(self);
            VideoItem *videoItem = [[VideoItem alloc] init];
            [videoItem setLocalVideoPath:finalPath];
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DNImagePickerControllerDelegate
- (void)dnImagePickerController:(DNImagePickerController *)imagePicker sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage{
    if(imageAssets.count > 0){
        NSMutableArray *imageArray = self.sendEntity.imageArray;
        NSMutableArray *addImageArray = [NSMutableArray array];
        NSMutableArray *addVideoArray = [NSMutableArray array];
        for (ALAsset *asset in imageAssets) {
            if([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]){
                UIImage *image;
                if(fullImage)
                    image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                else
                    image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
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
                [videoItem setLocalVideoPath:tmpPath];
                [videoItem setCoverImage:[UIImage imageWithCGImage:[asset.defaultRepresentation fullScreenImage]]];
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
