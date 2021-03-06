//
//  HomeworkDetailVC.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/13.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkDetailVC.h"
#import "HomeworkStudentAnswer.h"
#import "HomeworkTeacherMark.h"
#import "NotificationDetailActionView.h"
@interface HomeworkDetailVC ()
@property (nonatomic, strong)HomeworkItem*  homeworkItem;
@property (nonatomic, strong)UISegmentedControl*    segCtrl;
@property (nonatomic, strong)HomeworkDetailView*    homeworkDetailView;
@property (nonatomic, strong)HomeworkFinishView*    homeworkFinishView;
//@property (nonatomic, strong)HomeworkStudentAnswer* reply;          //作业回复
//@property (nonatomic, strong)HomeworkTeacherMark*   teacherMark;    //作业批阅
@property (nonatomic, strong)UIButton*              moreButton;
@end

@implementation HomeworkDetailVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init{
    self = [super init];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeworkItemChanged) name:kHomeworkItemChangedNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightbarButtonHighlighted:NO];
    [self loadCache];
    [self requestHomeworkDetail];
}

- (UISegmentedControl *)segCtrl{
    if(_segCtrl == nil){
        _segCtrl = [[UISegmentedControl alloc] initWithItems:@[@"作业详情", @"完成作业"]];
        [_segCtrl addTarget:self action:@selector(onSegValueChanged) forControlEvents:UIControlEventValueChanged];
        [_segCtrl setWidth:140];
    }
    return _segCtrl;
}

- (HomeworkDetailView *)homeworkDetailView{
    if(_homeworkDetailView == nil){
        _homeworkDetailView = [[HomeworkDetailView alloc] initWithFrame:self.view.bounds];
        [_homeworkDetailView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    }
    return _homeworkDetailView;
}

- (HomeworkFinishView *)homeworkFinishView{
    if(_homeworkFinishView == nil){
        _homeworkFinishView = [[HomeworkFinishView alloc] initWithFrame:self.view.bounds];
        [_homeworkFinishView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    }
    return _homeworkFinishView;
}

- (void)homeworkItemChanged{
    [self.homeworkDetailView setHomeworkItem:_homeworkItem];
    [self.homeworkFinishView setHomeworkItem:_homeworkItem];
    if(self.homeworkItem.etype){
        [self.segCtrl setTitle:_homeworkItem.s_answer ? @"查看作业" : @"提交作业" forSegmentAtIndex:1];
    }
    if(self.homeworkStatusCallback){
        self.homeworkStatusCallback(_homeworkItem.status);
    }
}

- (void)onSegValueChanged{
    [self saveHomeworkDetail];
    NSInteger selectedIndex = self.segCtrl.selectedSegmentIndex;
    [self.homeworkDetailView setHidden:selectedIndex != 0];
    [self.homeworkFinishView setHidden:selectedIndex != 1];
}

- (void)setHomeworkItem:(HomeworkItem *)homeworkItem{
    _homeworkItem = homeworkItem;
    if(_homeworkItem.etype){
        [self.navigationItem setTitleView:[self segCtrl]];
        [self.segCtrl setTitle:_homeworkItem.s_answer ? @"查看作业" : @"提交作业" forSegmentAtIndex:1];
        [self.view addSubview:[self homeworkDetailView]];
        [self.view addSubview:[self homeworkFinishView]];
        if(_homeworkItem.status == HomeworkStatusMarked){
            [[self segCtrl] setSelectedSegmentIndex:1];
        }
        else{
            [[self segCtrl] setSelectedSegmentIndex:0];
        }
        [self onSegValueChanged];
    }
    else{
        [self.navigationItem setTitle:@"作业详情"];
        [self.view addSubview:[self homeworkDetailView]];
    }
    [self homeworkItemChanged];
}


- (void)requestHomeworkDetail{
    MBProgressHUD * hud = [MBProgressHUD showMessag:nil toView:self.view];
    __weak typeof(self) wself = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.eid forKey:@"eid"];
    
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/detail" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [hud hide:NO];
        HomeworkItem *homeworkItem = [HomeworkItem nh_modelWithJson:responseObject.data];
        [wself setHomeworkItem:homeworkItem];
        [wself saveHomeworkDetail];
        if(wself.homeworkStatusCallback){
            wself.homeworkStatusCallback(_homeworkItem.status);
        }
        if(homeworkItem.answer_changed){
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提醒" message:@"教师编辑了作业解析，请查看" style:LGAlertViewStyleAlert buttonTitles:@[@"确定"] cancelButtonTitle:nil destructiveButtonTitle:nil];
            [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
            [alertView showAnimated:YES completionHandler:nil];
        }
    } fail:^(NSString *errMsg) {
        [hud hide:NO];
    }];
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

- (void)onMoreClicked{
    [self setRightbarButtonHighlighted:YES];
    if([[MLAmrPlayer shareInstance] isPlaying]){
        [[MLAmrPlayer shareInstance] stopPlaying];
    }
    @weakify(self)
    //    NotificationActionItem *shareItem = [NotificationActionItem actionItemWithTitle:@"分享" action:^{
    //        [ShareActionView shareWithTitle:@"分享" content:@"" image:[UIImage imageNamed:@"ClassZone"] imageUrl:@"" url:@""];
    //    } destroyItem:NO];
    NotificationActionItem *deleteItem = [NotificationActionItem actionItemWithTitle:@"删除" action:^{
        @strongify(self)
        [self deleteHomework];
    } destroyItem:YES];
    [NotificationDetailActionView showWithActions:@[ deleteItem] completion:^{
        @strongify(self);
        [self setRightbarButtonHighlighted:NO];
    }];
    
}

- (void)deleteHomework{
    __weak typeof(self) wself = self;
    LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提醒" message:@"是否删除该作业?" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除"];
    [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
    [alertView setDestructiveButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setDestructiveHandler:^(LGAlertView *alertView) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:wself.homeworkItem.eid forKey:@"eid"];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/delete" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            if(wself.deleteCallback){
                wself.deleteCallback(wself.homeworkItem.eid);
            }
            [wself cacheFilePath];
            [wself.navigationController popViewControllerAnimated:YES];
        } fail:^(NSString *errMsg) {
            
        }];
    }];
    [alertView showAnimated:YES completionHandler:nil];

}

- (void)saveHomeworkDetail{
    if(self.homeworkItem){
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.homeworkItem];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL success = [data writeToFile:[self cacheFilePath] atomically:YES];
            if(success)
                DLOG(@"save success");
        });
    }
}

- (void)loadCache{
    NSData *data = [NSData dataWithContentsOfFile:[self cacheFilePath]];
    if(data.length > 0){
        self.homeworkItem = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

- (void)removeCache{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSFileManager defaultManager] removeItemAtPath:[self cacheFilePath] error:nil];
    });
}

- (BOOL)supportCache{
    return YES;
}

- (NSString *)cacheFileName{
    return [NSString stringWithFormat:@"%@_%@",[self class],self.eid];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
