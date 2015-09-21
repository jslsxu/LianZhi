//
//  TreeHouseVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TreeHouseVC.h"
#import "PublishSelectionView.h"
NSString *const kPublishPhotoItemFinishedNotification = @"PublishPhotoItemFinishedNotification";
NSString *const kPublishPhotoItemKey = @"PublishPhotoItemKey";
@interface TreeHouseVC ()<PublishSelectDelegate, ActionSelectViewDelegate>
@property (nonatomic, weak)TreehouseItem *itemForTag;
@property (nonatomic, strong)NSArray *tagSourceArray;
@property (nonatomic, strong)TreehouseItem *responseItem;
@property (nonatomic, strong)ResponseItem *commentItem;
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
        if(picSeq.length == 0)
            [picSeq appendString:curKey];
        else
            [picSeq appendFormat:@",%@",curKey];
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
            if(picSeq.length == 0)
                [picSeq appendString:curKey];
            else
                [picSeq appendFormat:@",%@",curKey];
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
            for (NSString *key in images.allKeys) {
                [formData appendPartWithFileData:images[key] name:key fileName:key mimeType:@"image/jpeg"];
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
//    [self requestData:REQUEST_REFRESH];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"我的树屋";
    self.shouldShowEmptyHint = YES;
    //请求网络数据
    
    [self bindTableCell:@"TreeHouseCell" tableModel:@"TreeHouseModel"];
    [self setSupportPullDown:YES];
    [self setSupportPullUp:YES];
    [self requestData:REQUEST_REFRESH];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTreeHouseItemDelete:) name:kTreeHouseItemDeleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTreeHouseItemTagDelete:) name:kTreeHouseItemTagDeleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTreeHouseItemTagSelect:) name:kTreeHouseItemTagSelectNotification object:nil];
    
    //监听当前孩子变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurChildChanged) name:kUserCenterChangedCurChildNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkStatusChanged) name:kReachabilityChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkStatusChanged) name:kPersonalSettingChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkStatusChanged) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //当前任务完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kTaskItemSuccessNotification object:nil];
}

- (void)setupSubviews
{
    CGFloat publishButtonWidth = 40;
    _publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_publishButton setImage:[UIImage imageNamed:@"TreeHouseEdit.png"] forState:UIControlStateNormal];
    [_publishButton addTarget:self action:@selector(onPublishButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_publishButton];
    [_publishButton setFrame:CGRectMake(self.view.width - publishButtonWidth - 15, self.view.height - publishButtonWidth - 15, publishButtonWidth, publishButtonWidth)];
    
    UIView *whiteLine = [[UIView alloc] initWithFrame:CGRectMake((50 - 2 / 2), 0, 2, self.view.height)];
    [whiteLine setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:whiteLine];
    [self.view sendSubviewToBack:whiteLine];
    
    _headerView = [[TreeHouseHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 0)];
    [self.tableView setTableHeaderView:_headerView];
    
    _replyBox = [[ReplyBox alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - REPLY_BOX_HEIGHT, self.view.width, REPLY_BOX_HEIGHT)];
    [_replyBox setDelegate:self];
    [ApplicationDelegate.homeVC.view addSubview:_replyBox];
    _replyBox.hidden = YES;
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
    [UIView animateWithDuration:0.3 animations:^{
        [_publishButton setAlpha:0.f];
    }];
    PublishSelectionView *selectionView = [[PublishSelectionView alloc] initWithFrame:self.view.bounds];
    [selectionView setDelegate:self];
    [selectionView show];
}

- (void)onCurChildChanged
{
    [_headerView setupHeaderView];
    [self loadCache];
    [self requestData:REQUEST_REFRESH];
}

#pragma mark - ReplyBoxDelegate
- (void)onActionViewCommit:(NSString *)content
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.responseItem.itemID forKey:@"feed_id"];
    [params setValue:@"1" forKey:@"types"];
    if(self.commentItem)
    {
        [params setValue:self.commentItem.sendUser.uid forKey:@"to_uid"];
        [params setValue:self.commentItem.commentItem.commentId forKey:@"comment_id"];
    }
    [params setValue:content forKey:@"content"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"comment/send" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        
    } fail:^(NSString *errMsg) {
        
    }];
    self.responseItem = nil;
    self.commentItem = nil;
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
    self.responseItem = (TreehouseItem *)cell.modelItem;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGPoint point = [cell convertPoint:cell.actionButton.center toView:keyWindow];
    point.x = point.x + 72;
    ActionView *actionView = [[ActionView alloc] initWithPoint:point action:^(NSInteger index) {
        if(index == 0)
        {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:self.responseItem.itemID forKey:@"feed_id"];
            [params setValue:@"1" forKey:@"types"];
            [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"fav/send" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                
            } fail:^(NSString *errMsg) {
                
            }];
        }
        else if(index == 1)
        {
            _replyBox.hidden = NO;
            [_replyBox assignFocus];
        }
        else
        {
            
        }
    }];
    [actionView show];
}

- (void)onResponseClickedAtTarget:(ResponseItem *)responseItem cell:(ClassZoneItemCell *)cell
{
    _replyBox.hidden = NO;
    [_replyBox assignFocus];
    self.responseItem = (TreehouseItem *)cell.modelItem;
    self.commentItem = responseItem;
    
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TreeHouseCell *treehouseCell = (TreeHouseCell *)cell;
    if([treehouseCell respondsToSelector:@selector(setDelegate:)])
        [treehouseCell setDelegate:self];
}

#pragma mark - PublishTreeItemDelegate
- (void)publishTreeHouseSuccess:(TreehouseItem *)item
{
    [self.tableViewModel.modelItemArray insertObject:item atIndex:0];
    [self.tableView reloadData];
    [self showEmptyLabel:self.tableViewModel.modelItemArray.count == 0];
    item.savedPath = [self saveTask:item];
    if([item canSendDirectly])
        [self startUploading:item];
    else
    {
        if([ApplicationDelegate.hostReach currentReachabilityStatus] == ReachableViaWiFi || ([ApplicationDelegate.hostReach currentReachabilityStatus] == ReachableViaWWAN && ![UserCenter sharedInstance].personalSetting.wifiSend))
            [self startUploading:item];
        else
        {
            [item setDelay:YES];
            if(([ApplicationDelegate.hostReach currentReachabilityStatus] == ReachableViaWWAN && [UserCenter sharedInstance].personalSetting.wifiSend))
            {
                NSInteger imageNum = 0;
                for (PhotoItem *photoItem in item.photos) {
                    if(photoItem.image)
                        imageNum ++;
                }
                [ProgressHUD showHintText:[NSString stringWithFormat:@"为了帮您节省流量，您本次分享的%ld张照片将在有wifi环境时自动上传，在此之前请勿删除本地相册中的内容",(long)imageNum]];
            }
        }
    }
}

#pragma mark NSNotification
- (void)onTreeHouseItemDelete:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    TreehouseItem *item = userInfo[kTreeHouseItemKey];
    if(item)
    {
        if(!item.newSend)
        {
            TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消" action:nil];
            TNButtonItem *confirmItem = [TNButtonItem itemWithTitle:@"删除" action:^{
                [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"tree/delete_feed" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"feed_id":item.itemID} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                    NSInteger index = [self.tableViewModel.modelItemArray indexOfObject:item];
                    if(index >= 0 && index < self.tableViewModel.modelItemArray.count)
                    {
                        [self.tableViewModel.modelItemArray removeObject:item];
                        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                        [self showEmptyLabel:self.tableViewModel.modelItemArray.count == 0];
                    }
                } fail:^(NSString *errMsg) {
                    
                }];
            }];
            
            TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"是否确认删除日记?" buttonItems:@[cancelItem, confirmItem]];
            [alertView show];
        }
        else
        {
            TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消" action:nil];
            TNButtonItem *confirmItem = [TNButtonItem itemWithTitle:@"删除" action:^{
                if(item.uploadOperation)
                    [item.uploadOperation cancel];
                NSInteger index = [self.tableViewModel.modelItemArray indexOfObject:item];
                if(index >= 0 && index < self.tableViewModel.modelItemArray.count)
                {
                    [self.tableViewModel.modelItemArray removeObject:item];
                    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                    [self showEmptyLabel:self.tableViewModel.modelItemArray.count == 0];
                }
            }];
            
            TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"是否确认删除日记?" buttonItems:@[cancelItem, confirmItem]];
            [alertView show];
        }
    }
}

- (void)onTreeHouseItemTagDelete:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    TreehouseItem *item = userInfo[kTreeHouseItemKey];
    TNButtonItem *deleteItem = [TNButtonItem itemWithTitle:@"删除" action:^{
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"tree/delete_feed_tag" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"feed_id":item.itemID} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [item setTag:nil];
            [self.tableView reloadData];
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
    NSInteger firstIndex = [pickerView.pickerView selectedRowInComponent:0];
    NSInteger secondIndex = [pickerView.pickerView selectedRowInComponent:1];
    TagGroup *group = [self.tagSourceArray objectAtIndex:firstIndex];
    SubTag *tag = [group.subTags objectAtIndex:secondIndex];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.itemForTag.itemID forKey:@"feed_id"];
    [params setValue:tag.tagID forKey:@"tag_id"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"/tree/add_feed_tag" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [self.itemForTag setTag:tag.tagName];
        [self.tableView reloadData];
    } fail:^(NSString *errMsg) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
