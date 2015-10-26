//
//  DiscoveryVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "DiscoveryVC.h"
#import "InterestVC.h"
#import "OperationGuideVC.h"
#import "SurroundingVC.h"
@implementation DiscoveryCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.width = kScreenWidth;
        
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
        self.titleArray = @[@[@"身边事",@"兴趣"],@[@"常见问题",@"连枝剧场"]];
        self.imageArray = @[@[@"MineNear",@"icon_eye"],@[@"icon_often",@"icon_caozuo"]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView setSeparatorColor:kCommonSeparatorColor];
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            SurroundingVC *surroundingVC = [[SurroundingVC alloc] init];
            [CurrentROOTNavigationVC pushViewController:surroundingVC animated:YES];
        }
        else
        {
            InterestVC *interestVC = [[InterestVC alloc] init];
            [interestVC setTitle:@"兴趣"];
            [CurrentROOTNavigationVC pushViewController:interestVC animated:YES];
        }
    }
    else
    {
        if(indexPath.row == 0)
        {
            TNBaseWebViewController *webVC = [[TNBaseWebViewController alloc] init];
            [webVC setUrl:[UserCenter sharedInstance].userData.config.faqUrl];
            [webVC setTitle:@"常见问题"];
            [CurrentROOTNavigationVC pushViewController:webVC animated:YES];
        }
        else
        {
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
