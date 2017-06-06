//
//  HomeworkAddExplainVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkAddExplainVC.h"
#import "NotificationCommentView.h"
#import "NotificationVoiceView.h"
#import "NotificationVideoView.h"
#import "NotificationPhotoView.h"
#import "NotificationInputView.h"
#import "DNImagePickerController.h"
#import "HomeworkDefine.h"
@interface HomeworkAddExplainVC ()<DNImagePickerControllerDelegate,
UIGestureRecognizerDelegate,
NotificationInputDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIScrollViewDelegate>{
    UITouchScrollView*              _scrollView;
    NotificationInputView*          _inputView;
}
@property (nonatomic, strong)HomeworkExplainEntity*     compareEntity;
@property (nonatomic, strong)NotificationCommentView*   commentView;
@property (nonatomic, strong)NotificationVoiceView*     voiceView;
@property (nonatomic, strong)NotificationPhotoView*     photoView;
@end

@implementation HomeworkAddExplainVC

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
    if([self.explainEntity isSame:self.compareEntity]){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        //是否保存到草稿
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提醒" message:@"是否放弃修改作业解析?" style:LGAlertViewStyleAlert buttonTitles:@[@"放弃"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
        [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
        [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
        [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
        [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertView setCancelHandler:^(LGAlertView *alertView) {
        }];
        [alertView showAnimated:YES completionHandler:nil];

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加作业解析";
    if(!self.explainEntity){
        self.explainEntity = [[HomeworkExplainEntity alloc] init];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.explainEntity];
        self.compareEntity = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    });
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    
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
    [_inputView setSendHidden:YES];
    [_inputView setPhotoNum:^NSInteger{
        @strongify(self)
        return [self.explainEntity.imageArray count];
    }];
    [_inputView setVideoNum:^NSInteger{
        return 0;
    }];
    [_inputView setOnlyPhoto:YES];
    [_inputView setCanRecord:^BOOL{
        @strongify(self)
        return [self.explainEntity.voiceArray count] < 1;
    }];
    [_inputView setDelegate:self];
    [self.view addSubview:_inputView];
}

- (void)setupScrollView{
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, 40)];
    [hintLabel setTextAlignment:NSTextAlignmentCenter];
    [hintLabel setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    [hintLabel setTextColor:[UIColor colorWithHexString:@"525252"]];
    [hintLabel setFont:[UIFont systemFontOfSize:13]];
    [hintLabel setText:@"对于需要回复的作业，家长提交后才能看到作业解析。"];
    [hintLabel sizeToFit];
    [hintLabel setSize:CGSizeMake(_scrollView.width, hintLabel.height + 10)];
    [_scrollView addSubview:hintLabel];
    [_scrollView addSubview:self.commentView];
    [self.commentView setTop:hintLabel.height];
    [_scrollView addSubview:self.voiceView];
    [_scrollView addSubview:self.photoView];
    [self.commentView setContent:self.explainEntity.words];
    
    [self.voiceView setVoiceArray:self.explainEntity.voiceArray];
    [self.photoView setPhotoArray:self.explainEntity.imageArray];
    [self adjustPosition];
}

- (void)adjustPosition{
    [self.voiceView setTop:self.commentView.bottom];
    [self.photoView setTop:self.voiceView.bottom];
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, self.photoView.bottom)];
}


- (void)onSwipe{
    if(_inputView.actionType != ActionTypeNone){
        [_inputView setActionType:ActionTypeNone];
    }
}

- (void)finish{
    [self.navigationController popViewControllerAnimated:YES];
    if(self.addExplainFinish){
        self.addExplainFinish(self.explainEntity);
    }
}


- (void)addImage:(NSArray *)imageArray{
    NSMutableArray *sendImageArray = self.explainEntity.imageArray;
    NSInteger originalCount = sendImageArray.count;
    for (NSInteger i = 0; i < MIN(kHomeWorkMaxPhotoNum - originalCount, imageArray.count); i++) {
        [sendImageArray addObject:imageArray[i]];
    }
    [self.photoView setPhotoArray:sendImageArray];
    [self adjustPosition];
}

- (void)deleteAudioItem:(AudioItem *)audioItem{
    [self.explainEntity.voiceArray removeObject:audioItem];
    [_voiceView setVoiceArray:self.explainEntity.voiceArray];
    [self adjustPosition];
}

- (void)deleteImage:(PhotoItem *)photoItem{
    [self.explainEntity.imageArray removeObject:photoItem];
    [_photoView setPhotoArray:self.explainEntity.imageArray];
    [self adjustPosition];
}

- (void)stopPlayAudio{
    if([MLAmrPlayer shareInstance].isPlaying){
        [[MLAmrPlayer shareInstance] stopPlaying];
    }
}

- (NotificationCommentView *)commentView{
    if(_commentView == nil){
        @weakify(self)
        _commentView = [[NotificationCommentView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, 135)];
        [_commentView setPlaceHolder:@"请输入解析内容:"];
        [_commentView setMaxWordsNum:500];
        [_commentView setContent:self.explainEntity.words];
        [_commentView setTextViewWillChangeHeight:^(CGFloat height) {
            @strongify(self)
            [self adjustPosition];
        }];
        [_commentView setTextViewTextChanged:^(NSString *text) {
            @strongify(self)
            self.explainEntity.words = text;
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
    [imagePicker setFilterType:DNImagePickerFilterTypePhotos];
    [imagePicker setMaxImageCount:kHomeWorkMaxPhotoNum - self.explainEntity.imageArray.count];
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
                if(image && self.explainEntity.imageArray.count + addImageArray.count < 9){
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
        [self.explainEntity.voiceArray addObject:audioItem];
        [_voiceView setVoiceArray:self.explainEntity.voiceArray];
        [self adjustPosition];
        [_inputView setActionType:ActionTypeNone];
    }
}

- (void)notificationInputSend{
    
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
        if(self.explainEntity.imageArray.count >= 9){
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
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DNImagePickerControllerDelegate
- (void)dnImagePickerController:(DNImagePickerController *)imagePicker sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage{
    if(imageAssets.count > 0){
        NSMutableArray *addImageArray = [NSMutableArray array];
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
        [_inputView setActionType:ActionTypeNone];
    }
}

- (void)dnImagePickerControllerDidCancel:(DNImagePickerController *)imagePicker{
    
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
