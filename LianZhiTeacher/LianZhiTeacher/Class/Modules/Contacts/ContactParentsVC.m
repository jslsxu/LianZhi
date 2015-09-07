//
//  ContactParentsVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/18.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ContactParentsVC.h"
#import "JSMessagesViewController.h"
@interface ContactParentsVC()
@property (nonatomic, strong)NSArray *parents;

@end

@implementation ContactParentsVC
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.studentInfo.name;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%ld人",(unsigned long)self.studentInfo.family.count] style:UIBarButtonItemStylePlain target:nil action:nil];
    if(self.presentedByClassOperation)
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:(@"WhiteLeftArrow.png")] style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [_tableView setSectionIndexColor:kCommonTeacherTintColor];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
    
}

- (void)onCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setStudentInfo:(StudentInfo *)studentInfo
{
    _studentInfo = studentInfo;
    NSArray *students = self.studentInfo.family;
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:0];
    for (FamilyInfo *item in students) {
        if(item.relation)
        {
            BOOL contains = NO;
            for (NSString *key in keys) {
                if([key isEqualToString:item.relation])
                    contains = YES;
            }
            if(contains)
                continue;
            else
                [keys addObject:item.relation];
        }
    }
    
    NSMutableArray *parentsArray = [NSMutableArray array];
    for (NSString *key in keys) {
        ContactGroup *group = [[ContactGroup alloc] init];
        [group setKey:key];
        [parentsArray addObject:group];
        for (FamilyInfo *item in students) {
            if([item.relation isEqualToString:key])
                [group.contacts addObject:item];
        }
    }
    self.parents = parentsArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.parents.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ContactGroup *group = [self.parents objectAtIndex:section];
    return group.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ContactItemCell";
    ContactItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(nil == cell)
    {
        cell = [[ContactItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    ContactGroup *group = [self.parents objectAtIndex:indexPath.section];
    FamilyInfo *userInfo = [[group contacts] objectAtIndex:indexPath.row];
    [cell setUserInfo:userInfo];
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    ContactGroup *group = [self.parents objectAtIndex:section];
    return group.key;
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    NSMutableArray *keys = [NSMutableArray array];
//    for (ContactGroup *group in self.parents) {
//        [keys addObject:group.key];
//    }
//    return keys;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ContactGroup *group = [self.parents objectAtIndex:indexPath.section];
    FamilyInfo *userInfo = [[group contacts] objectAtIndex:indexPath.row];
//    if(userInfo.mobile.length > 0)
//    {
//        TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消" action:nil];
//        TNButtonItem *item = [TNButtonItem itemWithTitle:@"拨打" action:^{
//            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",userInfo.mobile];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//        }];
//        TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:[NSString stringWithFormat:@"是否拨打电话%@",userInfo.mobile] buttonItems:@[cancelItem,item]];
//        [alertView show];
//    }
    JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
    [chatVC setName:userInfo.name];
    [chatVC setUserID:userInfo.uid];
    [CurrentROOTNavigationVC pushViewController:chatVC animated:YES];
}


@end
