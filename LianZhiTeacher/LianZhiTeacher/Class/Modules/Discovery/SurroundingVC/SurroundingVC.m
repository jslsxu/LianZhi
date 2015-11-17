//
//  SurroundingVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "SurroundingVC.h"

@implementation SurroundingListModel

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
    [self bindTableCell:@"ClassZoneItemCell" tableModel:@"SurroundingListModel"];
    
    _replyBox = [[ReplyBox alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - REPLY_BOX_HEIGHT, self.view.width, REPLY_BOX_HEIGHT)];
    [_replyBox setDelegate:self];
    [self.view addSubview:_replyBox];
    _replyBox.hidden = YES;
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
                    imageUrl = [self.targetZoneItem.photos[0] thumbnailUrl];
                if(imageUrl.length == 0)
                    imageUrl = self.classInfo.logoUrl;
                [ShareActionView shareWithTitle:self.targetZoneItem.content content:nil image:[UIImage imageNamed:@"ClassZone"] imageUrl:imageUrl url:[NSString stringWithFormat:@"http://m.edugate.cn/share/%@_%@.html",self.targetZoneItem.userInfo.uid,self.targetZoneItem.itemID]];
            }
        }
    }];
    [actionView show];
}

- (void)onShowDetail:(ClassZoneItem *)zoneItem
{
    
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
