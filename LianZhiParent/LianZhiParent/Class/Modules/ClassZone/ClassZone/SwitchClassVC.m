//
//  SwitchClassVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/9/11.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "SwitchClassVC.h"

@interface SwitchClassVC ()
@end

@implementation SwitchClassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setSeparatorColor:kSepLineColor];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [UserCenter sharedInstance].curChild.classes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"SwitchClassCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.textLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    ClassInfo *classInfo = [UserCenter sharedInstance].curChild.classes[indexPath.row];
    [cell.textLabel setText:classInfo.className];
    if([self.classInfo.classID isEqualToString:classInfo.classID])
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ControlSelected"]]];
    else
        [cell setAccessoryView:nil];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.classInfo = [UserCenter sharedInstance].curChild.classes[indexPath.row];
    [_tableView reloadData];
    if(self.completion)
        self.completion(self.classInfo);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
