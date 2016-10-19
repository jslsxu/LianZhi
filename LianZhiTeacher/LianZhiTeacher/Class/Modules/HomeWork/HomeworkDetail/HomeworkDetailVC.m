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
@interface HomeworkDetailVC ()
@property (nonatomic, strong)UISegmentedControl*        segmentCtrl;
@property (nonatomic, strong)UIButton*                  moreButton;
@property (nonatomic, strong)HomeworkDetailView*        detailView;
@property (nonatomic, strong)HomeworkTargetListView*    targetListView;
@end

@implementation HomeworkDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitleView:[self segmentCtrl]];
    [self setRightbarButtonHighlighted:NO];
    [self.view addSubview:[self detailView]];
    [self.view addSubview:[self targetListView]];
    [self onSegmentValueChanged];
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

- (void)deleteHomeworkItem{
    
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
