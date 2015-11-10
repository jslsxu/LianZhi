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
@implementation DiscoveryCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.width = kScreenWidth;
        [self.textLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [self.textLabel setFont:[UIFont systemFontOfSize:15]];
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

@end

@interface DiscoveryVC ()
@property (nonatomic, strong)NSArray *titleArray;
@property (nonatomic, strong)NSArray *imageArray;
@end

@implementation DiscoveryVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.titleArray = @[@[@"兴趣"],@[@"常见问题",@"连枝剧场"],@[@"个人设置"]];
        self.imageArray = @[@[@"icon_eye"],@[@"icon_often",@"icon_caozuo"],@[@"icon-grsz"]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (BOOL)hasNew
{
    NSString *guideCellKey = @"guideCellKey";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL hasNewGuide = [userDefaults boolForKey:guideCellKey];
    BOOL hasNewMsg = [UserCenter sharedInstance].statusManager.found || [UserCenter sharedInstance].statusManager.faq || !hasNewGuide;
    return hasNewMsg;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [self.titleArray objectAtIndex:section];
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
    [cell.imageView setImage:[UIImage imageNamed:self.imageArray[section][row]]];
    [cell.textLabel setText:self.titleArray[section][row]];
    BOOL redDotHidden = YES;
    if(section == 0)
    {
        redDotHidden = ![UserCenter sharedInstance].statusManager.found;
    }
    else if(section == 1)
    {
        if(row == 0)
        {
            redDotHidden = ![UserCenter sharedInstance].statusManager.faq;
        }
        else
        {
            NSString *guideCellKey = @"guideCellKey";
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            redDotHidden = [userDefaults boolForKey:guideCellKey];
        }
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
    if(indexPath.section == 0)
    {
        InterestVC *interestVC = [[InterestVC alloc] init];
        [interestVC setTitle:self.titleArray[section][row]];
        [CurrentROOTNavigationVC pushViewController:interestVC animated:YES];
        [self setRead:1];
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            TNBaseWebViewController *webVC = [[TNBaseWebViewController alloc] init];
            [webVC setTitle:self.titleArray[section][row]];
            [webVC setUrl:[UserCenter sharedInstance].userData.config.faqUrl];
            [CurrentROOTNavigationVC pushViewController:webVC animated:YES];
            [self setRead:2];
        }
        else
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
    }
    else
    {
        MineVC *mineVC = [[MineVC alloc] init];
        [self.navigationController pushViewController:mineVC animated:YES];
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
