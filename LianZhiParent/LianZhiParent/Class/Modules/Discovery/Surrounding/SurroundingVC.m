//
//  SurroundingVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/5/27.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "SurroundingVC.h"
#import "FeedItemDetailVC.h"
#import "TreeHouseItemDetailVC.h"
#define kInnerMargin                    8
#define kImageLeftMargin                55
#define kImageRightMargin               20
@implementation SurroundingCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _avatar = [[AvatarView alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
        [self addSubview:_avatar];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatar.right + 10, 10, 0, 15)];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [self addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setFont:[UIFont systemFontOfSize:12]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"a0a0a0"]];
        [self addSubview:_timeLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setFont:[UIFont systemFontOfSize:14]];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [self addSubview:_contentLabel];
        
        _voiceButton = [[MessageVoiceButton alloc] initWithFrame:CGRectMake(kImageLeftMargin, 0, self.width - kImageLeftMargin - 10 - 60, 40)];
        [_voiceButton addTarget:self action:@selector(onVoiceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_voiceButton];
        
        _spanLabel = [[UILabel alloc] initWithFrame:CGRectMake(_voiceButton.right, _voiceButton.y, 60, 40)];
        [_spanLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [_spanLabel setFont:[UIFont systemFontOfSize:14]];
        [_spanLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_spanLabel];
        
        NSInteger collectionWidth = self.width - kImageLeftMargin - kImageRightMargin;
        NSInteger itemWidth = (collectionWidth - kInnerMargin * 2) / 3;
        NSInteger innerMargin = (collectionWidth - itemWidth * 3) / 2;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake(itemWidth, itemWidth)];
        [layout setMinimumInteritemSpacing:innerMargin];
        [layout setMinimumLineSpacing:innerMargin];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setShowsVerticalScrollIndicator:NO];
        [_collectionView setScrollsToTop:NO];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView registerClass:[CollectionImageCell class] forCellWithReuseIdentifier:@"CollectionImageCell"];
        [self addSubview:_collectionView];
        
        _addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addressButton setBackgroundImage:[[UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.5] size:CGSizeMake(10, 10)] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)] forState:UIControlStateHighlighted];
        [_addressButton addTarget:self action:@selector(onAddressClicked) forControlEvents:UIControlEventTouchUpInside];
        [_addressButton setTitleColor:[UIColor colorWithHexString:@"9a9a9a"] forState:UIControlStateNormal];
        [_addressButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_addressButton];
        
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionButton setImage:[UIImage imageNamed:@"TimelineAction"] forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(onActionClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_actionButton];
        
        _responseView = [[ResponseView alloc] initWithFrame:CGRectMake(kImageLeftMargin, 0, self.width - kImageLeftMargin - 10, 0)];
        [_responseView setDelegate:self];
        [self addSubview:_responseView];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectZero];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];

    }
    return self;
}

- (void)onVoiceButtonClicked
{
    TreehouseItem *item = (TreehouseItem *)self.modelItem;
    [_voiceButton setVoiceWithURL:[NSURL URLWithString:item.audioItem.audioUrl] withAutoPlay:YES];
}

- (void)onActionClicked
{
    if([self.delegate respondsToSelector:@selector(onActionClicked:)])
    {
        [self.delegate onActionClicked:self];
    }
}

- (void)onDetailClicked
{
    if([self.delegate respondsToSelector:@selector(onShowDetail:)])
        [self.delegate onShowDetail:(TreehouseItem *)self.modelItem];
}

- (void)onAddressClicked
{
    TreehouseItem *item = (TreehouseItem *)self.modelItem;
    if(item.position.length > 0)
    {
//        DestinationVC *destinationVC = [[DestinationVC alloc] init];
//        [destinationVC setPosition:item.position];
//        [destinationVC setLongitude:item.longitude];
//        [destinationVC setLatitude:item.latitude];
//        [CurrentROOTNavigationVC pushViewController:destinationVC animated:YES];
    }
}

#pragma mark -ResponseDelegate
- (void)onResponseItemClicked:(ResponseItem *)responseItem
{
    if([self.delegate respondsToSelector:@selector(onResponseClickedAtTarget: cell:)])
        [self.delegate onResponseClickedAtTarget:responseItem cell:self];
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    TreehouseItem *item = (TreehouseItem *)self.modelItem;
    return item.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionImageCell" forIndexPath:indexPath];
    TreehouseItem *item = (TreehouseItem *)self.modelItem;
    [cell setItem:item.photos[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TreehouseItem *item = (TreehouseItem *)self.modelItem;
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    [photoBrowser setBrowserType:PhotoBrowserTypeZone];
    NSMutableArray *photos = [NSMutableArray arrayWithArray:item.photos];
    for (PhotoItem *photoItem in photos) {
        [photoItem setUser:item.user];
        [photoItem setWords:item.detail];
        [photoItem setTime_str:item.timeStr];
    }
    [photoBrowser setPhotos:photos];
    [photoBrowser setCurrentPhotoIndex:indexPath.row];
    [CurrentROOTNavigationVC pushViewController:photoBrowser animated:YES];
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    TreehouseItem *item = (TreehouseItem *)self.modelItem;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:item.user.avatar]];
    [_nameLabel setText:item.user.name];
    [_nameLabel sizeToFit];
    
    [_timeLabel setText:item.timeStr];
    [_timeLabel sizeToFit];
    [_timeLabel setOrigin:CGPointMake(_nameLabel.right + 5, _nameLabel.bottom - _timeLabel.height)];
    
    NSInteger contentWidth = self.width - kImageLeftMargin - kImageRightMargin;
    CGSize contentSize = [item.detail boundingRectWithSize:CGSizeMake(contentWidth, 0) andFont:_contentLabel.font];
    [_contentLabel setText:item.detail];
    [_contentLabel setFrame:CGRectMake(kImageLeftMargin, 30, contentSize.width, contentSize.height)];
    
    CGFloat spaceYStart = _contentLabel.bottom + 5;
    _collectionView.hidden = YES;
    _voiceButton.hidden = YES;
    _spanLabel.hidden = YES;
    NSInteger imageCount = item.photos.count;
    if(imageCount > 0)
    {
        NSInteger row = (item.photos.count + 2) / 3;
        NSInteger itemWidth = (contentWidth - kInnerMargin * 2) / 3;
        NSInteger innerMargin = (contentWidth - itemWidth * 3) / 2;
        [_collectionView setHidden:NO];
        NSInteger imageWidth = (row > 1) ? contentWidth : (itemWidth * imageCount + innerMargin * (imageCount - 1));
        [_collectionView setFrame:CGRectMake(kImageLeftMargin, spaceYStart, imageWidth, itemWidth * row + innerMargin * (row - 1))];
        [_collectionView reloadData];
        spaceYStart += _collectionView.height + 5;
    }
    else
    {
        _collectionView.hidden = YES;
        [_voiceButton setAudioItem:item.audioItem];
        if(item.audioItem)
        {
            _voiceButton.hidden = NO;
            _spanLabel.hidden = NO;
            [_voiceButton setY:spaceYStart + 5];
            [_spanLabel setText:[Utility formatStringForTime:item.audioItem.timeSpan]];
            [_spanLabel setY:_voiceButton.y];
            spaceYStart += _voiceButton.height + 10;
        }
    }
    [_addressButton setTitle:item.position forState:UIControlStateNormal];
    CGSize titleSize = [[_addressButton titleForState:UIControlStateNormal] sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}];
    [_addressButton setFrame:CGRectMake(kImageLeftMargin, spaceYStart, titleSize.width, titleSize.height)];
    [_actionButton setFrame:CGRectMake(self.width - 40, spaceYStart, 40, 25)];
    spaceYStart += 25;
    
    [_responseView setFrame:CGRectMake(kImageLeftMargin, spaceYStart, self.width - kImageLeftMargin - 10, 100)];
    [_responseView setResponseModel:item.responseModel];
    if(_responseView.height > 0)
        spaceYStart += _responseView.height + 10;
    [_sepLine setFrame:CGRectMake(0, spaceYStart, self.width, kLineHeight)];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    CGFloat height = 30;
    TreehouseItem *item = (TreehouseItem *)modelItem;
    CGSize contentSize = [item.detail boundingRectWithSize:CGSizeMake(width - kImageLeftMargin - kImageRightMargin, 0) andFont:[UIFont systemFontOfSize:14]];
    height += contentSize.height + 5;
    if(item.photos.count > 0)
    {
        NSInteger bgWidth = width - kImageLeftMargin - kImageRightMargin;
        NSInteger itemWidth = (bgWidth - kInnerMargin * 2) / 3;
        NSInteger row = (item.photos.count + 2) / 3;
        NSInteger innerMargin = (bgWidth - itemWidth * 3) / 2;
        height += (itemWidth * row + innerMargin * (row - 1)) + 5;
    }
    else
    {
        if(item.audioItem)
        {
            height += 10 + 40;
        }
    }
    height += 20 + 5;
    NSInteger resposeHeight = [ResponseView responseHeightForResponse:item.responseModel forWidth:width - 20 * 2 - 12 * 2];
    if(resposeHeight > 0)
        height += resposeHeight + 10;
    return @(height);
}

@end

@implementation SurroundingListModel
- (BOOL)hasMoreData
{
    return self.hasMore;
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    BOOL parse = [super parseData:data type:type];
    if(type == REQUEST_REFRESH)
        [self.modelItemArray removeAllObjects];
    TNDataWrapper *feedListWrapper = [data getDataWrapperForKey:@"list"];
    for (NSInteger i = 0; i < feedListWrapper.count; i++) {
        TreehouseItem *item = [[TreehouseItem alloc] init];
        TNDataWrapper *itemWrapper = [feedListWrapper getDataWrapperForIndex:i];
        [item parseData:itemWrapper];
        [self.modelItemArray addObject:item];
    }
    
    self.hasMore = [data getBoolForKey:@"has_more"];
    
    if(self.modelItemArray.count > 0)
    {
        ClassZoneItem *lastitem = [self.modelItemArray lastObject];
        self.minID = lastitem.itemID;
    }
    return parse;
}


@end

@interface SurroundingVC ()
@property (nonatomic, strong)ClassInfo *classInfo;
@property (nonatomic, strong)TreehouseItem *targetTreeHouseItem;
@property (nonatomic, strong)ResponseItem *targetResponseItem;
@end

@implementation SurroundingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"身边事";
    self.classInfo = [UserCenter sharedInstance].curChild.classes[0];
    [self setSupportPullDown:YES];
    [self setSupportPullUp:YES];
    [self bindTableCell:@"SurroundingCell" tableModel:@"SurroundingListModel"];
    [self requestData:REQUEST_REFRESH];
    _replyBox = [[ReplyBox alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - REPLY_BOX_HEIGHT, self.view.width, REPLY_BOX_HEIGHT)];
    [_replyBox setDelegate:self];
    [self.view addSubview:_replyBox];
    _replyBox.hidden = YES;
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"user/around"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    [task setObserver:self];
    
    SurroundingListModel *model = (SurroundingListModel *)self.tableViewModel;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    if(requestType == REQUEST_GETMORE)
        [params setValue:@"old" forKey:@"mode"];
    else
        [params setValue:@"new" forKey:@"mode"];
    [params setValue:model.minID forKey:@"min_id"];
    [params setValue:@(20) forKey:@"num"];
    [task setParams:params];
    return task;
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
        if([responseItem.commentItem.commentId length] > 0){
            TreehouseItem *zoneItem = (TreehouseItem *)cell.modelItem;
            TNButtonItem *deleteItem = [TNButtonItem itemWithTitle:@"删除评论" action:^{
                [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"comment/del" method:REQUEST_POST type:REQUEST_REFRESH withParams:@{@"id" : responseItem.commentItem.commentId,@"feed_id" : zoneItem.itemID, @"types" : @"1"} observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
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
    TreeHouseItemDetailVC *detailVC = [[TreeHouseItemDetailVC alloc] init];
    [detailVC setTreeHouseItem:treeItem];
    [self.navigationController pushViewController:detailVC animated:YES];
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


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SurroundingCell *itemCell = (SurroundingCell *)cell;
    if([itemCell respondsToSelector:@selector(setDelegate:)])
        [itemCell setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
