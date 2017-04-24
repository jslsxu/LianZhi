//
//  ClassZoneVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "ClassZoneVC.h"
#import "PublishSelectionView.h"
#import "ClassZoneModel.h"
#import "ClassSelectionVC.h"
#import "NewMessageVC.h"
#import "FeedItemDetailVC.h"
#import "ActionPopView.h"
#import "PublishVideoVC.h"

#define kClassZoneShown         @"ClassZoneShown"

NSString *const kPublishPhotoItemFinishedNotification = @"PublishPhotoItemFinishedNotification";
NSString *const kPublishPhotoItemKey = @"PublishPhotoItemKey";

@implementation NewMessageIndicator
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"3e3e3e"]];
        [self.layer setCornerRadius:3];
        [self.layer setMasksToBounds:YES];
        
        
        _avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(5, (self.height - 20) / 2, 20, 20)];
        [_avatarView sd_setImageWithURL:[NSURL URLWithString:[UserCenter sharedInstance].userInfo.avatar]];
        [self addSubview:_avatarView];
        
        _indicatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarView.right + 15, 0, self.width - 10 - (_avatarView.right + 5), self.height)];
        [_indicatorLabel setTextColor:[UIColor whiteColor]];
        [_indicatorLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_indicatorLabel];
        
        _coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_coverButton addTarget:self action:@selector(onNewMessageClicked) forControlEvents:UIControlEventTouchUpInside];
        [_coverButton setFrame:self.bounds];
        [self addSubview:_coverButton];
    }
    return self;
}

- (void)setCommentItem:(TimelineCommentItem *)commentItem
{
    _commentItem = commentItem;
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:_commentItem.alertInfo.avatar]];
    [_indicatorLabel setText:[NSString stringWithFormat:@"%ld条新消息",(long)_commentItem.alertInfo.num]];
}

- (void)onNewMessageClicked
{
    if(self.clickAction)
        self.clickAction();
}

@end


@implementation ClassZoneHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        UIView *contentView = [[UIView alloc] initWithFrame:self.bounds];
        [contentView setBackgroundColor:[UIColor colorWithHexString:@"173e39"]];
        [self addSubview:contentView];
        
        _newpaperImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(@"BlackboardText.png")]];
        [_newpaperImageView setOrigin:CGPointMake(20, 10)];
        [self addSubview:_newpaperImageView];
        
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 25, self.width - 30 - 30, self.height - 30 - 25)];
        [_contentLabel setUserInteractionEnabled:YES];
        [_contentLabel setTextColor:[UIColor whiteColor]];
        [_contentLabel setFont:[UIFont systemFontOfSize:16]];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self addSubview:_contentLabel];
        
        _brashImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(@"Brash.png")]];
        [_brashImage setUserInteractionEnabled:YES];
        [_brashImage setFrame:CGRectMake(15, frame.size.height - 12 - _brashImage.height, _brashImage.width, _brashImage.height)];
        [self addSubview:_brashImage];
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 12, self.width, 12)];
        [_bottomView setBackgroundColor:[UIColor colorWithRed:158 / 255.0 green:158 / 255.0 blue:158 / 255.0 alpha:1.f]];
        [self addSubview:_bottomView];
        
//        if()//有新消息
        {
            __weak typeof(self) wself = self;
            _msgIndicator = [[NewMessageIndicator alloc] initWithFrame:CGRectMake((self.width - 140) / 2, _bottomView.bottom + 6, 140, 30)];
            [_msgIndicator setClickAction:^{
                [wself onNewMessageClicked];
            }];
            [_msgIndicator setHidden:YES];
            [self addSubview:_msgIndicator];
            
            self.height += 30 + 12;
        }
    }
    return self;
}

- (void)setCommentItem:(TimelineCommentItem *)commentItem
{
    _commentItem = commentItem;
    BOOL hide = (_commentItem == nil || _commentItem.alertInfo.num == 0);
    [_msgIndicator setHidden:hide];
    if(!hide)
    {
        [_msgIndicator setCommentItem:_commentItem];
        self.height = 160 + 42;
    }
    else
        self.height = 160;
}

- (void)setNewsPaper:(NSString *)newsPaper
{
    _newsPaper = newsPaper;
    [_contentLabel setText:_newsPaper];
}

- (void)onNewMessageClicked
{
    NewMessageVC *newmessageVC = [[NewMessageVC alloc] init];
    [newmessageVC setTypes:NewMessageTypeClassZone];
    [newmessageVC setObjid:self.classInfo.classID];
    [CurrentROOTNavigationVC pushViewController:newmessageVC animated:YES];
}


@end

@interface ClassZoneVC ()<ActionPopViewDelegate>
@property (nonatomic, strong)UIButton *exchangeButton;
@property (nonatomic, strong)UIView*    redDot;
@property (nonatomic, strong)ClassZoneItem *targetZoneItem;
@property (nonatomic, strong)ResponseItem* targetResponseItem;
@end

@implementation ClassZoneVC

- (NSString *)saveTask:(ClassZoneItem *)item
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:item.params];
    [params setValue:item.content forKey:@"words"];
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
    [params setValue:[UserCenter sharedInstance].curSchool.schoolID forKey:@"school_id"];
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
    taskItem.targetUrl = @"class/post_content";
    NSString *filePath = [[TaskUploadManager sharedInstance] saveTask:taskItem];
    return filePath;

}

- (void)startUploading:(ClassZoneItem *)item
{
    if(!item.newSent)
        return;
    item.newSent = NO;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:item.params];
    [params setValue:item.content forKey:@"words"];
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
    [params setValue:[UserCenter sharedInstance].curSchool.schoolID forKey:@"school_id"];
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
    
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"class/post_content" withParams:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSString *key in images.allKeys) {
            [formData appendPartWithFileData:images[key] name:key fileName:key mimeType:@"image/jpeg"];
        }
    } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        TNDataWrapper *infoWrapper = [responseObject getDataWrapperForKey:@"info"];
        if(infoWrapper.count > 0)
        {
            if(item.savedPath)
                [[NSFileManager defaultManager] removeItemAtPath:item.savedPath error:nil];
            [[ClassZoneManager sharedInstance] removeItem:item];
            ClassZoneItem *zoneItem = [[ClassZoneItem alloc] init];
            [zoneItem parseData:infoWrapper];
            NSInteger index = [self.tableViewModel.modelItemArray indexOfObject:item];
            if(index >= 0 && index < self.tableViewModel.modelItemArray.count)
            {
                [self.tableViewModel.modelItemArray replaceObjectAtIndex:index withObject:zoneItem];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                [self showEmptyLabel:self.tableViewModel.modelItemArray.count == 0];
            }
            if(notice)
                [[NSNotificationCenter defaultCenter] postNotificationName:kPublishPhotoItemFinishedNotification object:nil userInfo:nil];
        }
        
    } fail:^(NSString *errMsg) {
        item.newSent = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self onNetworkStatusChanged];
        });
    }];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self addNotifications];
    }
    return self;
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    BOOL classOperationShow = [[userDefaults valueForKey:kClassZoneShown] boolValue];
//    if(classOperationShow == NO)
//    {
//        [self addUserGuide];
//        classOperationShow = YES;
//        [userDefaults setValue:@(classOperationShow) forKey:kClassZoneShown];
//        [userDefaults synchronize];
//    }
//}

- (void)addNotifications{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurSchoolChanged) name:kUserCenterChangedSchoolNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkStatusChanged) name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkStatusChanged) name:kPersonalSettingChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkStatusChanged) name:UIApplicationDidBecomeActiveNotification object:nil];
    //上传成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kTaskItemSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStatusChanged) name:kStatusChangedNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
//    self.title = @"班空间";
    self.shouldShowEmptyHint = YES;
    
    _replyBox = [[ReplyBox alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - REPLY_BOX_HEIGHT, self.view.width, REPLY_BOX_HEIGHT)];
    [_replyBox setDelegate:self];
    [self.view addSubview:_replyBox];
    _replyBox.hidden = YES;
    
    
}

- (void)setupSubviews
{
//    BOOL teach = NO;
//    for (ClassInfo *classInfo in [UserCenter sharedInstance].curSchool.classes)
//    {
//        if([classInfo.classID isEqualToString:self.classInfo.classID])
//            teach = YES;
//    }
//    if(teach)
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ActionAdd"] style:UIBarButtonItemStylePlain target:self action:@selector(onAddClicked)];
    
    [self.tableView setHeight:self.view.height];
    
    _headerView = [[ClassZoneHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 160)];
    [self.tableView setTableHeaderView:_headerView];
    
    [self bindTableCell:@"ClassZoneItemCell" tableModel:@"ClassZoneModel"];
    [self setSupportPullDown:YES];
    [self setSupportPullUp:YES];
    
    [_headerView setClassInfo:_classInfo];
    [self setTitle:_classInfo.name];
    ClassZoneModel *model = (ClassZoneModel *)self.tableViewModel;
    [model setClassID:self.classInfo.classID];
    [self loadCache];
    [self requestData:REQUEST_REFRESH];
}


- (void)addUserGuide
{
    UIView *parentView = [UIApplication sharedApplication].keyWindow;
    
    UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [coverButton addTarget:self action:@selector(onCoverButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [coverButton setFrame:parentView.bounds];
    [coverButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [parentView addSubview:coverButton];
    
    UIImageView *image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(@"ClassZoneGuide1.png")]];
    [image1 setOrigin:CGPointMake(coverButton.width - image1.width - 10, 180)];
    [coverButton addSubview:image1];
    
    UIImageView *image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(@"ClassZoneSwipe.png")]];
    [image2 setOrigin:CGPointMake((self.view.width - image2.width) / 2, image1.bottom + 100)];
    [coverButton addSubview:image2];
    
}

- (void)onAddClicked
{
    ClassZoneModel *zoneModel = (ClassZoneModel *)self.tableViewModel;
    NSInteger actionCount = zoneModel.canEdit ? 5 : 4;
    NSArray *titleArray = @[@"发文字",@"发照片",@"发语音",@"发视频",@"编辑板报"];
    NSArray *imageArray = @[@"ClassZoneText",@"ClassZonePhoto",@"ClassZoneAudio",@"ClassZoneAudio",@"ClassZoneNewspapper"];
    ActionPopView *actionPopView = [[ActionPopView alloc] initWithImageArray:[imageArray subarrayWithRange:NSMakeRange(0, actionCount)] titleArray:[titleArray subarrayWithRange:NSMakeRange(0, actionCount)]];
    [actionPopView setDelegate:self];
    [actionPopView show];
}


- (void)onStatusChanged
{
    BOOL otherHasNew = NO;
    //新动态
    NSArray *newCommentArray = [UserCenter sharedInstance].statusManager.classNewCommentArray;
    NSInteger commentNum = 0;
    for (ClassInfo *classInfo in [UserCenter sharedInstance].curSchool.classes)
    {
        for (TimelineCommentItem *commentItem in newCommentArray)
        {
            if([commentItem.classID isEqualToString:classInfo.classID] && commentItem.alertInfo.num > 0 && ![commentItem.classID isEqualToString:self.classInfo.classID])
                commentNum += commentItem.alertInfo.num;
        }
    }
    if(commentNum > 0)
        otherHasNew = YES;
    else
    {
        //新日志
        NSArray *newFeedArray = [UserCenter sharedInstance].statusManager.feedClassesNew;
        NSInteger num = 0;
        for (ClassFeedNotice *noticeItem in newFeedArray)
        {
            if([noticeItem.schoolID isEqualToString:[UserCenter sharedInstance].curSchool.schoolID] && ![noticeItem.classID isEqualToString:self.classInfo.classID])
            {
                num += noticeItem.num;
            }
        }
        if(num > 0)
            otherHasNew = YES;
    }
    
    [self.redDot setHidden:!otherHasNew];
    
    NSArray *commentArray = [UserCenter sharedInstance].statusManager.classNewCommentArray;
    TimelineCommentItem *curAlert = nil;
    for (TimelineCommentItem *alertInfo in commentArray)
    {
        if([alertInfo.classID isEqualToString:self.classInfo.classID])
        {
            curAlert = alertInfo;
        }
    }
    [_headerView setCommentItem:curAlert];
    [_tableView setTableHeaderView:_headerView];
}

- (void)onCurSchoolChanged
{
    ClassInfo *curClassInfo = [UserCenter sharedInstance].curSchool.classes[0];
    [self setClassInfo:curClassInfo];
    [self requestData:REQUEST_REFRESH];
}

- (void)onCoverButtonClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [button removeFromSuperview];
}

- (void)refresh
{
    [self requestData:REQUEST_REFRESH];
}

- (void)onNetworkStatusChanged
{
    //对连接改变做出响应的处理动作。
    NetworkStatus status = [ApplicationDelegate.hostReach currentReachabilityStatus];
    if(status == ReachableViaWiFi || (status == ReachableViaWWAN && ![UserCenter sharedInstance].personalSetting.wifiSend))
    {
        for (ClassZoneItem *item in self.tableViewModel.modelItemArray) {
            [self startUploading:item];
        }
    }
}


#pragma mark - ActionPopView
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
    else if(index == 2)
    {
        publishVC = [[PublishAudioVC alloc] init];
    }
    else if(index == 3){
        publishVC = [[PublishVideoVC alloc] init];
    }
    else
    {
        ClassZoneModel *zoneModel = (ClassZoneModel *)self.tableViewModel;
        if(zoneModel.canEdit)
        {
            PublishNewspaperVC *newspaperVC = [[PublishNewspaperVC alloc] init];
            [newspaperVC setDelegate:self];
            [newspaperVC setClassInfo:self.classInfo];
            [newspaperVC setNewsPaper:zoneModel.newsPaper];
            publishVC = newspaperVC;
        }
        else
        {
            [ProgressHUD showHintText:@"只有班主任才能修改黑板报"];
            return;
        }
    }
    [publishVC setDelegate:self];
    [publishVC setClassInfo:self.classInfo];
    [self.navigationController pushViewController:publishVC animated:YES];
//    TNBaseNavigationController *navVC = [[TNBaseNavigationController alloc] initWithRootViewController:publishVC];
//    [CurrentROOTNavigationVC presentViewController:navVC animated:YES completion:^{
//        
//    }];

}

#pragma mark TNBaseViewController
- (BOOL)supportCache
{
    return YES;
}

- (NSString *)cacheFileName
{
    return [NSString stringWithFormat:@"%@_%@_%@",NSStringFromClass([self class]),[UserCenter sharedInstance].curSchool.schoolID,self.classInfo.classID];
}


- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    if([self.classInfo.classID length] > 0){
        HttpRequestTask *task = [[HttpRequestTask alloc] init];
        [task setRequestUrl:@"class/space"];
        [task setRequestMethod:REQUEST_GET];
        [task setRequestType:requestType];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        ClassZoneModel *model = (ClassZoneModel *)self.tableViewModel;
        if(requestType == REQUEST_GETMORE)
            [params setValue:@"old" forKey:@"mode"];
        else
            [params setValue:@"new" forKey:@"mode"];
        [params setValue:model.minID forKey:@"min_id"];
        [params setValue:self.classInfo.classID forKey:@"class_id"];
        
        [params setValue:@(20) forKey:@"num"];
        [task setParams:params];
        [task setObserver:self];
        return task;
    }
    return nil;
}

- (void)TNBaseTableViewControllerRequestSuccess
{
    NSString *newsPaper = [(ClassZoneModel *)self.tableViewModel newsPaper];
    if(newsPaper.length == 0)
        newsPaper = [NSString stringWithFormat:@"热烈庆祝我们班率先引用连枝APP智能客户端这里是我们 %@ 的掌上根据地。就让我们一起努力经营好这个大家庭吧",self.classInfo.name];
    [_headerView setNewsPaper:newsPaper];
    
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath
{
//    ClassZoneItem *zoneItem = (ClassZoneItem *)modelItem;
//    if(!zoneItem.newSent)
//    {
//        FeedItemDetailVC *feedItemDetailVC = [[FeedItemDetailVC alloc] init];
//        [feedItemDetailVC setZoneItem:zoneItem];
//        [feedItemDetailVC setClassId:self.classInfo.classID];
//        [feedItemDetailVC setDeleteCallBack:^{
//            NSInteger index = [self.tableViewModel.modelItemArray indexOfObject:modelItem];
//            if(index >= 0 && index < self.tableViewModel.modelItemArray.count)
//            {
//                [self.tableViewModel.modelItemArray removeObject:modelItem];
//                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
//                [self showEmptyLabel:self.tableViewModel.modelItemArray.count == 0];
//            }
//
//        }];
//        [self.navigationController pushViewController:feedItemDetailVC animated:YES];
//    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassZoneItemCell *itemCell = (ClassZoneItemCell *)cell;
    if([itemCell isKindOfClass:[ClassZoneItemCell class]])
        [itemCell setDelegate:self];
}


#pragma mark - ClassZoneItemCellDelegate
- (void)onResponseClickedAtTarget:(ResponseItem *)responseItem cell:(ClassZoneItemCell *)cell
{
    if([[UserCenter sharedInstance].userInfo.uid isEqualToString:responseItem.sendUser.uid])
    {
        ClassZoneItem *zoneItem = (ClassZoneItem *)cell.modelItem;
        TNButtonItem *deleteItem = [TNButtonItem itemWithTitle:@"删除" action:^{
            [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"comment/del" method:REQUEST_POST type:REQUEST_REFRESH withParams:@{@"id" : responseItem.commentItem.commentId,@"feed_id" : zoneItem.itemID, @"types" : @"0"} observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                [ProgressHUD showSuccess:@"删除成功"];
                [zoneItem.responseModel removeResponse:responseItem];
                [self.tableView reloadData];
            } fail:^(NSString *errMsg) {
                [ProgressHUD showHintText:errMsg];
            }];
        }];
        TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消" action:nil];
        TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"删除这条评论?" buttonItems:@[cancelItem, deleteItem]];
        [alertView show];
    }
    else
    {
        self.targetZoneItem = (ClassZoneItem *)cell.modelItem;
        self.targetResponseItem = responseItem;
        [_replyBox setPlaceHolder:[NSString stringWithFormat:@"回复:%@",self.targetResponseItem.sendUser.name]];
        _replyBox.hidden = NO;
        [_replyBox assignFocus];
    }
}

- (void)onActionClicked:(ClassZoneItemCell *)cell
{
    self.targetResponseItem = nil;
    self.targetZoneItem = (ClassZoneItem *)cell.modelItem;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGPoint point = [cell.actionButton convertPoint:CGPointMake(8, cell.actionButton.height / 2) toView:keyWindow];
    __weak typeof(self) wself = self;
    BOOL praised = self.targetZoneItem.responseModel.praised;
    ActionView *actionView = [[ActionView alloc] initWithPoint:point praised:praised action:^(NSInteger index) {
        if(index == 0)
        {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:self.targetZoneItem.itemID forKey:@"feed_id"];
            [params setValue:@"0" forKey:@"types"];
            [params setValue:self.classInfo.classID forKey:@"objid"];
            if(!praised)
            {
                [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"fav/send" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                    if(responseObject.count > 0)
                    {
                        UserInfo *userInfo = [[UserInfo alloc] init];
                        TNDataWrapper *userWrapper = [responseObject getDataWrapperForIndex:0];
                        [userInfo parseData:userWrapper];
                        [wself.targetZoneItem.responseModel addPraiseUser:userInfo];
                        [wself.tableView reloadData];
                    }
                } fail:^(NSString *errMsg) {
                    
                }];
            }
            else
            {
                [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"fav/del" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                    [wself.targetZoneItem.responseModel removePraise];
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
            if(self.targetZoneItem.audioItem)
            {
                [ProgressHUD showHintText:@"努力开发中,敬请期待..."];
            }
            else
            {
                NSString *imageUrl = nil;
                if(self.targetZoneItem.photos.count > 0){
                    PhotoItem *photoitem = [self.targetZoneItem.photos firstObject];
                    imageUrl = photoitem.small;
                }
                if(imageUrl.length == 0)
                    imageUrl = self.classInfo.logo;
                
                NSString *url = [NSString stringWithFormat:@"%@?uid=%@&feed_id=%@",kClassZoneShareUrl,self.targetZoneItem.userInfo.uid,self.targetZoneItem.itemID];
                [ShareActionView shareWithTitle:self.targetZoneItem.content content:nil image:[UIImage imageNamed:@"ClassZone"] imageUrl:imageUrl url:url];
            }
        }
    }];
    [actionView show];
}

- (void)onShowDetail:(ClassZoneItem *)zoneItem
{
    if(!zoneItem.newSent)
    {
        FeedItemDetailVC *feedItemDetailVC = [[FeedItemDetailVC alloc] init];
        [feedItemDetailVC setZoneItem:zoneItem];
        [feedItemDetailVC setClassId:self.classInfo.classID];
        [feedItemDetailVC setDeleteCallBack:^{
            NSInteger index = [self.tableViewModel.modelItemArray indexOfObject:zoneItem];
            if(index >= 0 && index < self.tableViewModel.modelItemArray.count)
            {
                [self.tableViewModel.modelItemArray removeObject:zoneItem];
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                [self showEmptyLabel:self.tableViewModel.modelItemArray.count == 0];
            }
            
        }];
        [self.navigationController pushViewController:feedItemDetailVC animated:YES];
    }
}

- (void)onClassZoneItemDelete:(ClassZoneItem *)item{
    if(!item.newSent)
    {
        TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"保留" action:nil];
        TNButtonItem *confirmItem = [TNButtonItem itemWithTitle:@"删除" action:^{
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setValue:self.classInfo.classID forKey:@"class_id"];
            [params setValue:item.itemID forKey:@"feed_id"];
            [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"class/delete_feed" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
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
        TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"确定删除原创内容?" buttonItems:@[cancelItem,confirmItem]];
        [alertView show];
    }
    else
    {
        
        TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消" action:nil];
        TNButtonItem *confirmItem = [TNButtonItem itemWithTitle:@"删除" action:^{
            [item.operation cancel];
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

#pragma mark - ClassZoneHeaderDelegate

- (void)classZoneAlbumClicked
{
    PhotoFlowVC *photoVC = [[PhotoFlowVC alloc] init];
    [photoVC setShouldShowEmptyHint:YES];
    [photoVC setClassID:self.classInfo.classID];
    [CurrentROOTNavigationVC pushViewController:photoVC animated:YES];
}

#pragma mark - ReplyBoxDelegate
- (void)onActionViewCommit:(NSString *)content
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.targetZoneItem.itemID forKey:@"feed_id"];
    [params setValue:@"0" forKey:@"types"];
    [params setValue:self.classInfo.classID forKey:@"objid"];
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
    [self.targetZoneItem.responseModel addResponse:tmpResponseItem];
    [self.tableView reloadData];
    
    __weak typeof(self) wself = self;
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"comment/send" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        if(responseObject.count > 0)
        {
            TNDataWrapper *commentWrapper  =[responseObject getDataWrapperForIndex:0];
            ResponseItem *responseItem = [[ResponseItem alloc] init];
            [responseItem parseData:commentWrapper];
            NSInteger index = [wself.targetZoneItem.responseModel.responseArray indexOfObject:tmpResponseItem];
            [wself.targetZoneItem.responseModel.responseArray replaceObjectAtIndex:index withObject:responseItem];
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
    self.targetZoneItem = nil;
    [_replyBox setHidden:YES];
    [_replyBox setText:@""];
    [_replyBox resignFocus];
}



#pragma mark - PublishZoneItemDelegate
- (void)publishZoneItemFinished:(ClassZoneItem *)zoneItem
{
    [[ClassZoneManager sharedInstance] addItem:zoneItem];
    [self.tableViewModel.modelItemArray insertObject:zoneItem atIndex:0];
    [self.tableView reloadData];
    [self showEmptyLabel:self.tableViewModel.modelItemArray.count == 0];
    NSString *filePath = [self saveTask:zoneItem];
    zoneItem.savedPath = filePath;
    if([zoneItem canSendDirectly])
        [self startUploading:zoneItem];
    else
    {
        if([ApplicationDelegate.hostReach currentReachabilityStatus] == ReachableViaWiFi || ([ApplicationDelegate.hostReach currentReachabilityStatus] == ReachableViaWWAN && ![UserCenter sharedInstance].personalSetting.wifiSend))
            [self startUploading:zoneItem];
        else
        {
            zoneItem.delay = YES;
            if(([ApplicationDelegate.hostReach currentReachabilityStatus] == ReachableViaWWAN && [UserCenter sharedInstance].personalSetting.wifiSend))
            {
                NSInteger imageNum = 0;
                for (PhotoItem *photoItem in zoneItem.photos) {
                    if(photoItem.image)
                        imageNum ++;
                }
                [ProgressHUD showHintText:[NSString stringWithFormat:@"为了帮您节省流量，您本次分享的%ld张照片将在有wifi环境时自动上传，在此之前请勿删除本地相册中的内容",(long)imageNum]];
            }
        }
    }

}

- (void)publishNewsPaperFinished:(NSString *)newsPaper
{
    ClassZoneModel *zoneModel = (ClassZoneModel *)self.tableViewModel;
    [zoneModel setNewsPaper:newsPaper];
     [_headerView setNewsPaper:newsPaper];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
