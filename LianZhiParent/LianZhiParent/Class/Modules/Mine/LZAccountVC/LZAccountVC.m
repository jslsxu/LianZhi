//
//  LZAccountVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/10/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "LZAccountVC.h"

@implementation AccounInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.textLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [self.textLabel setFont:[UIFont systemFontOfSize:14]];
        
        [self.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
        [self.detailTextLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_numLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [self addSubview:_numLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    AccountInfoItem *item = (AccountInfoItem *)modelItem;
    [self.textLabel setText:item.title];
    [self.detailTextLabel setText:item.ctime];
    [_numLabel setText:[NSString stringWithFormat:@"%@%ld",item.num > 0 ? @"+" : @"-",labs(item.num)]];
    [_numLabel sizeToFit];
    if(item.num > 0)
        [_numLabel setTextColor:[UIColor colorWithHexString:@"F0AB2A"]];
    else
    {
        [_numLabel setTextColor:[UIColor colorWithHexString:@"D07083"]];
    }
    [_numLabel setOrigin:CGPointMake(self.width - _numLabel.width - 10, (self.height - _numLabel.height) / 2)];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    return @(44);
}
@end

@implementation AccountInfoItem
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.title = [dataWrapper getStringForKey:@"title"];
    self.num = [dataWrapper getIntegerForKey:@"num"];
    self.ctime = [dataWrapper getStringForKey:@"ctime"];
}

@end

@implementation AccountInfoListModel
- (BOOL)hasMoreData
{
    return self.more;
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    if(type == REQUEST_REFRESH)
        [self.modelItemArray removeAllObjects];
    TNDataWrapper *userCoinWrapper = [data getDataWrapperForKey:@"user_coin"];
    self.coinTotal = [userCoinWrapper getIntegerForKey:@"coin_total"];
    self.earnUrl = [data getStringForKey:@"earnUrl"];
    self.exchangeUrl = [data getStringForKey:@"exchangeUrl"];
    
    TNDataWrapper *moreWrapper  =[data getDataWrapperForKey:@"more"];
    self.more = [moreWrapper getBoolForKey:@"has"];
    self.maxID = [moreWrapper getStringForKey:@"id"];
    
    TNDataWrapper *itemsWrapper = [data getDataWrapperForKey:@"items"];
    for (NSInteger i = 0; i < itemsWrapper.count; i++)
    {
        TNDataWrapper *itemWrapper = [itemsWrapper getDataWrapperForIndex:i];
        AccountInfoItem *item = [[AccountInfoItem alloc] init];
        [item parseData:itemWrapper];
        [self.modelItemArray addObject:item];
    }
    return YES;
}

@end

@interface LZAccountVC ()
@property (nonatomic, assign)NSInteger filterType;
@end

@implementation LZAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"连枝账户";
    
    [self bindTableCell:@"AccounInfoCell" tableModel:@"AccountInfoListModel"];
    [self setSupportPullDown:YES];
    [self setSupportPullUp:YES];
    [self requestData:REQUEST_REFRESH];
    
    [self setupHeaderView];
}

- (void)setupHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 150)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setFont:[UIFont systemFontOfSize:13]];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
    [titleLabel setText:@"当前连枝余额"];
    [titleLabel sizeToFit];
    [titleLabel setOrigin:CGPointMake(10, 20)];
    [headerView addSubview:titleLabel];
    
    UIButton *helpbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [helpbutton setFrame:CGRectMake(headerView.width - 10 - 80, 20, 80, 20)];
    [helpbutton setImage:[UIImage imageNamed:@"AccountFaq"] forState:UIControlStateNormal];
    [helpbutton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [helpbutton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [helpbutton setTitle:@"如何赚取" forState:UIControlStateNormal];
    [helpbutton setTitleColor:kCommonParentTintColor forState:UIControlStateNormal];
    [helpbutton addTarget:self action:@selector(showHelp) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:helpbutton];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_numLabel setTextColor:[UIColor colorWithHexString:@"F0AB2A"]];
    [_numLabel setFrame:CGRectMake(10, titleLabel.bottom + 5, 160, 25)];
    [headerView addSubview:_numLabel];
    
    UIButton *exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [exchangeButton setFrame:CGRectMake(10, headerView.height - 30 - 15 - 32, headerView.width - 10 * 2, 32)];
    [exchangeButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"E82557"] size:exchangeButton.size cornerRadius:16] forState:UIControlStateNormal];
    [exchangeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exchangeButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [exchangeButton setTitle:@"兑换奖品" forState:UIControlStateNormal];
    [exchangeButton addTarget:self action:@selector(onExchangeClicked) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:exchangeButton];
    
    UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, headerView.width, 30)];
    [filterView setBackgroundColor:self.view.backgroundColor];
    [headerView addSubview:filterView];
    
    UISegmentedControl *segmentCtrl = [[UISegmentedControl alloc] initWithItems:@[@"全部",@"赚取",@"消费"]];
    [segmentCtrl setTintColor:kCommonParentTintColor];
    [segmentCtrl setSelectedSegmentIndex:0];
    [segmentCtrl setFrame:CGRectMake(headerView.width - 10 - 120, 3, 120, 24)];
    [segmentCtrl addTarget:self action:@selector(onSegmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [filterView addSubview:segmentCtrl];
    
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, segmentCtrl.x - 10 - 10 , 30)];
    [hintLabel setText:@"积分记录"];
    [hintLabel setFont:[UIFont systemFontOfSize:13]];
    [hintLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
    [filterView addSubview:hintLabel];
    
    [headerView addSubview:filterView];
    
    [self.tableView setTableHeaderView:headerView];
}

- (void)setupSectionHeaderView
{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    [_headerView setBackgroundColor:self.view.backgroundColor];
    
    UISegmentedControl *segmentCtrl = [[UISegmentedControl alloc] initWithItems:@[@"全部",@"赚取",@"消费"]];
    [segmentCtrl setTintColor:kCommonParentTintColor];
    [segmentCtrl setSelectedSegmentIndex:0];
    [segmentCtrl setFrame:CGRectMake(_headerView.width - 10 - 120, 3, 120, 24)];
    [segmentCtrl addTarget:self action:@selector(onSegmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_headerView addSubview:segmentCtrl];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, segmentCtrl.x - 10 - 10 , _headerView.height)];
    [titleLabel setText:@"积分记录"];
    [titleLabel setFont:[UIFont systemFontOfSize:13]];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
    [_headerView addSubview:titleLabel];
}

- (void)showHelp
{
    AccountInfoListModel *infoModel = (AccountInfoListModel *)self.tableViewModel;
    TNBaseWebViewController *webVC = [[TNBaseWebViewController alloc] initWithUrl:[NSURL URLWithString:infoModel.earnUrl]];
    [CurrentROOTNavigationVC pushViewController:webVC animated:YES];
}

- (void)onExchangeClicked
{
    AccountInfoListModel *infoModel = (AccountInfoListModel *)self.tableViewModel;
    TNBaseWebViewController *webVC = [[TNBaseWebViewController alloc] initWithUrl:[NSURL URLWithString:infoModel.exchangeUrl]];
    [CurrentROOTNavigationVC pushViewController:webVC animated:YES];
}

- (void)onSegmentValueChanged:(UISegmentedControl *)segmentCtrl
{
    self.filterType = segmentCtrl.selectedSegmentIndex;
    [self requestData:REQUEST_REFRESH];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"user/coin"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    [task setObserver:self];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:kStringFromValue(self.filterType) forKey:@"ctype"];
    if(requestType == REQUEST_GETMORE)
    {
        AccountInfoListModel *infoModel = (AccountInfoListModel *)self.tableViewModel;
        [params setValue:infoModel.maxID forKey:@"max_id"];
    }
    [task setParams:params];
    return task;
}

- (void)TNBaseTableViewControllerRequestSuccess
{
    AccountInfoListModel *infoModel = (AccountInfoListModel *)self.tableViewModel;
    NSMutableAttributedString *numStr = [[NSMutableAttributedString alloc] initWithString:kStringFromValue(infoModel.coinTotal) attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24]}];
    [numStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"个" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]}]];
    [_numLabel setAttributedText:numStr];
    [_numLabel sizeToFit];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
