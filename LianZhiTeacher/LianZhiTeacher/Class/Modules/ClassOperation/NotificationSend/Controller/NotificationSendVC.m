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
@interface NotificationSendVC ()<NotificationInputDelegate,
UIGestureRecognizerDelegate,
UIScrollViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>
@property (nonatomic, strong)NotificationSendEntity *sendEntity;
@end

@implementation NotificationSendVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.sendEntity = [[NotificationSendEntity alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布通知";
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

- (void)onPreview{
    
}

- (void)onSwipe{
    if(_inputView.actionType != ActionTypeNone){
        [_inputView setActionType:ActionTypeNone];
    }
}

- (void)setupScrollView{
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
    [_scrollView addSubview:_targetContentView];
    
    _smsChoiceView = [[NotificationSendChoiceView alloc] initWithFrame:CGRectMake(0, _targetContentView.bottom, _scrollView.width, 54) title:@"连枝代发短信"];
    [_scrollView addSubview:_smsChoiceView];
    
    _timerSendView = [[NotificationSendChoiceView alloc] initWithFrame:CGRectMake(0, _smsChoiceView.bottom, _scrollView.width, 54) title:@"定时发送"];
    [_timerSendView setInfoAction:^{
        [NotificationSelectTimeView showWithCompletion:^(NSDate *date) {
            @strongify(self);
            [self updateDate:date];
        }];
    }];
    [_scrollView addSubview:_timerSendView];

    _commentView = [[NotificationCommentView alloc] initWithFrame:CGRectMake(0, _timerSendView.bottom, _scrollView.width, 135)];
    [_commentView setTextViewWillChangeHeight:^(CGFloat height) {
        
    }];
    [_scrollView addSubview:_commentView];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, _commentView.bottom)];
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
    
}
- (void)notificationInputVideo:(NotificationInputView *)inputView
{
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
//    [imagePicker setMediaTypes:[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]];
//    [imagePicker setVideoQuality:UIImagePickerControllerQualityTypeMedium];
//    [imagePicker setDelegate:self];
//    [self presentViewController:imagePicker animated:YES completion:nil];
    [VideoRecordView showWithCompletion:^(NSURL *videoPath) {
        
    }];
}

#pragma mark - UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSURL *mediaURL = info[UIImagePickerControllerMediaURL];
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString *)kUTTypeImage]){
//        NSLog(@"%@",mediaURL);
    }
    else{
        
    }
    NSLog(@"%@",mediaURL);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
