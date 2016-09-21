 //
//  InterestVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/5/13.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "InterestVC.h"
#import "InterestDetailVC.h"
@implementation InterestItem
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.title = [dataWrapper getStringForKey:@"title"];
    self.url = [dataWrapper getStringForKey:@"url"];
    self.pic = [dataWrapper getStringForKey:@"pic"];
    self.pv = [dataWrapper getIntegerForKey:@"pv"];
    self.ctime = [dataWrapper getStringForKey:@"ctime"];
}

@end

@implementation InterestModel

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _interestArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)hasMoreData
{
    return self.more;
}
- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    [_interestArray removeAllObjects];
    if(type == REQUEST_REFRESH)
        [self.modelItemArray removeAllObjects];
    TNDataWrapper *moreWrapper = [data getDataWrapperForKey:@"more"];
    self.more = [moreWrapper getBoolForKey:@"has"];
    self.maxID = [moreWrapper getStringForKey:@"id"];
    TNDataWrapper *itemsWrapper = [data getDataWrapperForKey:@"items"];
    for (NSInteger i = 0; i < itemsWrapper.count; i++)
    {
        TNDataWrapper *itemWrapper = [itemsWrapper getDataWrapperForIndex:i];
        InterestItem *interestItem = [[InterestItem alloc] init];
        [interestItem parseData:itemWrapper];
        [self.modelItemArray addObject:interestItem];
    }
//    for (NSInteger i = 0; i < 10; i++)
//    {
//        InterestItem *item = [[InterestItem alloc] init];
//        [item setPv:10];
//        [item setTitle:@"lalala"];
//        [item setCtime:@"2016-01-13 星期日"];
//        [item setUrl:@"http://www.baidu.com"];
//        [item setPic:@"http://pic14.nipic.com/20110522/7411759_164157418126_2.jpg"];
//        [self.modelItemArray addObject:item];
//    }
    NSMutableArray *sectionArray = nil;
    for (NSInteger i = 0; i < self.modelItemArray.count; i++)
    {
        InterestItem *item = self.modelItemArray[i];
        if(i == 0)
        {
            sectionArray = [NSMutableArray array];
            [sectionArray addObject:item];
            [_interestArray addObject:sectionArray];
        }
        else
        {
            InterestItem *preItem = self.modelItemArray[i - 1];
            if([item.ctime isEqualToString:preItem.ctime])
                [sectionArray addObject:item];
            else
            {
                sectionArray = [NSMutableArray array];
                [sectionArray addObject:item];
                [_interestArray addObject:sectionArray];
            }
        }
    }
    return YES;
}

- (NSInteger)numOfSections
{
    return _interestArray.count;
}

- (NSInteger)numOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = _interestArray[section];
    return sectionArray.count;
}

- (TNModelItem *)itemForIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionArray = _interestArray[indexPath.section];
    return sectionArray[indexPath.row];
}

- (NSString *)timeForSection:(NSInteger)section
{
    if(_interestArray.count > section)
    {
        NSArray *sectionArray = _interestArray[section];
        InterestItem *item  = sectionArray[0];
        return item.ctime;
    }
    return nil;
}

@end

@implementation InterestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.width = kScreenWidth;
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 10 - 54, 5, 54, 54)];
        [_rightImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_rightImageView setClipsToBounds:YES];
        [self addSubview:_rightImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, _rightImageView.x - 10 - 10, 30)];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_titleLabel setNumberOfLines:0];
        [_titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_titleLabel];
        
        _pvIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PVIcon"]];
        [self addSubview:_pvIcon];
        
        _pvCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_pvCountLabel setFont:[UIFont systemFontOfSize:14]];
        [_pvCountLabel setTextColor:[UIColor colorWithHexString:@"c9c9c9"]];
        [self addSubview:_pvCountLabel];
        
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    InterestItem *interestItem = (InterestItem *)modelItem;
    [_titleLabel setText:interestItem.title];
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:interestItem.pic] placeholderImage:nil];
    [_pvIcon setOrigin:CGPointMake(10, 45)];
    [_pvCountLabel setText:kStringFromValue(interestItem.pv)];
    [_pvCountLabel sizeToFit];
    [_pvCountLabel setOrigin:CGPointMake(_pvIcon.right + 5, _pvIcon.centerY - _pvCountLabel.height / 2)];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    return @(64);
}

@end

@interface InterestVC ()

@end

@implementation InterestVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.title = @"兴趣";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"info/set_read" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"type": @"1"} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [[UserCenter sharedInstance].statusManager setFound:NO];
    } fail:^(NSString *errMsg) {
        
    }];
}

- (UITableViewStyle)tableViewStyle
{
    return UITableViewStyleGrouped;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorColor:kSepLineColor];
    [self bindTableCell:@"InterestCell" tableModel:@"InterestModel"];
    [self setSupportPullDown:YES];
    [self setSupportPullUp:YES];
    [self requestData:REQUEST_REFRESH];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"user/interest"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    [task setObserver:self];
    
    if(requestType == REQUEST_GETMORE)
    {
        InterestModel *model = (InterestModel *)self.tableViewModel;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:model.maxID forKey:@"max_id"];
        [task setParams:params];
    }
    return task;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    InterestModel *model = (InterestModel *)self.tableViewModel;
    NSString *title = [model timeForSection:section];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    [label setFont:[UIFont systemFontOfSize:13]];
    [label setTextColor:[UIColor colorWithHexString:@"AAAAAA"]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:title];
    return label;
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath
{
    InterestItem *item = (InterestItem *)modelItem;
    InterestDetailVC *webVC = [[InterestDetailVC alloc] initWithUrl:[NSURL URLWithString:item.url]];
    [CurrentROOTNavigationVC pushViewController:webVC animated:YES];
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
