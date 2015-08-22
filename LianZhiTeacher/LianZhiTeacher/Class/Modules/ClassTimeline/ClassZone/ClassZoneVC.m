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

#define kClassZoneShown         @"ClassZoneShown"

NSString *const kPublishPhotoItemFinishedNotification = @"PublishPhotoItemFinishedNotification";
NSString *const kPublishPhotoItemKey = @"PublishPhotoItemKey";

@implementation ClassZoneHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor colorWithRed:19 / 255.0 green:48 / 255.0 blue:43 / 255.0 alpha:1.f]];
        
        CGFloat buttonWidth = 40;
        _albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_albumButton addTarget:self action:@selector(onAlbumButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_albumButton setImage:[UIImage imageNamed:(@"ClassAlbum.png")] forState:UIControlStateNormal];
        [_albumButton setFrame:CGRectMake(self.width - buttonWidth, self.height - 60 - buttonWidth, buttonWidth, buttonWidth)];
        [self addSubview:_albumButton];
        
        _newpaperImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(@"BlackboardText.png")]];
        [_newpaperImageView setOrigin:CGPointMake(20, 10)];
        [self addSubview:_newpaperImageView];
        
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 25, self.width - 30 - 40, self.height - 30 - 25)];
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
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onContentTap:)];
        [_brashImage addGestureRecognizer:tapGesture];
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 12, self.width, 12)];
        [_bottomView setBackgroundColor:[UIColor colorWithRed:158 / 255.0 green:158 / 255.0 blue:158 / 255.0 alpha:1.f]];
        [self addSubview:_bottomView];
    }
    return self;
}

- (void)setNewsPaper:(NSString *)newsPaper
{
    _newsPaper = newsPaper;
    [_contentLabel setText:_newsPaper];
}

- (void)onContentTap:(UITapGestureRecognizer *)tapGesture
{
    if([self.delegate respondsToSelector:@selector(classNewspaperClicked)])
        [self.delegate classNewspaperClicked];
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

@end

@interface ClassZoneVC ()<PublishSelectDelegate>
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
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL classOperationShow = [[userDefaults valueForKey:kClassZoneShown] boolValue];
    if(classOperationShow == NO)
    {
        [self addUserGuide];
        classOperationShow = YES;
        [userDefaults setValue:@(classOperationShow) forKey:kClassZoneShown];
        [userDefaults synchronize];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurSchoolChanged) name:kUserCenterChangedSchoolNotification object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"切换班级" style:UIBarButtonItemStylePlain target:self action:@selector(onExchangeClass)];
    
//    self.title = @"班空间";
    self.shouldShowEmptyHint = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onClassZoneDeleteItemNotification:) name:kClassZoneItemDeleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkStatusChanged) name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkStatusChanged) name:kPersonalSettingChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkStatusChanged) name:UIApplicationDidBecomeActiveNotification object:nil];
    //上传成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kTaskItemSuccessNotification object:nil];
}

- (void)setupSubviews
{
    _publishToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.height - 49, self.view.width, 49)];
    [self setupToolBar:_publishToolBar];
    [self.view addSubview:_publishToolBar];
    
    ClassInfo *curClassInfo = [UserCenter sharedInstance].curSchool.classes[0];
    [self setClassInfo:curClassInfo];
    
    [self.tableView setHeight:self.view.height - 49];
    
    _headerView = [[ClassZoneHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 160)];
    [_headerView setDelegate:self];
    [self.tableView setTableHeaderView:_headerView];
    
    [self bindTableCell:@"ClassZoneItemCell" tableModel:@"ClassZoneModel"];
    [self setSupportPullDown:YES];
    [self setSupportPullUp:YES];
    if(self.classInfo)
        [self requestData:REQUEST_REFRESH];

    ClassZoneModel *model = (ClassZoneModel *)self.tableViewModel;
    [model setClassID:self.classInfo.classID];

}


- (void)setupToolBar:(UIView *)viewParent
{
    if(_buttonItems == nil)
        _buttonItems = [NSMutableArray array];
    else
        [_buttonItems removeAllObjects];
    NSArray *titleArray = @[@"发文字",@"发照片",@"发语音",@"编辑板报"];
    NSArray *imageArray = @[@"PostText",@"PostPhoto",@"PostAudio",@"EditBlackBoard"];
    CGFloat tabWidth = self.view.width / titleArray.count;
    for (NSInteger i = 0; i < 4; i++)
    {
        LZTabBarButton *barButton = [[LZTabBarButton alloc] initWithFrame:CGRectMake(tabWidth * i, 0, tabWidth, viewParent.height)];
        [barButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [barButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [barButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateHighlighted];
        [barButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Normal",imageArray[i]]] forState:UIControlStateNormal];
        [barButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Highlighted",imageArray[i]]] forState:UIControlStateHighlighted];
        [barButton addTarget:self action:@selector(onToolBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [viewParent addSubview:barButton];
        [_buttonItems addObject:barButton];
    }
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

- (void)onExchangeClass
{
    
}

- (void)onToolBarButtonClicked:(UIButton *)button
{
    NSInteger index = [_buttonItems indexOfObject:button];
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
    TNBaseNavigationController *navVC = [[TNBaseNavigationController alloc] initWithRootViewController:publishVC];
    [CurrentROOTNavigationVC presentViewController:navVC animated:YES completion:^{
        
    }];
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




- (void)onClassZoneDeleteItemNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    ClassZoneItem *item = (ClassZoneItem *)[userInfo objectForKey:kClassZoneItemDeleteKey];
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
        TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"确定删除原创内容?" buttonItems:@[confirmItem, cancelItem]];
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

- (void)TNBaseTableViewControllerRequestSuccess
{
    NSString *newsPaper = [(ClassZoneModel *)self.tableViewModel newsPaper];
    if(newsPaper.length == 0)
        newsPaper = [NSString stringWithFormat:@"热烈庆祝我们班率先引用连枝APP智能客户端这里是我们 %@ 的掌上根据地。就让我们一起努力经营好这个大家庭吧",self.classInfo.className];
    [_headerView setNewsPaper:newsPaper];
}

- (void)setClassInfo:(ClassInfo *)classInfo
{
    _classInfo = classInfo;
    [self setTitle:_classInfo.className];
    ClassZoneModel *model = (ClassZoneModel *)self.tableViewModel;
    [model setClassID:self.classInfo.classID];
    [self loadCache];
    [self requestData:REQUEST_REFRESH];
}

#pragma mark - ClassZoneHeaderDelegate

- (void)classZoneAlbumClicked
{
    PhotoFlowVC *photoVC = [[PhotoFlowVC alloc] init];
    [photoVC setShouldShowEmptyHint:YES];
    [photoVC setClassID:self.classInfo.classID];
    [CurrentROOTNavigationVC pushViewController:photoVC animated:YES];
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
