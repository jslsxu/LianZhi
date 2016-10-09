//
//  HomeWorkVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/9/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeWorkVC.h"
#import "HomeWorkRecordListVC.h"
#import "HomeWorkDraftVC.h"
#import "NotificationDetailActionView.h"
#import "HomeworkSettingVC.h"
@interface HomeWorkVC ()
@property (nonatomic, strong)UISegmentedControl*    segmentCtrl;
@property (nonatomic, strong)UIButton*              moreButton;
@property (nonatomic, strong)HomeWorkRecordListVC*  recordVC;
@property (nonatomic, strong)HomeWorkDraftVC*       draftVC;
@end

@implementation HomeWorkVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.recordVC = [[HomeWorkRecordListVC alloc] init];
        self.draftVC = [[HomeWorkDraftVC alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"作业练习";
    [self.navigationItem setTitleView:[self segmentCtrl]];
    [self setRightbarButtonHighlighted:NO];
    [self.recordVC.view setFrame:self.view.bounds];
    [self.recordVC.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:self.recordVC.view];

    [self.draftVC.view setFrame:self.view.bounds];
    [self.draftVC.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:self.draftVC.view];
    [self.draftVC.view setHidden:YES];
    
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

- (UISegmentedControl *)segmentCtrl{
    if(!_segmentCtrl){
        _segmentCtrl = [[UISegmentedControl alloc] initWithItems:@[@"作业记录",@"草稿"]];
        [_segmentCtrl setWidth:kScreenWidth / 2];
        [_segmentCtrl addTarget:self action:@selector(onSegmentValueChanged) forControlEvents:UIControlEventValueChanged];
        [_segmentCtrl setSelectedSegmentIndex:0];
    }
    return _segmentCtrl;
}

- (void)onSegmentValueChanged{
    NSInteger selectedIndex = self.segmentCtrl.selectedSegmentIndex;
    [self.recordVC.view setHidden:selectedIndex != 0];
    [self.draftVC.view setHidden:selectedIndex != 1];
    if(selectedIndex == 0){
        [self setRightbarButtonHighlighted:NO];
    }
    else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearDraft)];
    }
}

- (void)onMoreClicked{
     [self setRightbarButtonHighlighted:YES];
    __weak typeof(self) wself = self;
    NotificationActionItem *settingItem = [NotificationActionItem actionItemWithTitle:@"偏好设置" action:^{
        HomeworkSettingVC *settingVC = [[HomeworkSettingVC alloc] init];
        [wself.navigationController pushViewController:settingVC animated:YES];
    } destroyItem:NO];
    NotificationActionItem *anylizeItem = [NotificationActionItem actionItemWithTitle:@"学情分析" action:^{
        
    } destroyItem:NO];
    NotificationActionItem *clearItem = [NotificationActionItem actionItemWithTitle:@"清空记录" action:^{
        
    } destroyItem:YES];
    [NotificationDetailActionView showWithActions:@[settingItem, anylizeItem, clearItem] completion:^{
        [wself setRightbarButtonHighlighted:NO];
    }];
}

- (void)clearDraft{
    __weak typeof(self) wself = self;
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"是否清空全部未发草稿" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertView addAction:[UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [wself.draftVC clearDraft];
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [CurrentROOTNavigationVC presentViewController:alertView animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
