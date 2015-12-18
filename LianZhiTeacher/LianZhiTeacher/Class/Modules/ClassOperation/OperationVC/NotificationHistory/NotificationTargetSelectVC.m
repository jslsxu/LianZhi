//
//  NotificationTargetSelectVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/12/17.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "NotificationTargetSelectVC.h"

@interface NotificationTargetSelectVC ()
@property (nonatomic, strong)NSMutableArray *targetArray;
@end

@implementation NotificationTargetSelectVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.targetArray = [NSMutableArray array];
    NSArray *classArray = [UserCenter sharedInstance].curSchool.classes;
    if(classArray.count > 0)
    {
        NSDictionary *dic = @{@"type":@"我所有的班", @"conetnt" : classArray};
        [self.targetArray addObject:dic];
    }
    NSArray *teacherGroupArray = [UserCenter sharedInstance].curSchool.groups;
    if(teacherGroupArray.count > 0)
    {
        NSDictionary *dic = @{@"type":@"教师分组", @"conetnt" : teacherGroupArray};
        [self.targetArray addObject:dic];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.targetArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = self.targetArray[section];
    NSArray *array = dic[@"content"];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseID = @"";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
