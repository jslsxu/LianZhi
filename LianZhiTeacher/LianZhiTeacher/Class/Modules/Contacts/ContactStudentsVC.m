//
//  ContactStudentsVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/18.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ContactStudentsVC.h"
#import "ContactParentsVC.h"
#import "ContactModel.h"
#import "ContactItemCell.h"
@interface ContactStudentsVC()
@property (nonatomic, strong)NSArray *students;

@end

@implementation ContactStudentsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    self.title = self.classInfo.className;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%ld人",(unsigned long)self.classInfo.students.count] style:UIBarButtonItemStylePlain target:nil action:nil];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [_tableView setSectionIndexColor:[UIColor colorWithHexString:@"666666"]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
    
}

- (void)setClassInfo:(ClassInfo *)classInfo
{
    _classInfo = classInfo;
    NSMutableArray *studentArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *students = classInfo.students;
    NSMutableDictionary *studentDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    for (StudentInfo *student in students)
    {
        NSString *key = student.shortIndex;
        ContactGroup *studentGroup = [studentDic objectForKey:key];
        if(studentGroup == nil)
        {
            studentGroup = [[ContactGroup alloc] init];
            [studentGroup setKey:key];
            [studentDic setObject:studentGroup forKey:key];
        }
        [studentGroup.contacts addObject:student];
    }
    NSArray *allKeys = [studentDic allKeys];
    for (NSString *key in allKeys) {
        [studentArray addObject:[studentDic objectForKey:key]];
    }
    [studentArray sortUsingComparator:^NSComparisonResult(ContactGroup* obj1, ContactGroup* obj2) {
        NSString *index1 = obj1.key;
        NSString *index2 = obj2.key;
        return [index1 compare:index2];
        
    }];

    self.students = studentArray;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.students.count + 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    else
    {
        ContactGroup *group = [self.students objectAtIndex:section - 1];
        return group.contacts.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        NSString *cellID = @"ClassItemCell";
        ClassItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(nil == cell)
        {
            cell = [[ClassItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        [cell setClassInfo:self.classInfo];
        return cell;
    }
    else
    {
        NSString *cellID = @"ContactItemCell";
        ContactItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(nil == cell)
        {
            cell = [[ContactItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        ContactGroup *group = [self.students objectAtIndex:indexPath.section - 1];
        UserInfo *userInfo = [[group contacts] objectAtIndex:indexPath.row];
        [cell setUserInfo:userInfo];
        return cell;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 25)];
    [headerView setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    NSString *title = nil;
    if(section == 0)
        title = @"群";
    else
    {
        ContactGroup *group = [self.students objectAtIndex:section - 1];
        title = group.key;
    }
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, headerView.width - 15, headerView.height)];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"8e8e8e"]];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setText:title];
    [headerView addSubview:titleLabel];
    return headerView;

}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *keys = [NSMutableArray array];
    [keys addObject:@"群"];
    for (ContactGroup *group in self.students) {
        [keys addObject:group.key];
    }
    return keys;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0)
    {
        JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
        [chatVC setTo_objid:[UserCenter sharedInstance].curSchool.schoolID];
        [chatVC setTargetID:self.classInfo.classID];
        [chatVC setChatType:ChatTypeClass];
        [chatVC setTitle:self.classInfo.className];
        [ApplicationDelegate popAndPush:chatVC];
    }
    else
    {
        ContactParentsVC *parentsVC = [[ContactParentsVC alloc] init];
        ContactGroup *group = [self.students objectAtIndex:indexPath.section - 1];
        [parentsVC setStudentInfo:[group.contacts objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:parentsVC animated:YES];
    }
}
@end
