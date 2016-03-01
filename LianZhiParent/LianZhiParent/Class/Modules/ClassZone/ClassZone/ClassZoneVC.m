//
//  ClassZoneVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "ClassZoneVC.h"
#import "ClassAlbumVC.h"
#import "ActionView.h"
#import "SwitchClassVC.h"
#import "NewMessageVC.h"
#import "FeedItemDetailVC.h"
#define kClassZoneShown                         @"ClassZoneShown"

@implementation ClassZoneHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        [bgView setBackgroundColor:[UIColor colorWithHexString:@"173e39"]];
        [self addSubview:bgView];
        
//        CGFloat buttonWidth = 40;
//        _albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_albumButton addTarget:self action:@selector(onAlbumButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//        [_albumButton setImage:[UIImage imageNamed:@"ZoneAlbum"] forState:UIControlStateNormal];
//        [_albumButton setFrame:CGRectMake(self.width - buttonWidth, self.height - 40 - buttonWidth, buttonWidth, buttonWidth)];
//        [self addSubview:_albumButton];
        
//        _appButton = [[LZTabBarButton alloc] init];
//        [_appButton addTarget:self action:@selector(onAppButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//        [_appButton setImage:[UIImage imageNamed:@"ZoneApp"] forState:UIControlStateNormal];
//        [_appButton setFrame:CGRectMake(self.width - buttonWidth, _albumButton.top - buttonWidth, buttonWidth, buttonWidth)];
//        [self addSubview:_appButton];
        
        _newpaperImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BlackboardText.png"]];
        [_newpaperImageView setOrigin:CGPointMake(20, 10)];
        [self addSubview:_newpaperImageView];
        
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, self.width - 30 - 30, self.height - 30 - 30)];
        [_contentLabel setUserInteractionEnabled:YES];
        [_contentLabel setTextColor:[UIColor whiteColor]];
        [_contentLabel setFont:[UIFont systemFontOfSize:16]];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self addSubview:_contentLabel];
        
        _brashImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Brash.png"]];
        [_brashImage setFrame:CGRectMake(15, frame.size.height - 12 - _brashImage.height, _brashImage.width, _brashImage.height)];
        [self addSubview:_brashImage];
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 12, self.width, 12)];
        [_bottomView setBackgroundColor:[UIColor colorWithRed:158 / 255.0 green:158 / 255.0 blue:158 / 255.0 alpha:1.f]];
        [self addSubview:_bottomView];
        
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
    BOOL hide = _commentItem == nil || _commentItem.alertInfo.num == 0;
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
    //    [_contentLabel sizeToFit];
}

- (void)onAlbumButtonClicked
{
    if([self.delegate respondsToSelector:@selector(classZoneAlbumClicked)])
        [self.delegate classZoneAlbumClicked];
}

- (void)onAppButtonClicked
{
    if([self.delegate respondsToSelector:@selector(classZoneAppClicked)])
        [self.delegate classZoneAppClicked];
}

- (void)onNewMessageClicked
{
    _msgIndicator.hidden = YES;
    if([self.delegate respondsToSelector:@selector(classNewCommentClicked)])
        [self.delegate classNewCommentClicked];
}

@end

@interface ClassZoneVC ()<ClassZoneItemCellDelegate>
@property (nonatomic, strong)ClassZoneItem *targetClassZoneItem;
@property (nonatomic, strong)ResponseItem *targetResponseItem;
@end

@implementation ClassZoneVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
//    self.title = @"班空间";
    self.shouldShowEmptyHint = YES;
//    _switchView = [[ClassZoneClassSwitchView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
//    [_switchView setCurChild:[UserCenter sharedInstance].curChild];
//    [_switchView setDelegate:self];
//    [self.view addSubview:_switchView];
//    [self.tableView setFrame:CGRectMake(0, _switchView.bottom, self.view.width, self.view.height - _switchView.bottom)];
//    [self onCurChildChanged];
    
    _headerView = [[ClassZoneHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 160)];
    [_headerView setDelegate:self];
    [self.tableView setTableHeaderView:_headerView];
    
    [self bindTableCell:@"ClassZoneItemCell" tableModel:@"ClassZoneModel"];
    [self setSupportPullDown:YES];
    [self setSupportPullUp:YES];
    [self requestData:REQUEST_REFRESH];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurChildChanged) name:kUserCenterChangedCurChildNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStatusChanged) name:kStatusChangedNotification object:nil];
    
    _replyBox = [[ReplyBox alloc] initWithFrame:CGRectMake(0, kScreenHeight - REPLY_BOX_HEIGHT, self.view.width, REPLY_BOX_HEIGHT)];
    [_replyBox setDelegate:self];
    [[UIApplication sharedApplication].keyWindow addSubview:_replyBox];
    _replyBox.hidden = YES;
}

- (void)addUserGuide
{
    UIView *parentView = [UIApplication sharedApplication].keyWindow;
    
    UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [coverButton addTarget:self action:@selector(onCoverButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [coverButton setFrame:parentView.bounds];
    [coverButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [parentView addSubview:coverButton];
    
    UIImageView *image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ClassZoneGuide1.png"]];
    [image1 setOrigin:CGPointMake(coverButton.width - image1.width - 10, 180)];
    [coverButton addSubview:image1];
    
    UIImageView *image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ClassZoneSwipe.png"]];
    [image2 setOrigin:CGPointMake((self.view.width - image2.width) / 2, image1.bottom + 100)];
    [coverButton addSubview:image2];
}

- (void)onCoverButtonClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [button removeFromSuperview];
}


- (void)onStatusChanged
{
    NSArray *commentArray = [UserCenter sharedInstance].statusManager.classNewCommentArray;
    TimelineCommentItem *curAlert = nil;
    for (TimelineCommentItem *alertInfo in commentArray)
    {
        if([alertInfo.objid isEqualToString:self.classInfo.classID])
        {
            curAlert = alertInfo;
        }
    }
    [_headerView setCommentItem:curAlert];
    [_tableView setTableHeaderView:_headerView];
    
}

//- (void)onCurChildChanged
//{
//    if([UserCenter sharedInstance].curChild.classes.count > 0)
//    {
//        ClassInfo *curClassInfo = [UserCenter sharedInstance].curChild.classes[0];
//        [self setClassInfo:curClassInfo];
//        [self requestData:REQUEST_REFRESH];
//    }
//    else
//    {
//        TNButtonItem *item = [TNButtonItem itemWithTitle:@"确定" action:nil];
//        TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"未找到相关班级，请联系学校教师或直接联系客服人员" buttonItems:@[item]];
//        [alertView show];
//    }
//}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"class/space"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    [task setObserver:self];
    
    ClassZoneModel *model = (ClassZoneModel *)self.tableViewModel;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    if(requestType == REQUEST_GETMORE)
        [params setValue:@"old" forKey:@"mode"];
    else
        [params setValue:@"new" forKey:@"mode"];
    [params setValue:model.minID forKey:@"min_id"];
    [params setValue:self.classInfo.classID forKey:@"class_id"];
    
    [params setValue:@(20) forKey:@"num"];
    [task setParams:params];
    return task;
}

#pragma mark - ClassZoneItemCellDelegate
- (void)onResponseClickedAtTarget:(ResponseItem *)responseItem cell:(ClassZoneItemCell *)cell
{
    if([[UserCenter sharedInstance].userInfo.uid isEqualToString:responseItem.sendUser.uid])
    {
        ClassZoneItem *zoneItem = (ClassZoneItem *)cell.modelItem;
        TNButtonItem *deleteItem = [TNButtonItem itemWithTitle:@"删除评论" action:^{
            [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"comment/del" method:REQUEST_POST type:REQUEST_REFRESH withParams:@{@"id" : responseItem.commentItem.commentId,@"feed_id" : zoneItem.itemID, @"types" : @"0"} observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                [ProgressHUD showSuccess:@"删除成功"];
                [zoneItem.responseModel removeResponse:responseItem];
                [self.tableView reloadData];
            } fail:^(NSString *errMsg) {
                [ProgressHUD showHintText:errMsg];
            }];
        }];
        TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消返回" action:nil];
        TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"删除这条评论?" buttonItems:@[cancelItem, deleteItem]];
        [alertView show];
    }
    else
    {
        [_replyBox setPlaceHolder:[NSString stringWithFormat:@"回复:%@",self.targetResponseItem.sendUser.name]];
        _replyBox.hidden = NO;
        [_replyBox assignFocus];
        
        self.targetClassZoneItem = (ClassZoneItem *)cell.modelItem;
        self.targetResponseItem = responseItem;
    }
}

- (void)onActionClicked:(ClassZoneItemCell *)cell
{
    self.targetClassZoneItem = (ClassZoneItem *)cell.modelItem;
    self.targetResponseItem = nil;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGPoint point = [cell.actionButton convertPoint:CGPointMake(10, cell.actionButton.height / 2) toView:keyWindow];
    __weak typeof(self) wself = self;
    BOOL praised = self.targetClassZoneItem.responseModel.praised;
    ActionView *actionView = [[ActionView alloc] initWithPoint:point praised:praised action:^(NSInteger index) {
        if(index == 0)
        {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:self.targetClassZoneItem.itemID forKey:@"feed_id"];
            [params setValue:@"0" forKey:@"types"];
            [params setValue:[UserCenter sharedInstance].curChild.uid forKey:@"objid"];
            if(!praised)
            {
                [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"fav/send" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                    if(responseObject.count > 0)
                    {
                        UserInfo *userInfo = [[UserInfo alloc] init];
                        TNDataWrapper *userWrapper = [responseObject getDataWrapperForIndex:0];
                        [userInfo parseData:userWrapper];
                        [wself.targetClassZoneItem.responseModel addPraiseUser:userInfo];
                        [wself.tableView reloadData];
                    }
                } fail:^(NSString *errMsg) {
                    
                }];
            }
            else
            {
                [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"fav/del" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                    [wself.targetClassZoneItem.responseModel removePraise];
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
            if(self.targetClassZoneItem.audioItem)
            {
                [ProgressHUD showHintText:@"努力开发中,敬请期待..."];
                return;
            }
            NSString *imageUrl = nil;
            if(self.targetClassZoneItem.photos.count > 0)
                imageUrl = [self.targetClassZoneItem.photos[0] thumbnailUrl];
            NSString *url = [NSString stringWithFormat:@"%@?uid=%@&feed_id=%@",kClassZoneShareUrl,self.targetClassZoneItem.userInfo.uid,self.targetClassZoneItem.itemID];
            [ShareActionView shareWithTitle:self.targetClassZoneItem.content content:nil image:[UIImage imageNamed:@"ClassZone"] imageUrl:imageUrl url:url];
        }
    }];
    [actionView show];
}

- (void)onShowDetail:(ClassZoneItem *)zoneItem
{
    FeedItemDetailVC *itemDetailVC = [[FeedItemDetailVC alloc] init];
    [itemDetailVC setZoneItem:zoneItem];
    [self.navigationController pushViewController:itemDetailVC animated:YES];
}

- (void)onShareToTreeHouse:(ClassZoneItem *)zoneItem
{
    PublishBaseVC *publishVC = [[PublishBaseVC alloc] init];
    if(zoneItem.photos.count > 0)
    {
        PublishPhotoVC *publishPhotoVC = [[PublishPhotoVC alloc] init];
        [publishPhotoVC setWords:zoneItem.content];
        NSMutableArray *photoArray = [NSMutableArray array];
        for (NSInteger i = 0; i < zoneItem.photos.count; i++)
        {
            PhotoItem *photoItem = zoneItem.photos[i];
            PublishImageItem *publishImageItem = [[PublishImageItem alloc] init];
            [publishImageItem setPhotoID:photoItem.photoID];
            [publishImageItem setThumbnailUrl:photoItem.thumbnailUrl];
            [publishImageItem setOriginalUrl:photoItem.originalUrl];
            [photoArray addObject:publishImageItem];
        }
        [publishPhotoVC setOriginalImageArray:photoArray];
        [publishPhotoVC setDelegate:ApplicationDelegate.homeVC.treeHouseVC];
        
        publishVC = publishPhotoVC;
    }
    else if(zoneItem.audioItem)
    {
        AudioItem *audioItem = zoneItem.audioItem;
        PublishAudioVC *publishAudioVC = [[PublishAudioVC alloc] init];
        [publishAudioVC setWords:zoneItem.content];
        [publishAudioVC setDuration:audioItem.timeSpan];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:audioItem.audioUrl]];
        [request setTimeoutInterval:10];
         NSData* data = [[MLDataCache shareInstance] cachedDataForRequest:request];
        if(data == nil)
        {
            MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:[UIApplication sharedApplication].keyWindow];
             static MLPlayVoiceButton *button = nil;
            if(button == nil)
                button = [[MLPlayVoiceButton alloc] init];
            [button setVoiceWithURL:[NSURL URLWithString:audioItem.audioUrl] success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSURL *voicePath) {
                [hud hide:NO];
                NSData *amrData = [[MLDataCache shareInstance] cachedDataForRequest:request];
                PublishAudioVC *publishAudioVC = [[PublishAudioVC alloc] init];
                [publishAudioVC setWords:zoneItem.content];
                [publishAudioVC setDuration:audioItem.timeSpan];
                [publishAudioVC setAmrData:amrData];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:publishAudioVC];
                [CurrentROOTNavigationVC presentViewController:nav animated:YES completion:nil];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                [hud hide:NO];
            }];
            return;
        }
        else
        {
            [publishAudioVC setAmrData:data];
            publishVC = publishAudioVC;
        }
    }
    else
    {
        PublishArticleVC *publishArticleVC = [[PublishArticleVC alloc] init];
        [publishArticleVC setWords:zoneItem.content];
        
        publishVC = publishArticleVC;
    }
    if(zoneItem.position.length > 0)
    {
        AMapPOI *poiInfo = [[AMapPOI alloc] init];
        AMapGeoPoint *location = [AMapGeoPoint locationWithLatitude:zoneItem.latitude longitude:zoneItem.longitude];
        [poiInfo setName:zoneItem.position];
        [poiInfo setLocation:location];
        POIItem *poiItem = [[POIItem alloc] init];
        [poiItem setPoiInfo:poiInfo];
        
        [publishVC setPoiItem:poiItem];
    }
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:publishVC];
    [CurrentROOTNavigationVC presentViewController:nav animated:YES completion:nil];
}

#pragma mark TNBaseTableViewController
- (BOOL)supportCache
{
    return YES;
}

- (NSString *)cacheFileName
{
    return [NSString stringWithFormat:@"%@_%@_%@",NSStringFromClass([self class]),[UserCenter sharedInstance].curChild.uid,self.classInfo.classID];
}


//#pragma mark - ClassZoneSwitchDelegate
//- (void)classZoneSwitch
//{
//    __weak typeof(self) wself = self;
//    SwitchClassVC *switchClassVC = [[SwitchClassVC alloc] init];
//    [switchClassVC setClassInfo:self.classInfo];
//    [switchClassVC setCompletion:^(ClassInfo *classInfo) {
//        wself.classInfo = classInfo;
//        [wself requestData:REQUEST_REFRESH];
//    }];
//    [self.navigationController pushViewController:switchClassVC animated:YES];
//}
#pragma mark - ClassZoneHeaderDelegate
- (void)classZoneAlbumClicked
{
    ClassAlbumVC *photoBrowser = [[ClassAlbumVC alloc] init];
    [photoBrowser setShouldShowEmptyHint:YES];
    [photoBrowser setClassID:self.classInfo.classID];
    [self.navigationController pushViewController:photoBrowser animated:YES];
}

- (void)classZoneAppClicked
{
//    ClassAppVC *appVC = [[ClassAppVC alloc] init];
//    [appVC setClassInfo:self.classInfo];
//    [CurrentROOTNavigationVC pushViewController:appVC animated:YES];
}

- (void)classNewCommentClicked
{
    NewMessageVC *newMessageVC = [[NewMessageVC alloc] init];
    [newMessageVC setTypes:NewMessageTypeClassZone];
//    [newMessageVC setObjid:[UserCenter sharedInstance].curChild.uid];
    [newMessageVC setObjid:self.classInfo.classID];
    [CurrentROOTNavigationVC pushViewController:newMessageVC animated:YES];
}

#pragma mark - ReplyBoxDelegate
- (void)onActionViewCommit:(NSString *)content
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.targetClassZoneItem.itemID forKey:@"feed_id"];
    [params setValue:@"0" forKey:@"types"];
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
    [self.targetClassZoneItem.responseModel addResponse:tmpResponseItem];
    [self.tableView reloadData];

    
    __weak typeof(self) wself = self;
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"comment/send" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        if(responseObject.count > 0)
        {
            TNDataWrapper *commentWrapper  =[responseObject getDataWrapperForIndex:0];
            ResponseItem *responseItem = [[ResponseItem alloc] init];
            [responseItem parseData:commentWrapper];
            NSInteger index = [wself.targetClassZoneItem.responseModel.responseArray indexOfObject:tmpResponseItem];
            [wself.targetClassZoneItem.responseModel.responseArray replaceObjectAtIndex:index withObject:responseItem];

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

#pragma mark TNbaseViewControllerDelegate
- (void)TNBaseTableViewControllerRequestSuccess
{
    NSString *newsPaper = [(ClassZoneModel *)self.tableViewModel newsPaper];
    [_headerView setNewsPaper:newsPaper];
    [self onStatusChanged];
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath
{
//    ClassZoneItem *item = (ClassZoneItem *)modelItem;
//    FeedItemDetailVC *itemDetailVC = [[FeedItemDetailVC alloc] init];
//    [itemDetailVC setZoneItem:item];
//    [self.navigationController pushViewController:itemDetailVC animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassZoneItemCell *itemCell = (ClassZoneItemCell *)cell;
    if([itemCell respondsToSelector:@selector(setDelegate:)])
        [itemCell setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
