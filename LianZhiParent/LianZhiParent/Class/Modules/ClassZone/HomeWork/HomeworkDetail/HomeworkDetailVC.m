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
@property (nonatomic, strong)HomeworkStudentAnswer* reply;          //作业回复
@property (nonatomic, strong)HomeworkTeacherMark*   teacherMark;    //作业批阅
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
    if((_homeworkItem.etype && _homeworkItem.s_answer) || !_homeworkItem.etype){//显示删除
        [self setRightbarButtonHighlighted:NO];
    }
    [self.homeworkDetailView setHomeworkItem:_homeworkItem];
    [self.homeworkFinishView setHomeworkItem:_homeworkItem];
}

- (void)onSegValueChanged{
    NSInteger selectedIndex = self.segCtrl.selectedSegmentIndex;
    [self.homeworkDetailView setHidden:selectedIndex != 0];
    [self.homeworkFinishView setHidden:selectedIndex != 1];
}

- (void)setHomeworkItem:(HomeworkItem *)homeworkItem{
    _homeworkItem = homeworkItem;
    if(_homeworkItem.etype){
        [self.navigationItem setTitleView:[self segCtrl]];
        [self.view addSubview:[self homeworkDetailView]];
        [self.view addSubview:[self homeworkFinishView]];
        [[self segCtrl] setSelectedSegmentIndex:0];
        [self onSegValueChanged];
    }
    else{
        [self.navigationItem setTitle:@"作业详情"];
        [self.view addSubview:[self homeworkDetailView]];
    }
    [self homeworkItemChanged];
}


- (void)requestHomeworkDetail{
    __weak typeof(self) wself = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.eid forKey:@"eid"];
    
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/detail" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        HomeworkItem *homeworkItem = [HomeworkItem nh_modelWithJson:responseObject.data];
        [wself setHomeworkItem:homeworkItem];
        if(wself.homeworkReadCallback){
            wself.homeworkReadCallback(wself.homeworkItem.eid);
        }
    } fail:^(NSString *errMsg) {
        
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
            [wself.navigationController popViewControllerAnimated:YES];
        } fail:^(NSString *errMsg) {
            
        }];
    }];
    [alertView showAnimated:YES completionHandler:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
