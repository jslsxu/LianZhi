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
@implementation SurroundingCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        _sepLine = [[UIView alloc] initWithFrame:CGRectZero];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    [super onReloadData:modelItem];
    _tagLabel.hidden = YES;
    _tagButton.hidden = YES;
    _trashButton.hidden = YES;
    [_sepLine setFrame:CGRectMake(0, _bgView.bottom + 10 - kLineHeight, self.width, kLineHeight)];
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
            if(self.targetTreeHouseItem.photos.count > 0)
                imageUrl = [self.targetTreeHouseItem.photos[0] thumbnailUrl];
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
    ClassZoneItemCell *itemCell = (ClassZoneItemCell *)cell;
    if([itemCell respondsToSelector:@selector(setDelegate:)])
        [itemCell setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
