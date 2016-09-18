//
//  TreeHouseItemDetailVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/10/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TreeHouseItemDetailVC.h"

#define kInnerMargin                5

@interface TreeHouseItemDetailHeaderView ()<ActionSelectViewDelegate>
@property (nonatomic, strong)NSArray *tagArray;
@end

@implementation TreeHouseItemDetailHeaderView

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
        [_deleteButon setFrame:CGRectMake(self.width - 22, 15, 22, 22)];
        [_deleteButon setImage:[UIImage imageNamed:@"TimelineTrash"] forState:UIControlStateNormal];
        [_deleteButon addTarget:self action:@selector(onDeleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButon];
        
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 35, self.width - 10 - 45, 15)];
        [_addressLabel setTextColor:[UIColor colorWithHexString:@"cacaca"]];
        [_addressLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_addressLabel];
        
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
        
        _tagLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_tagLabel];
        
        _tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tagButton addTarget:self action:@selector(onTagButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_tagButton];
    }
    return self;
}

- (void)setTreeHouseItem:(TreehouseItem *)treeHouseItem
{
    _treeHouseItem = treeHouseItem;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:_treeHouseItem.user.avatar]];
    [_deleteButon setHidden:!_treeHouseItem.canEdit];
    [_nameLabel setText:_treeHouseItem.user.name];
    [_nameLabel sizeToFit];
    
    [_timeLabel setText:_treeHouseItem.timeStr];
    [_timeLabel sizeToFit];
    [_timeLabel setOrigin:CGPointMake(_nameLabel.right + 4, _nameLabel.y + (_nameLabel.height - _timeLabel.height) / 2)];
    
    NSInteger spaceYStart = _addressLabel.y;
    if(_treeHouseItem.position.length > 0)
    {
        [_addressLabel setText:_treeHouseItem.position];
        spaceYStart = 55;
    }
    NSString *content = _treeHouseItem.detail;
    if(content.length > 0)
    {
        CGSize contentSize = [content boundingRectWithSize:CGSizeMake(self.width - 45 - 10, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:14]];
        [_contentLabel setSize:CGSizeMake(self.width - 45 - 10, contentSize.height)];
        [_contentLabel setY:spaceYStart];
        [_contentLabel setText:content];
        spaceYStart += contentSize.height + 10;
    }
    [_voiceButton setHidden:YES];
    [_spanLabel setHidden:YES];
    if(_treeHouseItem.audioItem)
    {
        [_voiceButton setHidden:NO];
        [_spanLabel setHidden:NO];
        [_voiceButton setAudioItem:_treeHouseItem.audioItem];
        [_voiceButton setY:spaceYStart];
        [_spanLabel setText:[Utility formatStringForTime:_treeHouseItem.audioItem.timeSpan]];
        [_spanLabel setY:_voiceButton.y];
        
        spaceYStart += _voiceButton.height + 10;
    }
    else
    {
        [_voiceButton setAudioItem:nil];
    }
    [_collectionView setHidden:YES];
    NSInteger photoCount = _treeHouseItem.photos.count;
    if(photoCount > 0)
    {
        [_collectionView setHidden:NO];
        NSInteger imageCount = photoCount;
        NSInteger contentWidth = self.width - 45;
        NSInteger row = (photoCount + 2) / 3;
        NSInteger itemWidth = (contentWidth - kInnerMargin * 2) / 3;
        NSInteger innerMargin = (contentWidth - itemWidth * 3) / 2;
        NSInteger imageWidth = (row > 1) ? contentWidth : (itemWidth * imageCount + innerMargin * (imageCount - 1));
        [_collectionView setFrame:CGRectMake(45, spaceYStart, imageWidth, itemWidth * row + innerMargin * (row - 1))];
        [_collectionView reloadData];
        spaceYStart += _collectionView.height + 10;
    }
    
    _tagLabel.hidden = YES;
    if(_treeHouseItem.tag.length > 0)
    {
        _tagLabel.hidden = NO;
        NSString *tagStr = [NSString stringWithFormat:@"标签:%@",_treeHouseItem.tag];
        NSMutableAttributedString *attrTagStr = [[NSMutableAttributedString alloc] initWithString:tagStr];
        [attrTagStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName: [UIColor colorWithHexString:@"999999"]} range:NSMakeRange(0, 3)];
        [attrTagStr setAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14],NSUnderlineColorAttributeName:[UIColor colorWithHexString:@"00a274"],NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"00a274"]} range:NSMakeRange(3, _treeHouseItem.tag.length)];
        [_tagLabel setAttributedText:attrTagStr];
        [_tagLabel sizeToFit];
        [_tagLabel setFrame:CGRectMake(45, spaceYStart, _tagLabel.width, 20)];
        
        spaceYStart += _tagLabel.height + 10;
    }
    else if(_treeHouseItem.canEdit)
    {
        _tagLabel.hidden = NO;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"添加标签"];
        [str setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"00a274"], NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0, str.length)];
        [_tagLabel setAttributedText:str];
        [_tagLabel sizeToFit];
        [_tagLabel setFrame:CGRectMake(45, spaceYStart, _tagLabel.width, 30)];
        spaceYStart += _tagLabel.height + 10;
    }
    else
        spaceYStart += 10;
    [_tagButton setFrame:_tagLabel.frame];
    self.height = spaceYStart;
}

- (void)onDeleteButtonClicked
{
    if(self.deleteCallBack)
        self.deleteCallBack();
}

- (void)onTagButtonClicked
{
    if(_treeHouseItem.canEdit)
    {
        if(_treeHouseItem.tag.length == 0)
        {
            self.tagArray = [[UserCenter sharedInstance].userData.config tagForPrivilege:self.treeHouseItem.tagPrivilege];
            ActionSelectView *selectView = [[ActionSelectView alloc] init];
            [selectView setDelegate:self];
            [selectView show];
        }
        else
        {
            TNButtonItem *deleteItem = [TNButtonItem itemWithTitle:@"删除" action:^{
                __weak typeof(self) wself = self;
                [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"tree/delete_feed_tag" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"feed_id":_treeHouseItem.itemID} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                    [_treeHouseItem setTag:nil];
                    [wself setTreeHouseItem:wself.treeHouseItem];
                    if(wself.modifyCallBack)
                        wself.modifyCallBack();
                } fail:^(NSString *errMsg) {
                    
                }];
            }];
            TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消" action:nil];
            TNActionSheet *actionSheet = [[TNActionSheet alloc] initWithTitle:@"是否确认删除成长标签" descriptionView:nil destructiveButton:deleteItem cancelItem:cancelItem otherItems:nil];
            [actionSheet show];

        }
    }
}

- (void)onVoiceButtonClicked
{
    [_voiceButton setVoiceWithURL:[NSURL URLWithString:self.treeHouseItem.audioItem.audioUrl] withAutoPlay:YES];
}

#pragma mark - ActionSelectDelegate
#pragma mark - ActionSelectViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(ActionSelectView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(ActionSelectView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
        return self.tagArray.count;
    else
    {
        NSInteger index = [pickerView.pickerView selectedRowInComponent:0];
        TagGroup *group = [self.tagArray objectAtIndex:index];
        return [group.subTags count];
    }
}

- (NSString *)pickerView:(ActionSelectView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if(component == 0)
    {
        TagGroup *group = [self.tagArray objectAtIndex:row];
        return group.groupName;
    }
    else
    {
        NSInteger index = [pickerView.pickerView selectedRowInComponent:0];
        TagGroup *group = [self.tagArray objectAtIndex:index];
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
    TagGroup *group = [self.tagArray objectAtIndex:firstIndex];
    SubTag *tag = [group.subTags objectAtIndex:secondIndex];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.treeHouseItem.itemID forKey:@"feed_id"];
    [params setValue:tag.tagID forKey:@"tag_id"];
    __weak typeof(self) wself = self;
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"/tree/add_feed_tag" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [wself.treeHouseItem setTag:tag.tagName];
        [wself setTreeHouseItem:wself.treeHouseItem];
        if(wself.modifyCallBack)
            wself.modifyCallBack();
    } fail:^(NSString *errMsg) {
        [ProgressHUD showHintText:errMsg];
    }];
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.treeHouseItem.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionImageCell" forIndexPath:indexPath];
    [cell setItem:self.treeHouseItem.photos[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    [photoBrowser setCurrentPhotoIndex:indexPath.row];
    [photoBrowser setPhotos:[NSMutableArray arrayWithArray:self.treeHouseItem.photos]];
    [CurrentROOTNavigationVC pushViewController:photoBrowser animated:YES];
}
@end

@interface TreeHouseItemDetailVC ()<UITableViewDataSource, UITableViewDelegate, ReplyBoxDelegate>
@property (nonatomic, weak)ResponseItem *targetResponseItem;
@end

@implementation TreeHouseItemDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"详情";
    
    if(self.treeHouseItem)
        [self setup];
    else
        [self requestData];
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
    
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64 - 50, self.view.width, 50)];
    [self setupToolBar:_toolBar];
    [self.view addSubview:_toolBar];
    
    __weak typeof(self) wself = self;
    _headerView = [[TreeHouseItemDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 0)];
    [_headerView setTreeHouseItem:self.treeHouseItem];
    [_headerView setDeleteCallBack:^{
        [wself onDelete];
    }];
    [_headerView setModifyCallBack:^{
        if(wself.modifyCallBack)
            wself.modifyCallBack();
    }];
    [_tableView setTableHeaderView:_headerView];
    
    _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ResponseUpArrow"]];
    [_arrowImage setOrigin:CGPointMake(20, _headerView.height - _arrowImage.height)];
    [_arrowImage setHidden:YES];
    [_headerView addSubview:_arrowImage];
    
    _praiseView = [[PraiseListView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 0)];
    [_praiseView setIsSingle:self.treeHouseItem.responseModel.responseArray.count == 0];
    [_praiseView setPraiseArray:self.treeHouseItem.responseModel.praiseArray];
    
    _replyBox = [[ReplyBox alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - REPLY_BOX_HEIGHT, self.view.width, REPLY_BOX_HEIGHT)];
    [_replyBox setDelegate:self];
    [self.view addSubview:_replyBox];
    _replyBox.hidden = YES;

}

- (void)requestData
{
    __weak typeof(self) wself = self;
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"tree/detail" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"child_id":[UserCenter sharedInstance].curChild.uid,@"feed_id" : self.messageItem.feedItem.feedID} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject)
     {
         if(responseObject.count > 0)
         {
             TNDataWrapper *dataWrapper = [responseObject getDataWrapperForIndex:0];
             TreehouseItem *zoneItem = [[TreehouseItem alloc] init];
             [zoneItem parseData:dataWrapper];
             wself.treeHouseItem = zoneItem;
             [wself setup];
         }
     } fail:^(NSString *errMsg) {
         
     }];
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
        [barButton setTitleColor:kCommonParentTintColor forState:UIControlStateHighlighted];
        [barButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Normal",imageArray[i]]] forState:UIControlStateNormal];
        [barButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Highlighted",imageArray[i]]] forState:UIControlStateSelected];
        [barButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Highlighted",imageArray[i]]] forState:UIControlStateHighlighted];
        [barButton addTarget:self action:@selector(onToolBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [viewParent addSubview:barButton];
        [_buttonItems addObject:barButton];
        
        if(i == 0)
        {
            BOOL praised = [self.treeHouseItem.responseModel praised];
            [barButton setSelected:praised];
            [barButton setTitle:praised ? @"取消" : @"赞" forState:UIControlStateNormal];
        }
    }
}

- (void)onDelete
{
    TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消" action:nil];
    TNButtonItem *confirmItem = [TNButtonItem itemWithTitle:@"删除" action:^{
        MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:[UIApplication sharedApplication].keyWindow];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"tree/delete_feed" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"feed_id":self.treeHouseItem.itemID} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [hud hide:NO];
            if(self.deleteCallBack)
                self.deleteCallBack();
            [ProgressHUD showSuccess:@"删除成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            } fail:^(NSString *errMsg) {
                [hud hide:NO];
                [ProgressHUD showHintText:errMsg];
        }];
    }];
    
    TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"是否确认删除日记?" buttonItems:@[cancelItem, confirmItem]];
    [alertView show];
}

- (void)onToolBarButtonClicked:(UIButton *)button
{
    NSInteger index = [_buttonItems indexOfObject:button];
    if(index == 0)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:@"1" forKey:@"types"];
        [params setValue:[UserCenter sharedInstance].curChild.uid forKey:@"objid"];
        [params setValue:self.treeHouseItem.itemID forKey:@"feed_id"];
        BOOL praised = [self.treeHouseItem.responseModel praised];
        
        __weak typeof(self) wself = self;
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:praised ? @"fav/del" : @"fav/send" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            if(praised)//取消成功
            {
                [wself.treeHouseItem.responseModel removePraise];
                [_praiseView setPraiseArray:wself.treeHouseItem.responseModel.praiseArray];
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
                    [wself.treeHouseItem.responseModel addPraiseUser:userInfo];
                    [_praiseView setPraiseArray:wself.treeHouseItem.responseModel.praiseArray];
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
        if(self.treeHouseItem.audioItem)
        {
            [ProgressHUD showHintText:@"努力开发中,敬请期待..."];
            return;
        }
        NSString *imageUrl = nil;
        if(self.treeHouseItem.photos.count > 0){
            PhotoItem *photoItem = [self.treeHouseItem.photos firstObject];
            imageUrl = photoItem.small;
        }
        NSString *url = [NSString stringWithFormat:@"%@?uid=%@&feed_id=%@",kTreeHouseShareUrl,self.treeHouseItem.user.uid,self.treeHouseItem.itemID];
        [ShareActionView shareWithTitle:self.treeHouseItem.detail content:nil image:[UIImage imageNamed:@"TreeHouse"] imageUrl:imageUrl url:url];
    }
}

#pragma mark - ReplyBoxDelegate
- (void)onActionViewCommit:(NSString *)content
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.treeHouseItem.itemID forKey:@"feed_id"];
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
    [self.treeHouseItem.responseModel addResponse:tmpResponseItem];
    [_tableView reloadData];
    
    __weak typeof(self) wself = self;
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"comment/send" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        if(responseObject.count > 0)
        {
            TNDataWrapper *commentWrapper  =[responseObject getDataWrapperForIndex:0];
            ResponseItem *responseItem = [[ResponseItem alloc] init];
            [responseItem parseData:commentWrapper];
            
            NSInteger index = [wself.treeHouseItem.responseModel.responseArray indexOfObject:tmpResponseItem];
            [wself.treeHouseItem.responseModel.responseArray replaceObjectAtIndex:index withObject:responseItem];
            
            [_praiseView setIsSingle:wself.treeHouseItem.responseModel.responseArray.count == 0];
            [_praiseView setPraiseArray:wself.treeHouseItem.responseModel.praiseArray];
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
    NSInteger responseCount = self.treeHouseItem.responseModel.responseArray.count;
    [_arrowImage setHidden:responseCount + self.treeHouseItem.responseModel.praiseArray.count == 0];
    return responseCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResponseItem *item = self.treeHouseItem.responseModel.responseArray[indexPath.row];
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
    NSArray *responseAray = self.treeHouseItem.responseModel.responseArray;
    [cell setResponseItem:responseAray[indexPath.row]];
    if(self.treeHouseItem.responseModel.praiseArray.count == 0)
    {
        [cell setCellType:[BGTableViewCell cellTypeForTableView:tableView atIndexPath:indexPath]];
    }
    else
    {
        if(indexPath.row < responseAray.count - 1)
            [cell setCellType:TableViewCellTypeMiddle];
        else
            [cell setCellType:TableViewCellTypeLast];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ResponseItem *responseItem = self.treeHouseItem.responseModel.responseArray[indexPath.row];
    if([[UserCenter sharedInstance].userInfo.uid isEqualToString:responseItem.sendUser.uid])
    {
        __weak typeof(self) wself = self;
        TNButtonItem *deleteItem = [TNButtonItem itemWithTitle:@"删除" action:^{
            [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"comment/del" method:REQUEST_POST type:REQUEST_REFRESH withParams:@{@"id" : responseItem.commentItem.commentId,@"feed_id" : self.treeHouseItem.itemID, @"types" : @"1"} observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                [ProgressHUD showSuccess:@"删除成功"];
                [wself.treeHouseItem.responseModel removeResponse:responseItem];
                [_praiseView setIsSingle:wself.treeHouseItem.responseModel.responseArray.count == 0];
                [_praiseView setPraiseArray:wself.treeHouseItem.responseModel.praiseArray];
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
