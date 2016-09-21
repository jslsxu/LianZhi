//
//  DiscoveryVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "DiscoveryVC.h"
#import "OperationGuideVC.h"
#import "SurroundingVC.h"
#import "MineVC.h"
#define kDiscoveryCachePath             @"DiscoveryCache"
@implementation DiscoveryItem
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.type = [dataWrapper getIntegerForKey:@"type"];
    self.name = [dataWrapper getStringForKey:@"name"];
    self.icon = [dataWrapper getStringForKey:@"icon"];
    self.url = [dataWrapper getStringForKey:@"url"];
}

@end

@implementation DiscoveryCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.width = kScreenWidth;
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 24, 24)];
        [_icon setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:_icon];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, self.width - 40 - 45, self.height)];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:_titleLabel];

        
        [self setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]]];
        
        _redDot = [[UIView alloc] initWithFrame:CGRectMake(self.width - 40, (self.height - 8) / 2, 8, 8)];
        [_redDot setBackgroundColor:[UIColor colorWithHexString:@"F0003A"]];
        [_redDot.layer setCornerRadius:4];
        [_redDot.layer setMasksToBounds:YES];
        [_redDot setHidden:YES];
        [self addSubview:_redDot];
    }
    return self;
}
- (void)setDiscoveryItem:(DiscoveryItem *)discoveryItem
{
    _discoveryItem = discoveryItem;
    [_icon sd_setImageWithURL:[NSURL URLWithString:_discoveryItem.icon] placeholderImage:nil];
    [_titleLabel setText:_discoveryItem.name];
}
@end

@interface DiscoveryVC ()
@property (nonatomic, strong)NSArray *itemArray;
@end

@implementation DiscoveryVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItems = [ApplicationDelegate.homeVC commonLeftBarButtonItems];
    [self requestData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationItem setLeftBarButtonItems:nil];
}
- (void)setTitle:(NSString *)title{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label setTextColor:[UIColor colorWithHexString:@"252525"]];
    [label setFont:[UIFont systemFontOfSize:18]];
    [label setText:title];
    [label sizeToFit];
    [self.navigationItem setTitleView:label];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发现";
    self.itemArray = [[LZKVStorage userKVStorage] storageValueForKey:kDiscoveryCachePath];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView setSeparatorColor:kSepLineColor];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStatusChanged) name:kStatusChangedNotification object:nil];
    
}

- (void)onStatusChanged
{
    
}

- (void)onSuccessWithResponse:(TNDataWrapper *)responseWrapper
{
    TNDataWrapper *sectionWrapper = [responseWrapper getDataWrapperForKey:@"sections"];
    if(sectionWrapper.count > 0)
    {
        NSMutableArray *sectionArray = [NSMutableArray array];
        for (NSInteger i = 0; i < sectionWrapper.count; i++)
        {
            TNDataWrapper *sectionItemWrapper = [sectionWrapper getDataWrapperForIndex:i];
            if(sectionItemWrapper.count > 0)
            {
                NSMutableArray *itemArray = [NSMutableArray array];
                for (NSInteger j = 0; j < sectionItemWrapper.count; j++)
                {
                    TNDataWrapper *itemWrapper = [sectionItemWrapper getDataWrapperForIndex:j];
                    DiscoveryItem *item = [[DiscoveryItem alloc] init];
                    [item parseData:itemWrapper];
                    [itemArray addObject:item];
                }
                [sectionArray addObject:itemArray];
            }
        }
        self.itemArray = sectionArray;
        [[LZKVStorage userKVStorage] saveStorageValue:self.itemArray forKey:kDiscoveryCachePath];
    }
    [_tableView reloadData];
}

- (void)requestData
{
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"info/find" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"child_id" : [UserCenter sharedInstance].curChild.uid} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
//        NSDictionary *data = responseObject.data;
        [self onSuccessWithResponse:responseObject];
    } fail:^(NSString *errMsg) {
        
    }];
}

- (BOOL)hasNew
{
    BOOL hasNewMsg = [UserCenter sharedInstance].statusManager.found || [UserCenter sharedInstance].statusManager.faq;
    return hasNewMsg;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.itemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [self.itemArray objectAtIndex:section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"DiscoveryCell";
    DiscoveryCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[DiscoveryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        [cell.textLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]]];
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    DiscoveryItem *item = self.itemArray[section][row];
    [cell setDiscoveryItem:item];
    BOOL redDotHidden = YES;
    DicoveryType type = item.type;
    if(type == DicoveryTypeInterest)
    {
        redDotHidden = ![UserCenter sharedInstance].statusManager.found;
    }
    else if(type == DicoveryTypeFAQ)
    {
        redDotHidden = ![UserCenter sharedInstance].statusManager.faq;
    }
    else if (type == DicoveryTypeAround)
    {
        redDotHidden = ![UserCenter sharedInstance].statusManager.around;
    }
    else if(type == DicoveryTypeLianZhi)
    {
        NSString *guideCellKey = @"guideCellKey";
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        redDotHidden = [userDefaults boolForKey:guideCellKey];
    }

     [cell.redDot setHidden:redDotHidden];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DiscoveryCell *cell = (DiscoveryCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.redDot setHidden:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    DiscoveryItem *item = self.itemArray[section][row];
    DicoveryType type = item.type;
    if(type == DicoveryTypeInterest)
    {
        NSString *url = [NSString appendUrl:item.url withParams:@{@"child_id" : [UserCenter sharedInstance].curChild.uid}];
        TNBaseWebViewController *webVC = [[TNBaseWebViewController alloc] initWithUrl:[NSURL URLWithString:url]];
        [webVC setTitle:item.name];
        [CurrentROOTNavigationVC pushViewController:webVC animated:YES];
        [self setRead:1];
    }
    else if(type == DicoveryTypeFAQ)
    {
        TNBaseWebViewController *webVC = [[TNBaseWebViewController alloc] initWithUrl:[NSURL URLWithString:[UserCenter sharedInstance].userData.config.faqUrl]];
        [webVC setTitle:item.name];
        [CurrentROOTNavigationVC pushViewController:webVC animated:YES];
        [self setRead:2];
    }
    else if(type == DicoveryTypeLianZhi)
    {
        NSString *guideCellKey = @"guideCellKey";
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:YES forKey:guideCellKey];
        [userDefaults synchronize];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [[NSNotificationCenter defaultCenter] postNotificationName:kStatusChangedNotification object:nil];
        OperationGuideVC *operationGuideVC = [[OperationGuideVC alloc] init];
        [CurrentROOTNavigationVC pushViewController:operationGuideVC animated:YES];
    }
    else if(type == DicoveryTypepersonalSettings)
    {
        MineVC *mineVC = [[MineVC alloc] init];
        [self.navigationController pushViewController:mineVC animated:YES];
    }
    else if (type == DicoveryTypeAround)
    {
        SurroundingVC *surroundingVC = [[SurroundingVC alloc] init];
        [self.navigationController pushViewController:surroundingVC animated:YES];
    }
    else
    {
        TNBaseWebViewController *webVC = [[TNBaseWebViewController alloc] initWithUrl:[NSURL URLWithString:item.url]];
        [webVC setTitle:item.name];
        [CurrentROOTNavigationVC pushViewController:webVC animated:YES];
    }
}

- (void)setRead:(NSInteger)type
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:kStringFromValue(type) forKey:@"type"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"info/set_read" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        
    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
