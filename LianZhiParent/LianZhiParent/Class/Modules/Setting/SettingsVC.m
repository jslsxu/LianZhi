//
//  SettingsVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/18.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "SettingsVC.h"
#import "PersonalInfoVC.h"

@interface SettingsVC ()

@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统设置";
    NSArray *settingTitles = @[@"个人账号",@"孩子档案",@"关联信息",@"个性设置",@"功能介绍",@"清除缓存",@"联系客服",@"退出登录"];
    
    _settingItems = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < settingTitles.count; i++) {
        SettingItem *settingItem = [[SettingItem alloc] init];
        if(i == 2 && [UserCenter sharedInstance].statusManager.changed == ChangedTypeFamily)
            [settingItem setHasNew:YES];
        [settingItem setTitle:settingTitles[i]];
        [_settingItems addObject:settingItem];
    }
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView setSeparatorColor:kSepLineColor];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setContentInset:UIEdgeInsetsMake(15, 0, 5, 0)];
    [self.view addSubview:_tableView];
    [_tableView reloadData];
}


#pragma mark -UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _settingItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuserID = @"SettingItemCell";
    SettingItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserID];
    if(cell == nil)
    {
        cell = [[SettingItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserID];
    }
    [cell setCellType:[SettingItemCell cellTypeForTableView:tableView atIndexPath:indexPath]];
    [cell setItem:_settingItems[indexPath.section]];
    if(indexPath.section == 5)
    {
        [NHFileManager totalCacheSizeWithCompletion:^(NSInteger totalSize) {
            [cell setContent:[Utility sizeStrForSize:totalSize]];
        }];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            PersonalInfoVC *infoVC = [[PersonalInfoVC alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:infoVC animated:YES];
        }
            break;
        case 1:
        {
            ChildrenInfoVC *childrenVC = [[ChildrenInfoVC alloc] init];
            [self.navigationController pushViewController:childrenVC animated:YES];
        }
            break;
        case 2:
        {
            RelatedInfoVC *relatedInfoVC = [[RelatedInfoVC alloc] init];
            [self.navigationController pushViewController:relatedInfoVC animated:YES];
        }
            break;
        case 3:
        {
            PersonalSettingVC *settingVC = [[PersonalSettingVC alloc] init];
            [self.navigationController pushViewController:settingVC animated:YES];
        }
            break;
        case 4:
        {
            TNBaseWebViewController *webVC = [[TNBaseWebViewController alloc] initWithUrl:[NSURL URLWithString:[UserCenter sharedInstance].userData.config.introUrl]];
            [webVC setTitle:@"功能介绍"];
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 5:
        {
            TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消" action:nil];
            TNButtonItem *cleanItem = [TNButtonItem itemWithTitle:@"清除缓存" action:^{
                MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在清除缓存文件..." toView:ApplicationDelegate.window];
                [NHFileManager cleanCacheWithCompletion:^{
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    [hud hide:NO];
                    [ProgressHUD showHintText:@"清除缓存完成"];
                }];
            }];
            TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"确认清除系统缓存信息吗？清除缓存不会影响您发布的信息" buttonItems:@[cancelItem, cleanItem]];
            [alertView show];

        }
            break;
        case 6:
        {
            ContactServiceVC *contactServiceVC = [[ContactServiceVC alloc] init];
            [self.navigationController pushViewController:contactServiceVC animated:YES];
        }
            break;
        case 7:
        {
            TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消" action:nil];
            TNButtonItem *confirmItem = [TNButtonItem itemWithTitle:@"确定" action:^{
                [ApplicationDelegate logout];
            }];
            TNActionSheet *actionSheet = [[TNActionSheet alloc] initWithTitle:@"确定退出登录吗?" descriptionView:nil destructiveButton:nil cancelItem:cancelItem otherItems:@[confirmItem]];
            [actionSheet show];
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
