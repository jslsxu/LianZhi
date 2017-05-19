//
//  TreeHouseVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TreeHouseVC.h"
#import "PublishSelectionView.h"
#import "TreeHouseItemDetailVC.h"
#import "ActionPopView.h"
#import "ClassZoneItemCell.h"
NSString *const kPublishPhotoItemFinishedNotification = @"PublishPhotoItemFinishedNotification";
NSString *const kPublishPhotoItemKey = @"PublishPhotoItemKey";
@interface TreeHouseVC ()<PublishSelectDelegate, ActionSelectViewDelegate, ActionPopViewDelegate>
@property (nonatomic, weak)TreehouseItem *itemForTag;
@property (nonatomic, strong)NSArray *tagSourceArray;
@property (nonatomic, strong)TreehouseItem *targetTreeHouseItem;
@property (nonatomic, strong)ResponseItem *targetResponseItem;
@end

@implementation TreeHouseVC

- (NSString *)saveTask:(TreehouseItem *)item
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:item.params];
    [params setValue:item.detail forKey:@"words"];
    NSMutableString *picSeq = [[NSMutableString alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < [item.photos count]; i++)
    {
        PhotoItem *photoItem = [item.photos objectAtIndex:i];
        PublishImageItem *imageItem = [photoItem publishImageItem];
        NSString *curKey = nil;
        if(imageItem.image == nil)
        {
            curKey = imageItem.photoID;
        }
        else
            curKey = imageItem.photoKey;
        if(curKey)
        {
            if(picSeq.length == 0)
                [picSeq appendString:curKey];
            else
                [picSeq appendFormat:@",%@",curKey];
        }
    }
    [params setValue:picSeq forKey:@"pic_seqs"];
    [params setValue:[UserCenter sharedInstance].curChild.uid forKey:@"child_id"];
    NetworkStatus status = [ApplicationDelegate.hostReach currentReachabilityStatus];
    BOOL notice = (status == ReachableViaWiFi && [UserCenter sharedInstance].personalSetting.wifiSend && item.delay);
    if(notice)
        [params setValue:@"1" forKey:@"onlywifi_notice"];
    NSArray *photos = item.photos;
    NSMutableDictionary *images = [[NSMutableDictionary alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < [photos count]; i++) {
        PhotoItem *photoItem = [photos objectAtIndex:i];
        PublishImageItem *imageItem = [photoItem publishImageItem];
        NSString *photoKey = imageItem.photoKey;
        if(imageItem.image)
            [images setValue:UIImageJPEGRepresentation(imageItem.image, 0.8) forKey:photoKey];
    }

    //保存task
    TaskItem *taskItem = [[TaskItem alloc] init];
    taskItem.images = images;
    taskItem.params = params;
    taskItem.targetUrl = @"tree/post_content";
    NSString *filePath = [[TaskUploadManager sharedInstance] saveTask:taskItem];
    return filePath;
}

- (void)startUploading:(TreehouseItem *)item
{
    if(item.newSend && !item.isUploading)
    {
        item.isUploading = YES;
        NSInteger index = [self.tableViewModel.modelItemArray indexOfObject:item];
        if(index >= 0 && index < self.tableViewModel.modelItemArray.count)
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:item.params];
        [params setValue:item.detail forKey:@"words"];
        NSMutableString *picSeq = [[NSMutableString alloc] initWithCapacity:0];
        for (NSInteger i = 0; i < [item.photos count]; i++)
        {
            PhotoItem *photoItem = [item.photos objectAtIndex:i];
            PublishImageItem *imageItem = [photoItem publishImageItem];
            NSString *curKey = nil;
            if(imageItem.image == nil)
            {
                curKey = imageItem.photoID;
            }
            else
                curKey = imageItem.photoKey;
            if(curKey)
            {
                if(picSeq.length == 0)
                    [picSeq appendString:curKey];
                else
                    [picSeq appendFormat:@",%@",curKey];
            }
        }
        [params setValue:picSeq forKey:@"pic_seqs"];
        [params setValue:[UserCenter sharedInstance].curChild.uid forKey:@"child_id"];
        NetworkStatus status = [ApplicationDelegate.hostReach currentReachabilityStatus];
        BOOL notice = (status == ReachableViaWiFi && [UserCenter sharedInstance].personalSetting.wifiSend && item.delay);
        if(notice)
            [params setValue:@"1" forKey:@"onlywifi_notice"];
        NSArray *photos = item.photos;
        
        NSMutableDictionary *images = [[NSMutableDictionary alloc] initWithCapacity:0];
        for (NSInteger i = 0; i < [photos count]; i++) {
            PhotoItem *photoItem = [photos objectAtIndex:i];
            PublishImageItem *imageItem = [photoItem publishImageItem];
            NSString *photoKey = imageItem.photoKey;
            if(imageItem.image)
                [images setValue:UIImageJPEGRepresentation(imageItem.image, 0.8) forKey:photoKey];
        }
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"tree/post_content" withParams:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (NSString *key in images.allKeys)
            {
                NSData *imageData = images[key];
                if(imageData)
                    [formData appendPartWithFileData:imageData name:key fileName:key mimeType:@"image/jpeg"];
            }
        } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            TNDataWrapper *infoWrapper = [responseObject getDataWrapperForKey:@"info"];
            if(infoWrapper.count > 0)
            {
                if(item.savedPath)
                    [[NSFileManager defaultManager] removeItemAtPath:item.savedPath error:nil];
                TreehouseItem *zoneItem = [[TreehouseItem alloc] init];
                [zoneItem parseData:infoWrapper];
                
                NSInteger index = [self.tableViewModel.modelItemArray indexOfObject:item];
                if(index >=0 && index < self.tableViewModel.modelItemArray.count)
                {
                    [self.tableViewModel.modelItemArray replaceObjectAtIndex:index withObject:zoneItem];
                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                    [self showEmptyLabel:self.tableViewModel.modelItemArray.count == 0];
                }
                if(notice)
                    [[NSNotificationCenter defaultCenter] postNotificationName:kPublishPhotoItemFinishedNotification object:nil userInfo:nil];
            }
            item.isUploading = NO;
        } fail:^(NSString *errMsg) {
            item.isUploading = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self onNetworkStatusChanged];
            });
        }];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)setTitle:(NSString *)title{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label setTextColor:[UIColor colorWithHexString:@"252525"]];
    [label setFont:[UIFont systemFontOfSize:18]];
    [label setText:title];
    [label sizeToFit];
    [self.navigationItem setTitleView:label];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        [self addNotification];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"eeeef4"]];
    self.title = @"我的树屋";
    self.shouldShowEmptyHint = YES;
    //请求网络数据
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ActionAdd"] style:UIBarButtonItemStylePlain target:self action:@selector(onPublishButtonClicked)]];
    UIView *whiteLine = [[UIView alloc] initWithFrame:CGRectMake((50 - 2 / 2), 0, 2, self.view.height)];
    [whiteLine setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:whiteLine];
    [self.view sendSubviewToBack:whiteLine];
    
    _headerView = [[TreeHouseHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 0)];
    [self.tableView setTableHeaderView:_headerView];
    
    _replyBox = [[ReplyBox alloc] initWithFrame:CGRectMake(0, kScreenHeight, self.view.width, REPLY_BOX_HEIGHT)];
    [_replyBox setDelegate:self];
    [[UIApplication sharedApplication].keyWindow addSubview:_replyBox];
    _replyBox.hidden = YES;
    
    [self bindTableCell:@"TreeHouseCell" tableModel:@"TreeHouseModel"];
    [self setSupportPullDown:YES];
    [self setSupportPullUp:YES];
    [self requestData:REQUEST_REFRESH];
    
}

- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTreeHouseItemDelete:) name:kTreeHouseItemDeleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTreeHouseItemTagDelete:) name:kTreeHouseItemTagDeleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTreeHouseItemTagSelect:) name:kTreeHouseItemTagSelectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStatusChanged) name:kStatusChangedNotification object:nil];
    //监听当前孩子变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurChildChanged) name:kUserCenterChangedCurChildNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkStatusChanged) name:kReachabilityChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkStatusChanged) name:kPersonalSettingChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkStatusChanged) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //当前任务完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kTaskItemSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTreehouseItemSendSuccess:) name:kPublishPhotoItemFinishedNotification object:nil];
}


- (void)onNetworkStatusChanged
{
    Reachability* curReach = ApplicationDelegate.hostReach;
    //对连接改变做出响应的处理动作。
    NetworkStatus status = [curReach currentReachabilityStatus];
    if(status == ReachableViaWiFi || (status == ReachableViaWWAN && ![UserCenter sharedInstance].personalSetting.wifiSend))
    {
        for (TreehouseItem *item in self.tableViewModel.modelItemArray) {
            [self startUploading:item];
        }
    }
}

- (void)onTreehouseItemSendSuccess:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    TreehouseItem *item = userInfo[kPublishPhotoItemKey];
    [self.tableViewModel.modelItemArray insertObject:item atIndex:0];
    [self.tableView reloadData];
}

- (void)onPersonalSettingChanged
{
    
}

- (void)refresh
{
    [self requestData:REQUEST_REFRESH];
}
- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"tree/feed_list"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    [task setObserver:self];
    
    TreeHouseModel *model = (TreeHouseModel *)self.tableViewModel;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if(requestType == REQUEST_REFRESH)
        [params setValue:@"new" forKey:@"mode"];
    else
        [params setValue:@"old" forKey:@"mode"];
    [params setValue:kStringFromValue(20) forKey:@"num"];
    [params setValue:model.minID forKey:@"min_id"];
    [task setParams:params];
    return task;

}

- (void)onPublishButtonClicked
{
//    [UIView animateWithDuration:0.3 animations:^{
//        [_publishButton setAlpha:0.f];
//    }];
//    PublishSelectionView *selectionView = [[PublishSelectionView alloc] initWithFrame:self.view.bounds];
//    [selectionView setDelegate:self];
//    [selectionView show];
    
    ActionPopView *actionView = [[ActionPopView alloc] initWithFrame:CGRectMake(self.view.width - 140, 64, 140, 140)];
    [actionView setDelegate:self];
    [actionView show];
}

- (void)onCurChildChanged
{
    [_headerView setupHeaderView];
    [self loadCache];
    [self requestData:REQUEST_REFRESH];
}

- (void)onStatusChanged
{
    NSArray *commentArray = [UserCenter sharedInstance].statusManager.treeNewCommentArray;
    TimelineCommentItem *curAlert = nil;
    for (TimelineCommentItem *alertInfo in commentArray)
    {
        if([alertInfo.objid isEqualToString:[UserCenter sharedInstance].curChild.uid])
        {
            curAlert = alertInfo;
        }
    }
    [_headerView setCommentItem:curAlert];
    [self.tableView setTableHeaderView:_headerView];
}

#pragma mark - ReplyBoxDelegate
- (void)onActionViewCommit:(NSString *)content
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.targetTreeHouseItem.itemID forKey:@"feed_id"];
    [params setValue:@"1" forKey:@"types"];
    [params setValue:[UserCenter sharedInstance].curChild.uid forKey:@"objid"];
    if(self.targetResponseItem)
    {
        [params setValue:self.targetResponseItem.sendUser.uid forKey:@"to_uid"];
        [params setValue:self.targetResponseItem.commentItem.commentId forKey:@"comment_id"];
    }
    [params setValue:content forKey:@"content"];
    
    ResponseItem *tmpResponseItem = [[ResponseItem alloc] init];
    tmpResponseItem.sendUser = [UserCenter sharedInstance].userInfo;
    tmpResponseItem.isTmp = YES;
    CommentItem *commentItem = [[CommentItem alloc] init];
    [commentItem setContent:content];
    if(self.targetResponseItem)
        [commentItem setToUser:self.targetResponseItem.sendUser.name];
    [tmpResponseItem setCommentItem:commentItem];
    [self.targetTreeHouseItem.responseModel addResponse:tmpResponseItem];
    [self.tableView reloadData];

    __weak typeof(self) wself = self;
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"comment/send" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        if(responseObject.count > 0)
        {
            TNDataWrapper *commentWrapper  =[responseObject getDataWrapperForIndex:0];
            ResponseItem *responseItem = [[ResponseItem alloc] init];
            [responseItem parseData:commentWrapper];
            NSInteger index = [wself.targetTreeHouseItem.responseModel.responseArray indexOfObject:tmpResponseItem];
            [wself.targetTreeHouseItem.responseModel.responseArray replaceObjectAtIndex:index withObject:responseItem];
//            [wself.targetTreeHouseItem.responseModel addResponse:responseItem];
            [wself.tableView reloadData];
        }
    } fail:^(NSString *errMsg) {
        
    }];
    _replyBox.hidden = YES;
    [_replyBox setText:@""];
    [_replyBox resignFocus];
}

- (void) onActionViewCancel
{
    [_replyBox setHidden:YES];
    [_replyBox setText:@""];
    [_replyBox resignFocus];
}

#pragma mark - TreeHouseCelleDelegate
- (void)onActionClicked:(TreeHouseCell *)cell
{
    self.targetTreeHouseItem = (TreehouseItem *)cell.modelItem;
    self.targetResponseItem = nil;
    __weak typeof(self) wself = self;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGPoint point = [cell.actionButton convertPoint:CGPointMake(10, cell.actionButton.height / 2) toView:keyWindow];
    BOOL praised = self.targetTreeHouseItem.responseModel.praised;
    ActionView *actionView = [[ActionView alloc] initWithPoint:point praised:praised action:^(NSInteger index) {
        if(index == 0)
        {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:self.targetTreeHouseItem.itemID forKey:@"feed_id"];
            [params setValue:@"1" forKey:@"types"];
            [params setValue:[UserCenter sharedInstance].curChild.uid forKey:@"objid"];
            if(!praised)
            {
                [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"fav/send" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                    if(responseObject.count > 0)
                    {
                        UserInfo *userInfo = [[UserInfo alloc] init];
                        TNDataWrapper *userWrapper = [responseObject getDataWrapperForIndex:0];
                        [userInfo parseData:userWrapper];
                        [wself.targetTreeHouseItem.responseModel addPraiseUser:userInfo];
                        [wself.tableView reloadData];
                    }
                } fail:^(NSString *errMsg) {
                    
                }];
            }
            else
            {
                [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"fav/del" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                    [wself.targetTreeHouseItem.responseModel removePraise];
                    [wself.tableView reloadData];
                } fail:^(NSString *errMsg) {
                    
                }];
            }
        }
        else if(index == 1)
        {
            _replyBox.hidden = NO;
            [_replyBox assignFocus];
        }
        else
        {
            if(self.targetTreeHouseItem.audioItem)
            {
                [ProgressHUD showHintText:@"努力开发中,敬请期待..."];
                return;
            }
            NSString *imageUrl = nil;
            if(self.targetTreeHouseItem.photos.count > 0){
                PhotoItem *photoItem = [self.targetTreeHouseItem.photos firstObject];
                imageUrl = photoItem.small;
            }
             NSString *url = [NSString stringWithFormat:@"%@?uid=%@&feed_id=%@",kTreeHouseShareUrl,self.targetTreeHouseItem.user.uid,self.targetTreeHouseItem.itemID];
            [ShareActionView shareWithTitle:self.targetTreeHouseItem.detail content:nil image:[UIImage imageNamed:@"TreeHouse"] imageUrl:imageUrl url:url];
        }
    }];
    [actionView show];
}

- (void)onResponseClickedAtTarget:(ResponseItem *)responseItem cell:(ClassZoneItemCell *)cell
{
    //自己发的删除
    if([[UserCenter sharedInstance].userInfo.uid isEqualToString:responseItem.sendUser.uid])
    {
        __weak typeof(self) wself = self;
        if([responseItem.commentItem.commentId length] > 0){
            TreehouseItem *zoneItem = (TreehouseItem *)cell.modelItem;
            TNButtonItem *deleteItem = [TNButtonItem itemWithTitle:@"删除评论" action:^{
                [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"comment/del" method:REQUEST_POST type:REQUEST_REFRESH withParams:@{@"id" : responseItem.commentItem.commentId,@"feed_id" : zoneItem.itemID, @"types" : @"1"} observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                    [ProgressHUD showSuccess:@"删除成功"];
                    [zoneItem.responseModel removeResponse:responseItem];
                    [wself.tableView reloadData];
                } fail:^(NSString *errMsg) {
                    [ProgressHUD showHintText:errMsg];
                }];
            }];
            TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消返回" action:nil];
            TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"删除这条评论?" buttonItems:@[cancelItem, deleteItem]];
            [alertView show];
        }
    }
    else
    {
        [_replyBox setPlaceHolder:[NSString stringWithFormat:@"回复:%@",self.targetResponseItem.sendUser.name]];
        _replyBox.hidden = NO;
        [_replyBox assignFocus];
        self.targetTreeHouseItem = (TreehouseItem *)cell.modelItem;
        self.targetResponseItem = responseItem;
    }
}

- (void)onShowDetail:(TreehouseItem *)treeItem
{
    if(!treeItem.newSend)
    {
        __weak typeof(self) wself = self;
        TreeHouseItemDetailVC *detailVC = [[TreeHouseItemDetailVC alloc] init];
        [detailVC setTreeHouseItem:treeItem];
        [detailVC setDeleteCallBack:^{
            NSInteger index = [self.tableViewModel.modelItemArray indexOfObject:treeItem];
            if(index >= 0 && index < self.tableViewModel.modelItemArray.count)
            {
                [wself.tableViewModel.modelItemArray removeObject:treeItem];
                [wself.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
        [detailVC setModifyCallBack:^{
            [wself.tableView reloadData];
        }];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark TNBaseTableViewController
- (BOOL)supportCache
{
    return YES;
}

- (NSString *)cacheFileName
{
    return [NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),[UserCenter sharedInstance].curChild.uid];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = [super tableView:tableView numberOfRowsInSection:section];
    [self showEmptyLabel:num == 0];
    return num;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TreeHouseCell *treehouseCell = (TreeHouseCell *)cell;
    if([treehouseCell respondsToSelector:@selector(setDelegate:)])
        [treehouseCell setDelegate:self];
}

- (void)TNBaseTableViewControllerRequestSuccess
{
    [self onStatusChanged];
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath
{
//    TreehouseItem *item = (TreehouseItem *)modelItem;
//    if(!item.newSend)
//    {
//        TreeHouseItemDetailVC *detailVC = [[TreeHouseItemDetailVC alloc] init];
//        [detailVC setTreeHouseItem:item];
//        [detailVC setDeleteCallBack:^{
//            NSInteger index = [self.tableViewModel.modelItemArray indexOfObject:item];
//            if(index >= 0 && index < self.tableViewModel.modelItemArray.count)
//            {
//                [self.tableViewModel.modelItemArray removeObject:item];
//                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//                [self showEmptyLabel:self.tableViewModel.modelItemArray.count == 0];
//            }
//        }];
//        [detailVC setModifyCallBack:^{
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        }];
//        [self.navigationController pushViewController:detailVC animated:YES];
//    }
}

#pragma mark - ActionPopViewDelegate
- (void)popActionViewDidSelectedAtIndex:(NSInteger)index
{
    PublishBaseVC *publishVC = nil;
    if(index == 0)
    {
        publishVC = [[PublishArticleVC alloc] init];
    }
    else if(index == 1)
    {
        publishVC = [[PublishPhotoVC alloc] init];
    }
    else
    {
        publishVC = [[PublishAudioVC alloc] init];
    }
    [publishVC setDelegate:self];
    TNBaseNavigationController *navVC = [[TNBaseNavigationController alloc] initWithRootViewController:publishVC];
    [CurrentROOTNavigationVC presentViewController:navVC animated:YES completion:^{
        
    }];

}

//#pragma mark - PublishTreeItemDelegate
//- (void)publishTreeHouseSuccess:(TreehouseItem *)item
//{
//    [self.tableViewModel.modelItemArray insertObject:item atIndex:0];
//    [self.tableView reloadData];
//    [self showEmptyLabel:self.tableViewModel.modelItemArray.count == 0];
//    item.savedPath = [self saveTask:item];
//    if([item canSendDirectly])
//        [self startUploading:item];
//    else
//    {
//        if([ApplicationDelegate.hostReach currentReachabilityStatus] == ReachableViaWiFi || ([ApplicationDelegate.hostReach currentReachabilityStatus] == ReachableViaWWAN && ![UserCenter sharedInstance].personalSetting.wifiSend))
//            [self startUploading:item];
//        else
//        {
//            [item setDelay:YES];
//            if(([ApplicationDelegate.hostReach currentReachabilityStatus] == ReachableViaWWAN && [UserCenter sharedInstance].personalSetting.wifiSend))
//            {
//                NSInteger imageNum = 0;
//                for (PhotoItem *photoItem in item.photos) {
//                    if(photoItem.image)
//                        imageNum ++;
//                }
//                [ProgressHUD showHintText:[NSString stringWithFormat:@"为了帮您节省流量，您本次分享的%ld张照片将在有wifi环境时自动上传，在此之前请勿删除本地相册中的内容",(long)imageNum]];
//            }
//        }
//    }
//}

#pragma mark NSNotification
- (void)onTreeHouseItemDelete:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    TreehouseItem *item = userInfo[kTreeHouseItemKey];
    if(item)
    {
        if(!item.newSend)
        {
            __weak typeof(self) wself = self;
            TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消" action:nil];
            TNButtonItem *confirmItem = [TNButtonItem itemWithTitle:@"删除" action:^{
                [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"tree/delete_feed" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"feed_id":item.itemID} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                    NSInteger index = [self.tableViewModel.modelItemArray indexOfObject:item];
                    if(index >= 0 && index < self.tableViewModel.modelItemArray.count)
                    {
                        [wself.tableViewModel.modelItemArray removeObject:item];
                        [wself.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                        [wself showEmptyLabel:wself.tableViewModel.modelItemArray.count == 0];
                    }
                } fail:^(NSString *errMsg) {
                    
                }];
            }];
            
            TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"是否确认删除日记?" buttonItems:@[cancelItem, confirmItem]];
            [alertView show];
        }
        else
        {
            __weak typeof(self) wself = self;
            TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消" action:nil];
            TNButtonItem *confirmItem = [TNButtonItem itemWithTitle:@"删除" action:^{
                if(item.uploadOperation)
                    [item.uploadOperation cancel];
                NSInteger index = [wself.tableViewModel.modelItemArray indexOfObject:item];
                if(index >= 0 && index < wself.tableViewModel.modelItemArray.count)
                {
                    [wself.tableViewModel.modelItemArray removeObject:item];
                    [wself.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                    [wself showEmptyLabel:wself.tableViewModel.modelItemArray.count == 0];
                }
            }];
            
            TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"是否确认删除日记?" buttonItems:@[cancelItem, confirmItem]];
            [alertView show];
        }
    }
}

- (void)onTreeHouseItemTagDelete:(NSNotification *)notification
{
    __weak typeof(self) wself = self;
    NSDictionary *userInfo = notification.userInfo;
    TreehouseItem *item = userInfo[kTreeHouseItemKey];
    TNButtonItem *deleteItem = [TNButtonItem itemWithTitle:@"删除" action:^{
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"tree/delete_feed_tag" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"feed_id":item.itemID} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [item setTag:nil];
            [wself.tableView reloadData];
        } fail:^(NSString *errMsg) {
            
        }];
    }];
    TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消" action:nil];
    TNActionSheet *actionSheet = [[TNActionSheet alloc] initWithTitle:@"是否确认删除成长标签" descriptionView:nil destructiveButton:deleteItem cancelItem:cancelItem otherItems:nil];
    [actionSheet show];
}

- (void)onTreeHouseItemTagSelect:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    TreehouseItem *item = userInfo[kTreeHouseItemKey];
    self.itemForTag = item;
    
    self.tagSourceArray = [[UserCenter sharedInstance].userData.config tagForPrivilege:self.itemForTag.tagPrivilege];
    ActionSelectView *selectView = [[ActionSelectView alloc] init];
    [selectView setDelegate:self];
    [selectView show];
}

#pragma mark - PublishSelectDelegate
- (void)publishContentDidSelectAtIndex:(NSInteger)index
{
    [UIView animateWithDuration:0.3 animations:^{
        [_publishButton setAlpha:1.f];
    }];
    PublishBaseVC *publishVC = nil;
    if(index == 0)
    {
        publishVC = [[PublishArticleVC alloc] init];
    }
    else if(index == 1)
    {
        publishVC = [[PublishPhotoVC alloc] init];
    }
    else
    {
        publishVC = [[PublishAudioVC alloc] init];
    }
    [publishVC setDelegate:self];
    TNBaseNavigationController *navVC = [[TNBaseNavigationController alloc] initWithRootViewController:publishVC];
    [CurrentROOTNavigationVC presentViewController:navVC animated:YES completion:^{
        
    }];
}

- (void)publishContentDidCancel
{
    [UIView animateWithDuration:0.3 animations:^{
        [_publishButton setAlpha:1.f];
    }];
}

#pragma mark - ActionSelectViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(ActionSelectView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(ActionSelectView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
        return self.tagSourceArray.count;
    else
    {
        NSInteger index = [pickerView.pickerView selectedRowInComponent:0];
        TagGroup *group = [self.tagSourceArray objectAtIndex:index];
        return [group.subTags count];
    }
}

- (NSString *)pickerView:(ActionSelectView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    if(component == 0)
    {
        TagGroup *group = [self.tagSourceArray objectAtIndex:row];
        return group.groupName;
    }
    else
    {
        NSInteger index = [pickerView.pickerView selectedRowInComponent:0];
        TagGroup *group = [self.tagSourceArray objectAtIndex:index];
        if(row < group.subTags.count)
        {
            SubTag *tag = [group.subTags objectAtIndex:row];
            return tag.tagName;
        }
        return nil;
    }
    
}

- (void)pickerView:(ActionSelectView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == 0)
        [pickerView.pickerView reloadComponent:1];
}

- (void)pickerViewFinished:(ActionSelectView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    __weak typeof(self) wself = self;
    NSInteger firstIndex = [pickerView.pickerView selectedRowInComponent:0];
    NSInteger secondIndex = [pickerView.pickerView selectedRowInComponent:1];
    TagGroup *group = [self.tagSourceArray objectAtIndex:firstIndex];
    SubTag *tag = [group.subTags objectAtIndex:secondIndex];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.itemForTag.itemID forKey:@"feed_id"];
    [params setValue:tag.tagID forKey:@"tag_id"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"/tree/add_feed_tag" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [wself.itemForTag setTag:tag.tagName];
        [wself.tableView reloadData];
    } fail:^(NSString *errMsg) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
