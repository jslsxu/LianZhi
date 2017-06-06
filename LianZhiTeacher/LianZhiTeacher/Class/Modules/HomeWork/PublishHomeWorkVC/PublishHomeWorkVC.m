//
//  PublishHomeWorkVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/9/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "PublishHomeWorkVC.h"
#import "DNImagePickerController.h"
#import "HomeworkClassContentView.h"
#import "HomeworkReplySwitchView.h"
#import "NotificationCommentView.h"
#import "NotificationInputView.h"
#import "NotificationVoiceView.h"
#import "NotificationPhotoView.h"
#import "NotificationVideoView.h"
#import "HomeworkExplainView.h"
#import "HomeworkSettingView.h"
#import "NotificationMemberSelectVC.h"
#import "HomeworkNumView.h"
#import "HomeworkCourseView.h"
#import "CourseSelectVC.h"
#import "ClassSelectVC.h"
#import "HomeworkSuperSettingVC.h"
#import "HomeworkAddExplainVC.h"
#import "HomeworkDefine.h"
#import "HomeworkDraftManager.h"
#import "HomeworkManager.h"
#import "HomeworkPreviewVC.h"
@interface PublishHomeWorkVC ()<NotificationInputDelegate,
UIGestureRecognizerDelegate,
UIScrollViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
DNImagePickerControllerDelegate>
@property (nonatomic, strong)HomeWorkEntity*                 homeWorkEntity;
@property (nonatomic, strong)HomeWorkEntity*                compareEntity;
@property (nonatomic, strong)HomeworkCourseView*            courseView;
@property (nonatomic, strong)HomeworkClassContentView*      targetContentView;
@property (nonatomic, strong)HomeworkReplySwitchView*       replySwitchView;
@property (nonatomic, strong)HomeworkNumView*               numView;
@property (nonatomic, strong)NotificationCommentView*        commentView;
@property (nonatomic, strong)HomeworkSettingView*           settingView;
@property (nonatomic, strong)HomeworkExplainView*           explainView;
@property (nonatomic, strong)NotificationVoiceView*          voiceView;
@property (nonatomic, strong)NotificationPhotoView*          photoView;
//@property (nonatomic, strong)NotificationVideoView*          videoView;
@end

@implementation PublishHomeWorkVC
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
- (instancetype)initWithHomeWorkEntity:(HomeWorkEntity *)homeWorkEntity{
    self = [super init];
    if(self){
        self.homeWorkEntity = homeWorkEntity;
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
    if(self.homeWorkEntity.forward){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        if([self.homeWorkEntity isSame:self.compareEntity]){
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            if(self.sendType == HomeworkSendDraft){
                //草稿，覆盖
                LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提醒" message:@"草稿已存在，是否覆盖?" style:LGAlertViewStyleAlert buttonTitles:@[ @"放弃修改",@"覆盖"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
                [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
                [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
                [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
                [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
                    if(index == 0){
                        
                    }
                    else if (index == 1){
                        [[HomeworkDraftManager sharedInstance] updateDraft:self.homeWorkEntity];
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
                        [[HomeworkDraftManager sharedInstance] addDraft:self.homeWorkEntity];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alertView setCancelHandler:^(LGAlertView *alertView) {
                }];
                [alertView showAnimated:YES completionHandler:nil];
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!self.homeWorkEntity){
        self.homeWorkEntity = [[HomeWorkEntity alloc] init];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.homeWorkEntity];
        self.compareEntity = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    });
    self.title = @"发布作业";
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
    [_inputView setForward:self.homeWorkEntity.forward];
    [_inputView setPhotoNum:^NSInteger{
        @strongify(self)
        return self.homeWorkEntity.imageArray.count;
    }];
    [_inputView setVideoNum:^NSInteger{
        return 0;
    }];
    [_inputView setOnlyPhoto:YES];
    [_inputView setCanRecord:^BOOL{
        @strongify(self)
        return [self.homeWorkEntity.voiceArray count] < 1;
    }];
    [_inputView setDelegate:self];
    [self.view addSubview:_inputView];
    
}

- (void)onSwipe{
    if(_inputView.actionType != ActionTypeNone){
        [_inputView setActionType:ActionTypeNone];
    }
}

- (void)onPreview{
    if([self checkHomework]){
        __weak typeof(self) wself = self;
        HomeworkPreviewVC *previewVC = [[HomeworkPreviewVC alloc] init];
        [previewVC setHomeworkEntity:self.homeWorkEntity];
        [previewVC setSendCallback:^{
            [wself publishHomework];
        }];
        [CurrentROOTNavigationVC pushViewController:previewVC animated:YES];
    }
}

- (BOOL)checkHomework{
    
    if([self.homeWorkEntity.course_name length] == 0){
        [ProgressHUD showHintText:@"请选择作业科目"];
        return NO;
    }
    
    if(self.homeWorkEntity.targets.count == 0){
        [ProgressHUD showHintText:@"请选择接收班级"];
        return NO;
    }
    
    if([self.homeWorkEntity.words length] == 0 && [self.homeWorkEntity.voiceArray count] == 0 && [self.homeWorkEntity.imageArray count] == 0){
        [ProgressHUD showHintText:@"文字、语音或者图片，必须选择一种"];
        return NO;
    }
    if(self.homeWorkEntity.reply_close && [self.homeWorkEntity.reply_close_ctime length] > 0){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *endDate = [dateFormatter dateFromString:self.homeWorkEntity.reply_close_ctime];
        if([[NSDate date] timeIntervalSinceDate:endDate] >= 0){
            [ProgressHUD showHintText:@"截止时间不能早于当前时间"];
            return NO;
        }
    }
    return YES;
}


- (void)setupScrollView{
    [_scrollView addSubview:self.courseView];
    [_scrollView addSubview:self.targetContentView];
    [_scrollView addSubview:self.replySwitchView];
    [_scrollView addSubview:self.numView];
    [_scrollView addSubview:self.commentView];
    [_scrollView addSubview:self.settingView];
    [_scrollView addSubview:self.explainView];
    [_scrollView addSubview:self.voiceView];
    [_scrollView addSubview:self.photoView];
//    [_scrollView addSubview:self.videoView];
    [self.courseView setCourse:self.homeWorkEntity.course_name];
    [self.targetContentView setTargets:self.homeWorkEntity.targets];
    [self.commentView setContent:self.homeWorkEntity.words];
    [self.replySwitchView setReplyOn:self.homeWorkEntity.etype];
    [self.numView setNumOfHomework:self.homeWorkEntity.count];
    
    [self.voiceView setVoiceArray:self.homeWorkEntity.voiceArray];
    [self.photoView setPhotoArray:self.homeWorkEntity.imageArray];
//    [self.videoView setVideoArray:self.homeWorkEntity.videoArray];
    [self adjustPosition];
}

- (void)adjustPosition{
    [self.targetContentView setTop:self.courseView.bottom];
    [self.replySwitchView setTop:self.targetContentView.bottom];
    [self.numView setTop:self.replySwitchView.bottom];
    [self.commentView setTop:self.numView.bottom];
    [self.settingView setTop:self.commentView.bottom];
    [self.explainView setTop:self.settingView.bottom];
    [self.voiceView setTop:self.explainView.bottom];
    [self.photoView setTop:self.voiceView.bottom];
//    [self.videoView setTop:self.photoView.bottom];
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, self.photoView.bottom)];
}

- (HomeworkCourseView *)courseView{
    if(!_courseView){
        __weak typeof(self) wself = self;
        _courseView = [[HomeworkCourseView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, 50)];
        [_courseView setUserInteractionEnabled:!self.homeWorkEntity.forward];
        [_courseView setAddCallback:^{
            CourseSelectVC *courseSelectVC = [[CourseSelectVC alloc] init];
            [courseSelectVC setCourse:wself.homeWorkEntity.course_name];
            [courseSelectVC setCourseSelected:^(NSString *course) {
                [wself setCourse:course];
            }];
            [wself.navigationController pushViewController:courseSelectVC animated:YES];
        }];
    }
    return _courseView;
}

- (HomeworkClassContentView *)targetContentView{
    if(_targetContentView == nil){
        @weakify(self);
        _targetContentView = [[HomeworkClassContentView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, 0)];
        [_targetContentView setAddBlk:^{
            @strongify(self)
            [self onAddTarget];
        }];
        [_targetContentView setDeleteDataCallback:^(id classInfo) {
            @strongify(self)
            [self deleteClassInfo:classInfo];
        }];
        
    }
    return _targetContentView;
}

- (HomeworkReplySwitchView *)replySwitchView{
    if(_replySwitchView == nil){
        @weakify(self)
        _replySwitchView = [[HomeworkReplySwitchView alloc] initWithFrame:CGRectMake(0, _targetContentView.bottom, _scrollView.width, 50)];
        [_replySwitchView setReplyOn:self.homeWorkEntity.etype];
        [_replySwitchView setReplySwitchCallback:^(BOOL on) {
            @strongify(self)
            self.homeWorkEntity.etype = on;
            [self.commentView setMaxWordsNum:[self.homeWorkEntity maxCommentWordsNum]];
            [self.settingView setHomeworkEntity:self.homeWorkEntity];
        }];
    }
    return _replySwitchView;
}

- (HomeworkNumView *)numView{
    if(_numView == nil){
        __weak typeof(self) wself = self;
        _numView = [[HomeworkNumView alloc] initWithFrame:CGRectMake(0, _replySwitchView.bottom, _scrollView.width, 50)];
        [_numView setNumOfHomework:self.homeWorkEntity.count];
        [_numView setNumChangedCallback:^(NSInteger num) {
            [wself.homeWorkEntity setCount:num];
        }];
        [_numView setUserInteractionEnabled:!self.homeWorkEntity.forward];
    }
    return _numView;
}

- (NotificationCommentView *)commentView{
    if(_commentView == nil){
        @weakify(self)
        _commentView = [[NotificationCommentView alloc] initWithFrame:CGRectMake(0, _numView.bottom, _scrollView.width, 135)];
        [_commentView setPlaceHolder:@"输入你要布置的作业内容:"];
        [_commentView setMaxWordsNum:[self.homeWorkEntity maxCommentWordsNum]];
        [_commentView setContent:self.homeWorkEntity.words];
        [_commentView.commentTextView setEditable:!self.homeWorkEntity.forward];
        [_commentView setTextViewWillChangeHeight:^(CGFloat height) {
            @strongify(self)
            [self adjustPosition];
        }];
        [_commentView setTextViewTextChanged:^(NSString *text) {
            @strongify(self)
            self.homeWorkEntity.words = text;
        }];
    }
    return _commentView;
}

- (HomeworkSettingView *)settingView{
    if(_settingView == nil){
        __weak typeof(self) wself = self;
        _settingView = [[HomeworkSettingView alloc] initWithFrame:CGRectMake(0, _commentView.bottom, _scrollView.width, 50)];
        [_settingView setHomeworkEntity:self.homeWorkEntity];
        [_settingView setSettingClick:^{
            HomeworkSuperSettingVC *settingVC = [[HomeworkSuperSettingVC alloc] init];
            [settingVC setHomeworkEntity:wself.homeWorkEntity];
            [settingVC setHomeworkSettingChanged:^{
                [wself.settingView setHomeworkEntity:wself.homeWorkEntity];
            }];
            [wself.navigationController pushViewController:settingVC animated:YES];
        }];
    }
    return _settingView;
}

- (HomeworkExplainView *)explainView{
    if(_explainView == nil){
        __weak typeof(self) wself = self;
        _explainView = [[HomeworkExplainView alloc] initWithFrame:CGRectMake(0, _settingView.bottom, _scrollView.width, 50)];
        [_explainView setHasExplain:self.homeWorkEntity.explainEntity];
        [_explainView setExplainClick:^{
            HomeworkAddExplainVC *addExplainVC = [[HomeworkAddExplainVC alloc] init];
            if(wself.homeWorkEntity.explainEntity){
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:wself.homeWorkEntity.explainEntity];
                HomeworkExplainEntity *explainEntity = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                [addExplainVC setExplainEntity:explainEntity];
            }
            [addExplainVC setAddExplainFinish:^(HomeworkExplainEntity *explainEntity){
                [wself.homeWorkEntity setExplainEntity:explainEntity];
                [wself.explainView setHasExplain:![explainEntity isEmpty]];
            }];
            [wself.navigationController pushViewController:addExplainVC animated:YES];
        }];
    }
    return _explainView;
}

- (NotificationVoiceView *)voiceView{
    if(_voiceView == nil){
        _voiceView = [[NotificationVoiceView alloc] initWithFrame:CGRectMake(0, _commentView.bottom, _scrollView.width, 0)];
        [_voiceView setEditDisable:self.homeWorkEntity.forward];
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
        [_photoView setEditDisable:self.homeWorkEntity.forward];
        [_photoView setDeleteDataCallback:^(id image) {
            @strongify(self)
            [self deleteImage:image];
        }];
    }
    return _photoView;
}

//- (NotificationVideoView *)videoView{
//    if(_videoView == nil){
//        _videoView = [[NotificationVideoView alloc] initWithFrame:CGRectMake(0, _photoView.bottom, _scrollView.width, 0)];
//        @weakify(self)
//        [_videoView setDeleteDataCallback:^(VideoItem *videoItem) {
//            @strongify(self)
//            [self deleteVideo:videoItem];
//        }];
//    }
//    return _videoView;
//}

- (void)onAddTarget{
    [self stopPlayAudio];
    __weak typeof(self) wself = self;
    ClassSelectVC *classSelectVC = [[ClassSelectVC alloc] init];
    [classSelectVC setOriginalClassArray:self.homeWorkEntity.targets];
    [classSelectVC setClassSelectCallBack:^(NSArray *targets) {
        NSMutableArray *targetArray = [NSMutableArray array];
        for (ClassInfo *classInfo in targets) {
            ClassInfo *simpleInfo = [[ClassInfo alloc] init];
            [simpleInfo setClassID:classInfo.classID];
            [simpleInfo setName:classInfo.name];
            [targetArray addObject:classInfo];
        }
        wself.homeWorkEntity.targets = targetArray;
        [wself.targetContentView setTargets:wself.homeWorkEntity.targets];
        [wself adjustPosition];
    }];
    [self.navigationController pushViewController:classSelectVC animated:YES];
}


- (void)deleteClassInfo:(ClassInfo *)classInfo{
    [self.homeWorkEntity removeTarget:classInfo];
    [_targetContentView setTargets:self.homeWorkEntity.targets];
    [self adjustPosition];
}

- (void)deleteAudioItem:(AudioItem *)audioItem{
    [self.homeWorkEntity.voiceArray removeObject:audioItem];
    [_voiceView setVoiceArray:self.homeWorkEntity.voiceArray];
    [self adjustPosition];
}

- (void)deleteImage:(PhotoItem *)photoItem{
    [self.homeWorkEntity.imageArray removeObject:photoItem];
    [_photoView setPhotoArray:self.homeWorkEntity.imageArray];
    [self adjustPosition];
}

//- (void)deleteVideo:(VideoItem *)videoItem{
//    [self.homeWorkEntity.videoArray removeObject:videoItem];
//    [_videoView setVideoArray:self.homeWorkEntity.videoArray];
//    [self adjustPosition];
//}

- (void)setCourse:(NSString *)course{
    [self.homeWorkEntity setCourse_name:course];
    [self.courseView setCourse:course];
}

- (void)addImage:(NSArray *)imageArray{
    NSMutableArray *sendImageArray = self.homeWorkEntity.imageArray;
    NSInteger originalCount = sendImageArray.count;
    for (NSInteger i = 0; i < MIN(kHomeWorkMaxPhotoNum - originalCount, imageArray.count); i++) {
        [sendImageArray addObject:imageArray[i]];
    }
    [self.photoView setPhotoArray:sendImageArray];
    [self adjustPosition];
}

//- (void)addVideo:(NSArray *)videoArray{
//    NSMutableArray *sendVideoArray = self.homeWorkEntity.videoArray;
//    [sendVideoArray addObjectsFromArray:videoArray];
//    [self.videoView setVideoArray:sendVideoArray];
//    [self adjustPosition];
//}

- (void)stopPlayAudio{
    if([MLAmrPlayer shareInstance].isPlaying){
        [[MLAmrPlayer shareInstance] stopPlaying];
    }
}


- (void)publishHomework{
    [self stopPlayAudio];
    if([self checkHomework]){
        YYReachability *reachability = [YYReachability reachability];
        YYReachabilityStatus status = reachability.status;
        if(status == YYReachabilityStatusNone){
            [ProgressHUD showHintText:@"网络异常，存入到草稿"];
            if(self.sendType == HomeworkSendDraft){
                [[HomeworkDraftManager sharedInstance] updateDraft:self.homeWorkEntity];
            }
            else{
                [[HomeworkDraftManager sharedInstance] addDraft:self.homeWorkEntity];//存入草稿
            }
        }
        else{
            [[HomeworkManager sharedInstance] addHomework:self.homeWorkEntity];
            if(self.sendType == HomeworkSendDraft){//如果是草稿，则删除草稿
                [[HomeworkDraftManager sharedInstance] removeDraft:self.homeWorkEntity];
            }
        }
        NSArray *vcArray = [self.navigationController viewControllers];
        for (UIViewController *vc in vcArray) {
            if([vc isKindOfClass:NSClassFromString(@"HomeWorkVC")]){
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
    }

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
    [imagePicker setFilterType:DNImagePickerFilterTypePhotos];
    [imagePicker setImagePickerDelegate:self];
    [imagePicker setMaxImageCount:kHomeWorkMaxPhotoNum - self.homeWorkEntity.imageArray.count];
//    [imagePicker setMaxVideoCount:kHomeWorkMaxVideoNum - self.homeWorkEntity.videoArray.count];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)notificationInputQuickPhoto:(NSArray *)photoArray fullImage:(BOOL)isFullImage{
    [_inputView setActionType:ActionTypeNone];
    NSMutableArray* addImageArray = [NSMutableArray array];
    if(photoArray.count > 0){
        for (XMNAssetModel *asset in photoArray) {
             if(asset.type == XMNAssetTypePhoto){
                UIImage *image;
                if(isFullImage){
                    image = [UIImage imageWithCGImage:[[asset.asset defaultRepresentation] fullResolutionImage] scale:1.f orientation:UIImageOrientationUp];
                }
                else{
                    image = [UIImage imageWithCGImage:[[asset.asset defaultRepresentation] fullScreenImage] scale:1.f orientation:UIImageOrientationUp];
                }
                if(image && self.homeWorkEntity.imageArray.count + addImageArray.count < 9){
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
//    if(addVideoArray.count > 0){
//        [self addVideo:addVideoArray];
//    }
    if(addImageArray.count > 0)
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
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self.navigationController presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

- (void)notificationInputAudio:(NotificationInputView *)inputView audioItem:(AudioItem *)audioItem{
    if(audioItem){
        [self.homeWorkEntity.voiceArray addObject:audioItem];
        [_voiceView setVoiceArray:self.homeWorkEntity.voiceArray];
        [self adjustPosition];
        [_inputView setActionType:ActionTypeNone];
    }
}

- (void)notificationInputSend{
    [self publishHomework];
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
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //        MJPhoto *photo = _photos[_currentPhotoIndex];
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        });
        if(self.homeWorkEntity.imageArray.count >= 9){
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
//    else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
//        NSURL *url = info[UIImagePickerControllerMediaURL];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            UISaveVideoAtPathToSavedPhotosAlbum(url.path, nil, nil, nil);
//        });
//        if(self.homeWorkEntity.videoArray.count > 0){
//            [picker dismissViewControllerAnimated:YES completion:^{
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"一次只能发送1个视频,拍摄内容已保存" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alertView show];
//            }];
//        }
//        else{
//            NSURL *url = info[UIImagePickerControllerMediaURL];
//            NSString *extasion = url.pathExtension;
//            NSString *finalPath = [[NHFileManager getTmpVideoPath] stringByAppendingPathExtension:extasion];
//            [FCFileManager moveItemAtPath:url.path toPath:finalPath overwrite:YES];
//            url = [NSURL fileURLWithPath:finalPath];
//            NSData *data = [NSData dataWithContentsOfURL:url];
//            if(data.length > 1024 * 1024 * 10){
//                LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提示" message:@"视频文件过大" style:LGAlertViewStyleAlert buttonTitles:@[@"确定"] cancelButtonTitle:nil destructiveButtonTitle:nil];
//                [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
//                [alertView showAnimated:YES completionHandler:nil];
//                return;
//            }
//            NSString *sizeStr = [Utility sizeStrForSize:data.length];
//            NSInteger duration = [self getVideoDuration:url];
//            LGAlertView*    alertView = [[LGAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"视频压缩后文件大小为%@",sizeStr] style:LGAlertViewStyleAlert buttonTitles:@[@"确定"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
//            [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
//            [alertView setButtonsFont:[UIFont boldSystemFontOfSize:18]];
//            [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
//            [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
//            [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
//                @strongify(self);
//                VideoItem *videoItem = [[VideoItem alloc] init];
//                [videoItem setVideoUrl:finalPath];
//                [videoItem setCoverImage:[UIImage coverImageForVideo:url]];
//                [videoItem setVideoTime:duration];
//                [self addVideo:@[videoItem]];
//                [picker dismissViewControllerAnimated:YES completion:nil];
//            }];
//            [alertView setCancelHandler:^(LGAlertView *alertView) {
//                [picker dismissViewControllerAnimated:YES completion:nil];
//            }];
//            [alertView showAnimated:YES completionHandler:nil];
//            
//        }
//    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DNImagePickerControllerDelegate
- (void)dnImagePickerController:(DNImagePickerController *)imagePicker sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage{
    if(imageAssets.count > 0){
        NSMutableArray *addImageArray = [NSMutableArray array];
//        NSMutableArray *addVideoArray = [NSMutableArray array];
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
//            else if([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]){
//                if(self.homeWorkEntity.videoArray.count > 0){
//                    continue;
//                }
//                NSString *filePath = [[asset.defaultRepresentation url] absoluteString];
//                NSString *tmpPath = [NHFileManager tmpVideoPathForPath:filePath];
//                NSInteger duration = [[asset valueForProperty:ALAssetPropertyDuration] integerValue];
//                if([[NSFileManager defaultManager] fileExistsAtPath:tmpPath]){
//                }
//                else{
//                    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在压缩" toView:self.view];
//                    AVAsset *avAsset = [AVAsset assetWithURL:[NSURL URLWithString:filePath]];
//                    AVAssetExportSession * exportSession = [AVAssetExportSession exportSessionWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
//                    exportSession.outputFileType = AVFileTypeMPEG4;
//                    exportSession.shouldOptimizeForNetworkUse = YES;
//                    exportSession.outputURL = [NSURL fileURLWithPath:tmpPath];
//                    [exportSession exportAsynchronouslyWithCompletionHandler:^{
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            if(AVAssetExportSessionStatusCompleted == exportSession.status){
//                                [hud hide:YES];
//                            }
//                            else{
//                                [ProgressHUD showHintText:@"压缩失败"];
//                            }
//                        });
//                        
//                    }];
//                }
//                VideoItem *videoItem = [[VideoItem alloc] init];
//                [videoItem setVideoUrl:tmpPath];
//                [videoItem setCoverImage:[UIImage imageWithCGImage:[asset.defaultRepresentation fullScreenImage] scale:1.f orientation:UIImageOrientationUp]];
//                [videoItem setVideoTime:duration];
//                [addVideoArray addObject:videoItem];
//            }
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
//        if(addVideoArray.count > 0){
//            [self addVideo:addVideoArray];
//        }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
