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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.titleArray = @[@[@"兴趣"],@[@"常见问题",@"连枝剧场"]];
        self.imageArray = @[@[@"icon_eye"],@[@"icon_often",@"icon_caozuo"]];
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
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    return 2;
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
    if(section == 1 && row == 1 )
    {
        NSString *guideCellKey = @"guideCellKey";
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        BOOL guideCellNew = [userDefaults boolForKey:guideCellKey];
        if(!guideCellNew)
        {
            [cell.redDot setHidden:NO];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(indexPath.section == 0)
    {
        InterestVC *interestVC = [[InterestVC alloc] init];
        [interestVC setTitle:self.titleArray[section][row]];
        [CurrentROOTNavigationVC pushViewController:interestVC animated:YES];
    }
    else
    {
        if(indexPath.row == 0)
        {
            TNBaseWebViewController *webVC = [[TNBaseWebViewController alloc] init];
            [webVC setTitle:self.titleArray[section][row]];
            [webVC setUrl:[UserCenter sharedInstance].userData.config.faqUrl];
            [CurrentROOTNavigationVC pushViewController:webVC animated:YES];
        }
        else
        {
            NSString *guideCellKey = @"guideCellKey";
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setBool:YES forKey:guideCellKey];
            [userDefaults synchronize];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            OperationGuideVC *operationGuideVC = [[OperationGuideVC alloc] init];
            [CurrentROOTNavigationVC pushViewController:operationGuideVC animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
