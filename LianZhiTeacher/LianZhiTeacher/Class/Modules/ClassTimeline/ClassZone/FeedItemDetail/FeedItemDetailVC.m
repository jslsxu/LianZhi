//
//  FeedItemDetailVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/29.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "FeedItemDetailVC.h"
#import "CollectionImageCell.h"
#import "DetailCommentCell.h"
#import "ShareActionView.h"
#define kInnerMargin                5

@implementation FeedItemDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _avatar = [[AvatarView alloc] initWithFrame:CGRectMake(0, 12, 36, 36)];
        [self addSubview:_avatar];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 15, 0, 15)];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"747474"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"a0a0a0"]];
        [_timeLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_timeLabel];
        
        _deleteButon = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButon setHidden:YES];
        [_deleteButon setFrame:CGRectMake(self.width - 22, 15, 22, 22)];
        [_deleteButon setImage:[UIImage imageNamed:@"ClassZoneTrash"] forState:UIControlStateNormal];
        [_deleteButon addTarget:self action:@selector(onDeleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButon];
        
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 35, _deleteButon.x - 10 - 45, 15)];
        [_addressLabel setTextColor:[UIColor colorWithHexString:@"cacaca"]];
        [_addressLabel setFont:[UIFont systemFontOfSize:12]];
        [_addressLabel setUserInteractionEnabled:YES];
        [self addSubview:_addressLabel];
        
        _addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addressButton addTarget:self action:@selector(onAddressClicked) forControlEvents:UIControlEventTouchUpInside];
        [_addressButton setFrame:_addressLabel.bounds];
        [_addressLabel addSubview:_addressButton];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 55, self.width - 45, 0)];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_contentLabel setFont:[UIFont systemFontOfSize:14]];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self addSubview:_contentLabel];
        
        _voiceButton = [[MessageVoiceButton alloc] initWithFrame:CGRectMake(45, 55, self.width - 45 - 60, 35)];
        [_voiceButton addTarget:self action:@selector(onVoiceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_voiceButton setHidden:YES];
        [self addSubview:_voiceButton];
        
        _spanLabel = [[UILabel alloc] initWithFrame:CGRectMake(_voiceButton.right + 10, 55, 50, 35)];
        [_spanLabel setFont:[UIFont systemFontOfSize:14]];
        [_spanLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [self addSubview:_spanLabel];
        
        NSInteger collectionWidth = self.width - 45;
        NSInteger itemWidth = (collectionWidth - kInnerMargin * 2) / 3;
        NSInteger innerMargin = (collectionWidth - itemWidth * 3) / 2;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake(itemWidth, itemWidth)];
        [layout setMinimumInteritemSpacing:innerMargin];
        [layout setMinimumLineSpacing:innerMargin];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(45, 0, collectionWidth, 0) collectionViewLayout:layout];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setShowsVerticalScrollIndicator:NO];
        [_collectionView registerClass:[CollectionImageCell class] forCellWithReuseIdentifier:@"CollectionImageCell"];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView setScrollsToTop:NO];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [self addSubview:_collectionView];
    }
    return self;
}

- (void)setZoneItem:(ClassZoneItem *)zoneItem
{
    _zoneItem = zoneItem;
    [_avatar setImageWithUrl:[NSURL URLWithString:_zoneItem.userInfo.avatar]];
    [_deleteButon setHidden:!_zoneItem.canEdit];
    [_nameLabel setText:_zoneItem.userInfo.name];
    [_nameLabel sizeToFit];

    [_timeLabel setText:_zoneItem.formatTime];
    [_timeLabel sizeToFit];
    [_timeLabel setOrigin:CGPointMake(_nameLabel.right + 4, _nameLabel.y + (_nameLabel.height - _timeLabel.height) / 2)];
    
    NSInteger spaceYStart = _addressLabel.y;
    if(_zoneItem.position.length > 0)
    {
        [_addressLabel setText:_zoneItem.position];
        spaceYStart = 55;
    }

    NSString *content = _zoneItem.content;
    if(content.length > 0)
    {
        CGSize contentSize = [content boundingRectWithSize:CGSizeMake(_contentLabel.width, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:14]];
        [_contentLabel setSize:CGSizeMake(self.width - 45 - 10, contentSize.height)];
        [_contentLabel setY:spaceYStart];
        [_contentLabel setText:content];
        spaceYStart += contentSize.height + 10;
    }
    [_voiceButton setHidden:YES];
    [_spanLabel setHidden:YES];
    if(_zoneItem.audioItem)
    {
        [_voiceButton setHidden:NO];
        [_spanLabel setHidden:NO];
        [_voiceButton setAudioItem:_zoneItem.audioItem];
        [_voiceButton setY:spaceYStart];
        [_spanLabel setText:[Utility formatStringForTime:_zoneItem.audioItem.timeSpan]];
        [_spanLabel setY:_voiceButton.y];
        
        spaceYStart += _voiceButton.height + 10;
    }
    else
    {
        [_voiceButton setAudioItem:nil];
    }
    [_collectionView setHidden:YES];
    if(_zoneItem.photos.count > 0)
    {
        [_collectionView setHidden:NO];
        NSInteger imageCount = _zoneItem.photos.count;
        NSInteger contentWidth = self.width - 45;
        NSInteger row = (_zoneItem.photos.count + 2) / 3;
        NSInteger itemWidth = (contentWidth - kInnerMargin * 2) / 3;
        NSInteger innerMargin = (contentWidth - itemWidth * 3) / 2;
        NSInteger imageWidth = (row > 1) ? contentWidth : (itemWidth * imageCount + innerMargin * (imageCount - 1));
        [_collectionView setFrame:CGRectMake(45, spaceYStart, imageWidth, itemWidth * row + innerMargin * (row - 1))];
        [_collectionView reloadData];
        spaceYStart += _collectionView.height + 10;
    }
    
    spaceYStart += 10;
    self.height = spaceYStart;
}

- (void)onAddressClicked
{
    if(self.zoneItem.position.length > 0)
    {
        DestinationVC *destinationVC = [[DestinationVC alloc] init];
        [destinationVC setPosition:self.zoneItem.position];
        [destinationVC setLongitude:self.zoneItem.longitude];
        [destinationVC setLatitude:self.zoneItem.latitude];
        [CurrentROOTNavigationVC pushViewController:destinationVC animated:YES];
    }
}

- (void)onDeleteButtonClicked
{
    if(self.deleteCallBack)
        self.deleteCallBack();
}

- (void)onVoiceButtonClicked
{
    [_voiceButton setVoiceWithURL:[NSURL URLWithString:self.zoneItem.audioItem.audioUrl] withAutoPlay:YES];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.zoneItem.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionImageCell" forIndexPath:indexPath];
    [cell setItem:self.zoneItem.photos[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    [photoBrowser setCurrentPhotoIndex:indexPath.row];
    [photoBrowser setPhotos:[NSMutableArray arrayWithArray:self.zoneItem.photos]];
    [CurrentROOTNavigationVC pushViewController:photoBrowser animated:YES];
}
@end

@interface FeedItemDetailVC ()<UITableViewDataSource, UITableViewDelegate, ReplyBoxDelegate>
@property (nonatomic, weak)ResponseItem *targetResponseItem;
@end

@implementation FeedItemDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"详情";
    
    if(self.zoneItem == nil)
    {
        [self requestData];
    }
    else
        [self setup];
}

- (void)setup
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(12, 0, self.view.width - 12 * 2, kScreenHeight - 64 - 50) style:UITableViewStyleGrouped];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:_tableView];
    
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenHeight - 64 - 50, self.view.width, 50)];
    [_toolBar setBackgroundColor:[UIColor whiteColor]];
    [self setupToolBar:_toolBar];
    [self.view addSubview:_toolBar];
    
    __weak typeof(self) wself = self;
    _headerView = [[FeedItemDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 0)];
    [_headerView setZoneItem:self.zoneItem];
    [_headerView setDeleteCallBack:^{
        [wself onDelete];
    }];
    [_tableView setTableHeaderView:_headerView];
    
    _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ResponseUpArrow"]];
    [_arrowImage setOrigin:CGPointMake(20, _headerView.height - _arrowImage.height)];
    [_arrowImage setHidden:YES];
    [_headerView addSubview:_arrowImage];
    
    [_tableView setTableHeaderView:_headerView];
    
    _praiseView = [[PraiseListView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 0)];
    [_praiseView setPraiseArray:self.zoneItem.responseModel.praiseArray];
    
    _replyBox = [[ReplyBox alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - REPLY_BOX_HEIGHT, self.view.width, REPLY_BOX_HEIGHT)];
    [_replyBox setDelegate:self];
    [self.view addSubview:_replyBox];
    _replyBox.hidden = YES;

}

- (void)setupToolBar:(UIView *)viewParent
{
    [_buttonItems makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if(_buttonItems == nil)
        _buttonItems = [NSMutableArray array];
    else
        [_buttonItems removeAllObjects];
    
    [viewParent setBackgroundColor:[UIColor whiteColor]];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewParent.width, kLineHeight)];
    [topLine setBackgroundColor:[UIColor colorWithHexString:@"d7d7d7"]];
    [viewParent addSubview:topLine];
    NSArray *titleArray = @[@"赞",@"评论",@"分享"];
    NSArray *imageArray = @[@"DetailPraise",@"DetailResponse",@"DetailShare"];
    CGFloat tabWidth = self.view.width / titleArray.count;
    for (NSInteger i = 0; i < titleArray.count; i++)
    {
        LZTabBarButton *barButton = [[LZTabBarButton alloc] initWithFrame:CGRectMake(tabWidth * i, 0, tabWidth, viewParent.height)];
        [barButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [barButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [barButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [barButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateHighlighted];
        [barButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Normal",imageArray[i]]] forState:UIControlStateNormal];
        [barButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Highlighted",imageArray[i]]] forState:UIControlStateSelected];
        [barButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Highlighted",imageArray[i]]] forState:UIControlStateHighlighted];
        [barButton addTarget:self action:@selector(onToolBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [viewParent addSubview:barButton];
        [_buttonItems addObject:barButton];
        
        if(i == 0)
        {
            BOOL praised = [self.zoneItem.responseModel praised];
            [barButton setSelected:praised];
            [barButton setTitle:praised ? @"取消" : @"赞" forState:UIControlStateNormal];
        }
    }
}

- (void)requestData
{
    __weak typeof(self) wself = self;
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"class/detail" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"class_id":self.classId,@"feed_id" : self.messageItem.feedItem.feedID} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject)
    {
        if(responseObject.count > 0)
        {
            TNDataWrapper *dataWrapper = [responseObject getDataWrapperForIndex:0];
            ClassZoneItem *zoneItem = [[ClassZoneItem alloc] init];
            [zoneItem parseData:dataWrapper];
            wself.zoneItem = zoneItem;
            [wself setup];
        }
    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)onDelete
{
    TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"保留" action:nil];
    TNButtonItem *confirmItem = [TNButtonItem itemWithTitle:@"删除" action:^{
        MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:[UIApplication sharedApplication].keyWindow];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:self.classId forKey:@"class_id"];
        [params setValue:self.zoneItem.itemID forKey:@"feed_id"];
        __weak typeof(self) wself = self;
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"class/delete_feed" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [hud hide:NO];
            [ProgressHUD showHintText:@"删除成功"];
            if(wself.deleteCallBack)
                wself.deleteCallBack();
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wself.navigationController popViewControllerAnimated:YES];
            });
        } fail:^(NSString *errMsg) {
            [hud hide:NO];
            [ProgressHUD showHintText:errMsg];
        }];
    }];
    TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"确定删除原创内容?" buttonItems:@[cancelItem,confirmItem]];
    [alertView show];
}

- (void)onToolBarButtonClicked:(UIButton *)button
{
    NSInteger index = [_buttonItems indexOfObject:button];
    if(index == 0)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:@"0" forKey:@"types"];
        [params setValue:self.classId forKey:@"objid"];
        [params setValue:self.zoneItem.itemID forKey:@"feed_id"];
        BOOL praised = [self.zoneItem.responseModel praised];
        
        __weak typeof(self) wself = self;
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:praised ? @"fav/del" : @"fav/send" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            if(praised)//取消成功
            {
                [wself.zoneItem.responseModel removePraise];
                [_praiseView setPraiseArray:wself.zoneItem.responseModel.praiseArray];
                [_tableView reloadData];
                [wself setupToolBar:_toolBar];
            }
            else
            {
                if(responseObject.count > 0)
                {
                    UserInfo *userInfo = [[UserInfo alloc] init];
                    TNDataWrapper *userWrapper = [responseObject getDataWrapperForIndex:0];
                    [userInfo parseData:userWrapper];
                    [wself.zoneItem.responseModel addPraiseUser:userInfo];
                    [_praiseView setPraiseArray:wself.zoneItem.responseModel.praiseArray];
                    [_tableView reloadData];
                    [wself setupToolBar:_toolBar];
                }
            }
        } fail:^(NSString *errMsg) {
            [ProgressHUD showHintText:errMsg];
        }];
    }
    else if(index == 1)
    {
        _replyBox.hidden = NO;
        [_replyBox assignFocus];
    }
    else
    {
        NSString *imageUrl = nil;
        if(self.zoneItem.photos.count > 0)
            imageUrl = [self.zoneItem.photos[0] thumbnailUrl];
        [ShareActionView shareWithTitle:self.zoneItem.content content:nil image:nil imageUrl:imageUrl url:kTeacherClientAppStoreUrl];
    }
}

#pragma mark - ReplyBoxDelegate
- (void)onActionViewCommit:(NSString *)content
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.zoneItem.itemID forKey:@"feed_id"];
    [params setValue:@"0" forKey:@"types"];
    [params setValue:self.classId forKey:@"objid"];
    if(self.targetResponseItem)
    {
        [params setValue:self.targetResponseItem.sendUser.uid forKey:@"to_uid"];
        [params setValue:self.targetResponseItem.commentItem.commentId forKey:@"comment_id"];
    }
    [params setValue:content forKey:@"content"];
    __weak typeof(self) wself = self;
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"comment/send" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        if(responseObject.count > 0)
        {
            TNDataWrapper *commentWrapper  =[responseObject getDataWrapperForIndex:0];
            ResponseItem *responseItem = [[ResponseItem alloc] init];
            [responseItem parseData:commentWrapper];
            [wself.zoneItem.responseModel addResponse:responseItem];
            [_praiseView setPraiseArray:wself.zoneItem.responseModel.praiseArray];
            [_tableView reloadData];
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


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger responseCount = self.zoneItem.responseModel.responseArray.count;
    [_arrowImage setHidden:responseCount + self.zoneItem.responseModel.praiseArray.count == 0];
    return responseCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResponseItem *item = self.zoneItem.responseModel.responseArray[indexPath.row];
    return [DetailCommentCell cellHeight:item cellWidth:tableView.width].floatValue;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _praiseView.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _praiseView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"CommentCell";
    DetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[DetailCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    [cell setResponseItem:self.zoneItem.responseModel.responseArray[indexPath.row]];
    [cell setClips:indexPath.row == 0 && self.zoneItem.responseModel.praiseArray.count == 0];
    if(indexPath.row == 0)
        [cell setCellType:TableViewCellTypeFirst];
    else
        [cell setCellType:TableViewCellTypeAny];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ResponseItem *responseItem = self.zoneItem.responseModel.responseArray[indexPath.row];
    if([[UserCenter sharedInstance].userInfo.uid isEqualToString:responseItem.sendUser.uid])
    {
        __weak typeof(self) wself = self;
        TNButtonItem *deleteItem = [TNButtonItem itemWithTitle:@"删除" action:^{
            [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"comment/del" method:REQUEST_POST type:REQUEST_REFRESH withParams:@{@"id" : responseItem.commentItem.commentId,@"feed_id" : self.zoneItem.itemID, @"types" : @"0"} observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                [ProgressHUD showHintText:@"删除成功"];
                [wself.zoneItem.responseModel removeResponse:responseItem];
                [_praiseView setPraiseArray:wself.zoneItem.responseModel.praiseArray];
                [_tableView reloadData];
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
        self.targetResponseItem = responseItem;
        [_replyBox setPlaceHolder:[NSString stringWithFormat:@"回复:%@",self.targetResponseItem.sendUser.name]];
        _replyBox.hidden = NO;
        [_replyBox assignFocus];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
