//
//  ClassSelectionVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/24.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ClassSelectionVC.h"

@interface ClassSelectionVC ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ClassSelectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorColor:kSepLineColor];
    [self.view addSubview:_tableView];
    
}

#pragma mark - UITableviewdele
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [UserCenter sharedInstance].curSchool.classes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"ClassItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        [cell.textLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    }
    ClassInfo *classInfo = [UserCenter sharedInstance].curSchool.classes[indexPath.row];
    [cell.textLabel setText:classInfo.className];
    NSString *imageStr = nil;
    if([self.originalClassID isEqualToString:classInfo.classID])
        imageStr = @"ControlSelectAll";
    else
        imageStr = @"ControlDefault";
    [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageStr]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassInfo *classInfo = [UserCenter sharedInstance].curSchool.classes[indexPath.row];
    if(self.selection)
        self.selection(classInfo);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
