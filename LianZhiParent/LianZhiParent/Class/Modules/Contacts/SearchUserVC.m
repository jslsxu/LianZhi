//
//  SearchUserVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/5/15.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "SearchUserVC.h"

@implementation SearchUserItemCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        
    }
    return self;
}

@end

@interface SearchUserVC ()<UISearchBarDelegate>

@end

@implementation SearchUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
    [self.view addSubview:headerView];
    
    [self.tableView setFrame:CGRectMake(0, headerView.bottom, self.view.width, self.view.height - headerView.bottom)];
    
}

- (void)setupHeaderView:(UIView *)viewParent
{
    UISearchBar*    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(20, 10, 200, 40)];
    [searchBar setDelegate:self];
    [viewParent addSubview:searchBar];
    
    UIButton*   scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanButton setFrame:CGRectMake(searchBar.right + 20, 15, 60, 30)];
    [scanButton addTarget:self action:@selector(onScanClicked) forControlEvents:UIControlEventTouchUpInside];
    [scanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scanButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [scanButton setBackgroundImage:[UIImage imageNamed:MJRefreshSrcName(@"GreenBG.png")] forState:UIControlStateNormal];
    [scanButton setTitle:@"扫一扫" forState:UIControlStateNormal];
    [viewParent addSubview:scanButton];
}

- (void)onScanClicked
{
    
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
