//
//  HomeworkDetailVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkDetailVC.h"
#import "HomeworkDetailView.h"
#import "HomeworkTargetListView.h"
#import "NotificationDetailActionView.h"
#import "ContactsLoadingView.h"
#import "HomeworkAddExplainVC.h"
#import "PublishHomeWorkVC.h"
#import "MessageSegView.h"
NSString *const kHomeworkReadNumChangedNotification = @"HomeworkReadNumChangedNotification";

@interface HomeworkDetailVC ()
@property (nonatomic, strong)HomeworkItem*              homeworkItem;
@property (nonatomic, strong)MessageSegView*            segmentCtrl;
@property (nonatomic, strong)UIButton*                  moreButton;
@property (nonatomic, strong)HomeworkDetailView*        detailView;
@property (nonatomic, strong)HomeworkTargetListView*    targetListView;
@property (nonatomic, strong)ContactsLoadingView *      contactsLoadingView;
@end

@implementation HomeworkDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightbarButtonHighlighted:NO];
    [self.view addSubview:[self detailView]];
    [self.view addSubview:[self targetListView]];
    
    NSData *homeworkData = [NSData dataWithContentsOfFile:[self cacheFilePath]];
    if(homeworkData){
        self.homeworkItem = [NSKeyedUnarchiver unarchiveObjectWithData:homeworkData];
    }
    
    [self loadData];
    __weak typeof(self) wself = self;
    [RACObserve(self.targetListView, hasNew) subscribeNext:^(id x) {
        [wself.segmentCtrl setShowBadge:[wself.targetListView hasNew] ? @"" : nil atIndex:1];
    }];
}

- (void)back{
    [super back];
    if(self.readCallback){
        self.readCallback();
    }
}

- (void)setRightbarButtonHighlighted:(BOOL)highlighted{
    if(_moreButton == nil){
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setSize:CGSizeMake(30, 40)];
        [_moreButton addTarget:self action:@selector(onMoreClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    [_moreButton setImage:[UIImage imageNamed:highlighted ? @"noti_detail_more_highlighted" : @"noti_detail_more"] forState:UIControlStateNormal];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:_moreButton];
    self.navigationItem.rightBarButtonItem = moreItem;
}

- (ContactsLoadingView *)contactsLoadingView{
    if(!_contactsLoadingView){
        _contactsLoadingView = [[ContactsLoadingView alloc] initWithFrame:CGRectZero];
        [_contactsLoadingView setCenter:CGPointMake(self.view.width / 2, (kScreenHeight - 64) / 2)];
        [self.view addSubview:_contactsLoadingView];
    }
    return _contactsLoadingView;
}

- (void)loadData{
    if(self.homeworkItem == nil){
        [self.contactsLoadingView show];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    @weakify(self)
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/detail" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"eid" : self.hid} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [hud hide:NO];
        @strongify(self)
        [self.contactsLoadingView dismiss];
        HomeworkItem *homeworkItem = [HomeworkItem nh_modelWithJson:responseObject.data];
        self.homeworkItem = homeworkItem;
        [self saveHomework];
    } fail:^(NSString *errMsg) {
        [hud hide:NO];
        @strongify(self)
        [self.contactsLoadingView dismiss];
    }];
}

- (void)setHomeworkItem:(HomeworkItem *)homeworkItem{
    HomeworkItem *originalitem = _homeworkItem;
    _homeworkItem = homeworkItem;
    [self.navigationItem setTitleView:[self segmentCtrl]];
    if(!originalitem){
         [self.segmentCtrl setSelectedIndex:self.hasNew ? 1 : 0];
    }
    [self.detailView setHomeworkItem:self.homeworkItem];
    [_targetListView setHomeworkItem:self.homeworkItem];
    
    if(homeworkItem){
        [[NSNotificationCenter defaultCenter] postNotificationName:kHomeworkReadNumChangedNotification object:nil userInfo:@{@"notification" : homeworkItem}];
    }
}

- (void)deleteHomeworkItem{
    __weak typeof(self) wself = self;
    LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提醒" message:@"是否删除该条记录?" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除"];
    [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
    [alertView setDestructiveButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setDestructiveHandler:^(LGAlertView *alertView) {
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/delete" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"eid" : wself.hid} observer:wself completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [wself.navigationController popViewControllerAnimated:YES];
            if(wself.deleteCallback){
                wself.deleteCallback(wself.hid);
            }
        } fail:^(NSString *errMsg) {
            
        }];
    }];
    [alertView showAnimated:YES completionHandler:nil];


}

- (MessageSegView *)segmentCtrl{
    if(_segmentCtrl == nil){
        __weak typeof(self) wself = self;
        NSString* rightTitle = self.homeworkItem.etype ? @"批阅作业" : @"阅读人数";
        _segmentCtrl = [[MessageSegView alloc] initWithItems:@[@"作业详情", rightTitle] valueChanged:^(NSInteger selectedIndex) {
            [wself onSegmentValueChanged:selectedIndex];
        }];
        [_segmentCtrl setWidth:160];
    }
    return _segmentCtrl;
}

- (HomeworkDetailView *)detailView{
    if(_detailView == nil){
        _detailView = [[HomeworkDetailView alloc] initWithFrame:self.view.bounds];
        [_detailView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    }
    return _detailView;
}

- (HomeworkTargetListView *)targetListView{
    if(_targetListView == nil){
        _targetListView = [[HomeworkTargetListView alloc] initWithFrame:self.view.bounds];
        [_targetListView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    }
    return _targetListView;
}

- (void)updateHomeworkExplain:(HomeworkExplainEntity *)explainEntity{
    __weak typeof(self) wself = self;
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:[UIApplication sharedApplication].keyWindow];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.homeworkItem.eid forKey:@"eid"];
    [params setValue:explainEntity.words forKey:@"answer_words"];
    if([explainEntity.voiceArray count] > 0){
        AudioItem *voice = explainEntity.voiceArray[0];
        if(!voice.isLocal){
            [params setValue:voice.audioID forKey:@"answer_voice_id"];
        }
        [params setValue:kStringFromValue(voice.timeSpan) forKey:@"answer_voice_time"];
    }
    
    if([explainEntity.imageArray count] > 0)
    {
        NSMutableString *picSeq = [[NSMutableString alloc] init];
        for (NSInteger i = 0; i < explainEntity.imageArray.count; i++)
        {
            PhotoItem *photoItem = explainEntity.imageArray[i];
            if(photoItem.photoID.length > 0){
                if(picSeq.length == 0){
                    [picSeq appendString:photoItem.photoID];
                }
                else{
                    [picSeq appendString:[NSString stringWithFormat:@",%@",photoItem.photoID]];
                }
            }
            else{
                if(picSeq.length == 0){
                    [picSeq appendFormat:@"answer_picture_%ld",(long)i];
                }
                else{
                    [picSeq appendFormat:@",answer_picture_%ld",(long)i];
                }
            }
        }
        
        [params setValue:picSeq forKey:@"answer_pic_seqs"];
    }

    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/answer" withParams:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSInteger i = 0; i < explainEntity.imageArray.count; i++)
        {
            PhotoItem *photoItem = explainEntity.imageArray[i];
            NSString *filename = [NSString stringWithFormat:@"answer_picture_%ld",(long)i];
            if(photoItem.photoID.length > 0){
                
            }
            else{
                NSData *data = [NSData dataWithContentsOfFile:photoItem.big];
                if(data.length > 0){
                    [formData appendPartWithFileData:data name:filename fileName:filename mimeType:@"image/jpeg"];
                }
            }
            
        }
        
        if([explainEntity.voiceArray count] > 0){
            AudioItem *audioItem = explainEntity.voiceArray[0];
            if(audioItem.isLocal){
                NSData *voiceData = [NSData dataWithContentsOfFile:audioItem.audioUrl];
                [formData appendPartWithFileData:voiceData name:@"answer_voice" fileName:@"answer_voice" mimeType:@"audio/AMR"];
            }
        }

    } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        TNDataWrapper *answerWrapper = [responseObject getDataWrapperForKey:@"answer"];
        HomeworkItemAnswer *answer = [HomeworkItemAnswer nh_modelWithJson:answerWrapper.data];
        [wself.homeworkItem setAnswer:answer];
        [wself.detailView setHomeworkItem:wself.homeworkItem];
        [hud hide:NO];
        [ProgressHUD showSuccess:@"解析更新成功"];
    } fail:^(NSString *errMsg) {
        [hud hide:NO];
        [ProgressHUD showError:errMsg];
    }];
}

- (void)onMoreClicked{
    if(!self.homeworkItem){
        return;
    }
    if([[MLAmrPlayer shareInstance] isPlaying]){
        [[MLAmrPlayer shareInstance] stopPlaying];
    }
    __weak typeof(self) wself = self;
    NotificationActionItem* forwardItem = [NotificationActionItem actionItemWithTitle:@"转发" action:^{
        HomeWorkEntity *entity = [HomeWorkEntity sendEntityWithHomeworkItem:wself.homeworkItem];
        [entity setForward:YES];
        PublishHomeWorkVC* publishHomeworkVC = [[PublishHomeWorkVC alloc] initWithHomeWorkEntity:entity];

        [CurrentROOTNavigationVC pushViewController:publishHomeworkVC animated:YES];
    } destroyItem:NO];
    NotificationActionItem* editItem = [NotificationActionItem actionItemWithTitle:@"编辑作业解析" action:^{
        HomeworkAddExplainVC *explainVC = [[HomeworkAddExplainVC alloc] init];
        explainVC.explainEntity = [HomeworkExplainEntity explainEntityFromAnswer:wself.homeworkItem.answer];
        [explainVC setAddExplainFinish:^(HomeworkExplainEntity *explainEntity) {
            [wself updateHomeworkExplain:explainEntity];
        }];
        [wself.navigationController pushViewController:explainVC animated:YES];
    } destroyItem:NO];
    NotificationActionItem* deleteItem = [NotificationActionItem actionItemWithTitle:@"删除" action:^{
        [wself deleteHomeworkItem];
    } destroyItem:YES];
    [NotificationDetailActionView showWithActions:@[forwardItem, editItem, deleteItem] completion:^{
    
    }];
}

- (void)onSegmentValueChanged:(NSInteger)selectedIndex{
    [_detailView setHidden:selectedIndex != 0];
    [_targetListView setHidden:selectedIndex != 1];
}

- (void)saveHomework{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.homeworkItem];
        [data writeToFile:[self cacheFilePath] atomically:YES];
    });
}

- (BOOL)supportCache{
    return YES;
}

- (NSString *)cacheFileName{
    return [NSString stringWithFormat:@"MySendHomework_%@",self.hid];
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
