//
//  SurroundingVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "SurroundingVC.h"
#import "FeedItemDetailVC.h"
@implementation SurroundingCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [_deleteButton removeFromSuperview];
        _deleteButton.hidden = YES;
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    [super onReloadData:modelItem];
    ClassZoneItem *zoneItem = (ClassZoneItem *)modelItem;
    if([zoneItem.userInfo.uid isEqualToString:[UserCenter sharedInstance].userInfo.uid])
        [_nameLabel setText:@"我"];
    else
        [_nameLabel setText:zoneItem.userInfo.name];
    [_nameLabel sizeToFit];
    
    [_timeLabel setText:zoneItem.formatTime];
    [_timeLabel sizeToFit];
    [_timeLabel setOrigin:CGPointMake(_nameLabel.right + 5, _nameLabel.bottom - _timeLabel.height)];
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
        ClassZoneItem *item = [[ClassZoneItem alloc] init];
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
@property (nonatomic, strong)ClassZoneItem *targetZoneItem;
@property (nonatomic, strong)ResponseItem* targetResponseItem;
@end

@implementation SurroundingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"身边事";
    self.classInfo = [UserCenter sharedInstance].curSchool.classes[0];
    [self bindTableCell:@"SurroundingCell" tableModel:@"SurroundingListModel"];
    [self setSupportPullUp:YES];
    [self setSupportPullDown:YES];
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
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    SurroundingListModel *model = (SurroundingListModel *)self.tableViewModel;
    if(requestType == REQUEST_GETMORE)
        [params setValue:@"old" forKey:@"mode"];
    else
        [params setValue:@"new" forKey:@"mode"];
    [params setValue:model.minID forKey:@"min_id"];
    
    [params setValue:@(20) forKey:@"num"];
    [task setParams:params];
    [task setObserver:self];
    return task;
}

#pragma mark - ClassZoneItemCellDelegate
- (void)onResponseClickedAtTarget:(ResponseItem *)responseItem cell:(ClassZoneItemCell *)cell
{
    if([[UserCenter sharedInstance].userInfo.uid isEqualToString:responseItem.sendUser.uid])
    {
        ClassZoneItem *zoneItem = (ClassZoneItem *)cell.modelItem;
        if([responseItem.commentItem.commentId length] > 0){
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
            TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"删除评论，会删除相应积分，确认删除吗？" buttonItems:@[cancelItem, deleteItem]];
            [alertView show];
        }
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
    CGPoint point = [cell.actionButton convertPoint:CGPointMake(0, cell.actionButton.height / 2) toView:keyWindow];
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
                if(self.targetZoneItem.photos.count > 0)
                {
                    PhotoItem *photoItem = [self.targetZoneItem.photos firstObject];
                    imageUrl = photoItem.small;
                }
                if(imageUrl.length == 0)
                    imageUrl = self.classInfo.logo;
                [ShareActionView shareWithTitle:self.targetZoneItem.content content:nil image:[UIImage imageNamed:@"ClassZone"] imageUrl:imageUrl url:[NSString stringWithFormat:@"http://m.edugate.cn/share/%@_%@.html",self.targetZoneItem.userInfo.uid,self.targetZoneItem.itemID]];
            }
        }
    }];
    [actionView show];
}

- (void)onShowDetail:(ClassZoneItem *)zoneItem
{
    FeedItemDetailVC *feedItemDetailVC = [[FeedItemDetailVC alloc] init];
    [feedItemDetailVC setZoneItem:zoneItem];
    [self.navigationController pushViewController:feedItemDetailVC animated:YES];
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
    __weak typeof(self) wself = self;
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"comment/send" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        if(responseObject.count > 0)
        {
            TNDataWrapper *commentWrapper  =[responseObject getDataWrapperForIndex:0];
            ResponseItem *responseItem = [[ResponseItem alloc] init];
            [responseItem parseData:commentWrapper];
            [wself.targetZoneItem.responseModel addResponse:responseItem];
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

#pragma mark - TNBaseTableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassZoneItemCell *itemCell = (ClassZoneItemCell *)cell;
    if([itemCell isKindOfClass:[ClassZoneItemCell class]])
        [itemCell setDelegate:self];
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
