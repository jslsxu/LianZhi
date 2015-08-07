//
//  DiscoveryVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "DiscoveryVC.h"

@implementation DiscoveryItemCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        
    }
    return self;
}

@end

@interface DiscoveryVC ()

@end

@implementation DiscoveryVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发现";
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"DiscoveryCell";
    DiscoveryItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[DiscoveryItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    [cell setCellType:[BGTableViewCell cellTypeForTableView:tableView atIndexPath:indexPath]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            
        }
        else
        {
            InterestVC *interestVC = [[InterestVC alloc] init];
            [CurrentROOTNavigationVC pushViewController:interestVC animated:YES];
        }
    }
    else
    {
        if(indexPath.row == 0)
        {
            QRCodeScanVC *qrCodeScanVC = [[QRCodeScanVC alloc] init];
            [qrCodeScanVC setDelegate:self];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:qrCodeScanVC];
            [self presentViewController:nav animated:YES completion:nil];
        }
        else
        {
            
        }
    }
}

#pragma mark - QRcodeScanDelegate

- (void)qrCodeScanVC:(QRCodeScanVC *)scanVC didFinish:(NSString *)info
{
    [scanVC dismissViewControllerAnimated:YES completion:^{
        NSURL *url = [NSURL URLWithString:info];
        NSString *scheme = [url scheme];
        if(scheme)
        {
            TNBaseWebViewController *webVC = [[TNBaseWebViewController alloc] init];
            [webVC setUrl:info];
            [CurrentROOTNavigationVC pushViewController:webVC animated:YES];
        }
        else
        {
            
        }
    }];
}

- (void)qrCodeScanVC:(QRCodeScanVC *)scanVC didFailWithError:(NSString *)error
{
    [scanVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)qrCodeScanVCDidCancel:(QRCodeScanVC *)scanVC
{
    [scanVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
