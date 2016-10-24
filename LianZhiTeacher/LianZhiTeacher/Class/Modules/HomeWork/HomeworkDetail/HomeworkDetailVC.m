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
NSString *const kHomeworkReadNumChangedNotification = @"HomeworkReadNumChangedNotification";

@interface HomeworkDetailVC ()
@property (nonatomic, strong)HomeworkItem*              homeworkItem;
@property (nonatomic, strong)UISegmentedControl*        segmentCtrl;
@property (nonatomic, strong)UIButton*                  moreButton;
@property (nonatomic, strong)HomeworkDetailView*        detailView;
@property (nonatomic, strong)HomeworkTargetListView*    targetListView;
@property (nonatomic, strong)ContactsLoadingView *      contactsLoadingView;
@end

@implementation HomeworkDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitleView:[self segmentCtrl]];
    [self setRightbarButtonHighlighted:NO];
    [self.view addSubview:[self detailView]];
    [self.view addSubview:[self targetListView]];
    [self onSegmentValueChanged];
    
    NSData *homeworkData = [NSData dataWithContentsOfFile:[self cacheFilePath]];
    if(homeworkData){
        self.homeworkItem = [NSKeyedUnarchiver unarchiveObjectWithData:homeworkData];
    }
    
    [self loadData];
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
    @weakify(self)
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/detail" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"eid" : self.hid} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        @strongify(self)
        [self.contactsLoadingView dismiss];
        HomeworkItem *homeworkItem = [HomeworkItem nh_modelWithJson:responseObject.data];
        self.homeworkItem = homeworkItem;
        [self saveHomework];
    } fail:^(NSString *errMsg) {
        @strongify(self)
        [self.contactsLoadingView dismiss];
    }];
}

- (void)setHomeworkItem:(HomeworkItem *)homeworkItem{
    _homeworkItem = homeworkItem;
    [self.detailView setHomeworkItem:self.homeworkItem];
    [_targetListView setHomeworkItem:self.homeworkItem];
    
    if(homeworkItem){
        [[NSNotificationCenter defaultCenter] postNotificationName:kHomeworkReadNumChangedNotification object:nil userInfo:@{@"notification" : homeworkItem}];
    }
}

- (void)deleteHomeworkItem{
    @weakify(self)
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/delete" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"eid" : self.hid} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
        if(self.deleteCallback){
            self.deleteCallback(self.hid);
        }
    } fail:^(NSString *errMsg) {
        
    }];
}

- (UISegmentedControl *)segmentCtrl{
    if(_segmentCtrl == nil){
        _segmentCtrl = [[UISegmentedControl alloc] initWithItems:@[@"作业详情", @"阅读人数"]];
        [_segmentCtrl setSelectedSegmentIndex:0];
        [_segmentCtrl addTarget:self action:@selector(onSegmentValueChanged) forControlEvents:UIControlEventValueChanged];
        [_segmentCtrl setWidth:140];
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

- (void)onMoreClicked{
    __weak typeof(self) wself = self;
    NotificationActionItem* forwardItem = [NotificationActionItem actionItemWithTitle:@"转发" action:^{
        
    } destroyItem:NO];
    NotificationActionItem* editItem = [NotificationActionItem actionItemWithTitle:@"编辑作业解析" action:^{
        HomeworkAddExplainVC *explainVC = [[HomeworkAddExplainVC alloc] init];
        explainVC.explainEntity = [HomeworkExplainEntity explainEntityFromAnswer:wself.homeworkItem.answer];
        [explainVC setAddExplainFinish:^(HomeworkExplainEntity *explainEntity) {
            
        }];
        [wself.navigationController pushViewController:explainVC animated:YES];
    } destroyItem:NO];
    NotificationActionItem* deleteItem = [NotificationActionItem actionItemWithTitle:@"删除" action:^{
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提醒" message:@"是否删除这条作业?" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除"];
        [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
        [alertView setDestructiveButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"eeeeee"]];
        [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"eeeeee"]];
        [alertView setDestructiveHandler:^(LGAlertView *alertView) {
            [wself deleteHomeworkItem];
        }];
        [alertView showAnimated:YES completionHandler:nil];
    } destroyItem:YES];
    [NotificationDetailActionView showWithActions:@[forwardItem, editItem, deleteItem] completion:^{
    
    }];
}

- (void)onSegmentValueChanged{
    NSInteger selectedIndex = self.segmentCtrl.selectedSegmentIndex;
    [_detailView setHidden:selectedIndex != 0];
    [_targetListView setHidden:selectedIndex != 1];
    if(selectedIndex == 0){
        
    }
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
