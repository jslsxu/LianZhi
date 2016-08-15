//
//  NotificationRecordVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/31.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationRecordVC.h"
#import "NotificationDetailVC.h"

@implementation NotificationRecordItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.moreOptionsButton setBackgroundColor:[UIColor colorWithHexString:@"28c4d8"]];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self.actualContentView addSubview:_titleLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setFont:[UIFont systemFontOfSize:14]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_timeLabel setText:@"05-11 11:23"];
        [self.actualContentView addSubview:_timeLabel];
        
        _audioImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"draft_audio"]];
        [self.actualContentView addSubview:_audioImageView];
        
        _photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"draft_photo"]];
        [self.actualContentView addSubview:_photoImageView];
        
        _videoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"draft_video"]];
        [self.actualContentView addSubview:_videoImageView];

        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self.actualContentView addSubview:_sepLine];
        
        [self.moreOptionsButton setHidden:YES];
    }
    return self;
}

- (CGFloat)contextMenuWidth
{
    return CGRectGetWidth(self.deleteButton.frame);
}
- (CGFloat)menuOptionButtonWidth{
    return 66;
}

- (void)setNotificationItem:(NotificationItem *)notificationItem{
    _notificationItem = notificationItem;
    [_titleLabel setFrame:CGRectMake(12, 18, self.width - 12 * 2, 20)];
    [_titleLabel setText:_notificationItem.words];
    [self.moreOptionsButton setTitle:@"转发" forState:UIControlStateNormal];
    [_sepLine setFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
    
    [_audioImageView setHidden:!_notificationItem.hasAudio];
    [_photoImageView setHidden:!_notificationItem.hasImage];
    [_videoImageView setHidden:!_notificationItem.hasVideo];
    CGFloat spaceXStart = 20;
    CGFloat centerY = 50;
    if(_notificationItem.hasAudio){
        [_audioImageView setCenter:CGPointMake(spaceXStart, centerY)];
        spaceXStart += _audioImageView.width + 15;
    }
    if(_notificationItem.hasImage){
        [_photoImageView setCenter:CGPointMake(spaceXStart, centerY)];
        spaceXStart += _photoImageView.width + 15;
    }
    if(_notificationItem.hasVideo){
        [_videoImageView setCenter:CGPointMake(spaceXStart, centerY)];
    }
}

@end

@interface NotificationRecordVC ()<EGORefreshTableHeaderDelegate>
{

}
@property (nonatomic, strong)EGORefreshTableHeaderView*  refreshHeaderView;
@property (nonatomic, assign)BOOL                        isLoading;
@property (nonatomic, assign)NSInteger total;
@property (nonatomic, strong)NSMutableArray* notificationArray;
@end

@implementation NotificationRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.height, self.tableView.width, self.tableView.height)];
    self.refreshHeaderView.delegate = self;
    [self.tableView addSubview:self.refreshHeaderView];
    
    [self requestData:REQUEST_REFRESH];
}

- (NSMutableArray *)notificationArray{
    if(_notificationArray == nil){
        _notificationArray = [NSMutableArray array];
    }
    return _notificationArray;
}

- (void)clear{
    
}

- (void)requestData:(REQUEST_TYPE)requestType{
    if(!self.isLoading){
        self.isLoading = YES;
        @weakify(self)
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/my_send_list" method:REQUEST_GET type:requestType withParams:@{@"from" : kStringFromValue(_notificationArray.count)} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            @strongify(self)
            self.total = [responseObject getIntegerForKey:@"total"];
            NSArray *array = [NotificationItem nh_modelArrayWithJson:[responseObject getDataWrapperForKey:@"list"].data];
            if(requestType == REQUEST_REFRESH){
                [self.notificationArray removeAllObjects];
            }
            [self.notificationArray addObjectsFromArray:array];
            [self.tableView reloadData];
            self.isLoading = NO;
            [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
            [self.tableView.mj_footer endRefreshing];
            if(self.notificationArray.count < self.total){
                [self.tableView setMj_footer:[MJRefreshFooter footerWithRefreshingBlock:^{
                    [self requestData:REQUEST_GETMORE];
                }]];
            }
            else{
                [self.tableView setMj_footer:nil];
            }
        } fail:^(NSString *errMsg) {
            self.isLoading = NO;
            [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
            [self.tableView.mj_footer endRefreshing];
        }];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _notificationArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"NotificationRecordItemCell";
    NotificationRecordItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(cell == nil){
        cell = [[NotificationRecordItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        [cell setDelegate:self];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationRecordItemCell *itemCell = (NotificationRecordItemCell *)cell;
    NotificationItem *item = _notificationArray[indexPath.row];
    [itemCell setNotificationItem:item];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NotificationItem *item = _notificationArray[indexPath.row];
    NotificationDetailVC*  detailVC = [[NotificationDetailVC alloc] init];
    [detailVC setNotificationID:item.nid];
    [CurrentROOTNavigationVC pushViewController:detailVC animated:YES];
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self requestData:REQUEST_REFRESH];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _isLoading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}

#pragma mark - DAContextMenuCellDelegate
- (void)contextMenuCellDidSelectDeleteOption:(DAContextMenuCell *)cell{
    
}

- (void)contextMenuCellDidSelectMoreOption:(DAContextMenuCell *)cell{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
