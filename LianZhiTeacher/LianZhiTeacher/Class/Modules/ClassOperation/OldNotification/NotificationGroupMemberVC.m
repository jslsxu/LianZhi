//
//  NotificationGroupMemberVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/11/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "NotificationGroupMemberVC.h"
#import "ContactModel.h"
@interface NotificationGroupMemberVC ()

@end

@implementation NotificationGroupMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setTeacherGorup:(TeacherGroup *)teacherGorup
{
    _teacherGorup = teacherGorup;
    NSMutableArray *studentArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *students = _teacherGorup.teachers;
    NSMutableDictionary *studentDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    for (StudentInfo *student in students)
    {
        NSString *key = student.first_letter;
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
- (BOOL)selectedForStudent:(TeacherInfo *)teacherInfo
{
    BOOL selected = NO;
    for (NSString *studentId in self.seletedArray)
    {
        if([studentId isEqualToString:teacherInfo.uid])
            selected = YES;
    }
    return selected;
}


#pragma mark - UItableVIewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.students.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ContactGroup *group = self.students[section];
    return group.contacts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 25)];
    [headerView setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    NSString *title = nil;
    ContactGroup *group = [self.students objectAtIndex:section];
    title = group.key;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, headerView.width - 15, headerView.height)];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"8e8e8e"]];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setText:title];
    [headerView addSubview:titleLabel];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseID = @"NotificationStudentCell";
    NotificationStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(cell == nil)
    {
        cell = [[NotificationStudentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    ContactGroup *group = self.students[indexPath.section];
    TeacherInfo *teacherInfo = group.contacts[indexPath.row];
    [cell onReloadData:teacherInfo];
    [cell setChecked:[self selectedForStudent:teacherInfo]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactGroup *group = self.students[indexPath.section];
    TeacherInfo *teacherInfo = group.contacts[indexPath.row];
    if([self selectedForStudent:teacherInfo])
        [self.seletedArray removeObject:teacherInfo.uid];
    else
    {
        [self.seletedArray addObject:teacherInfo.uid];
    }
    [_tableView reloadData];
}

- (void)onSend
{
    if(self.seletedArray.count == 0)
    {
        [ProgressHUD showHintText:@"还没有选择发送对象"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.params];
    [params setValue:[NSString stringWithJSONObject:@[@{@"id" : self.teacherGorup.groupID,@"teachers":self.seletedArray}]] forKey:@"groups"];
    if(self.imageArray.count > 0)
    {
        NSMutableString *picSeq = [[NSMutableString alloc] init];
        for (NSInteger i = 0; i < self.imageArray.count; i++)
        {
            [picSeq appendFormat:@"picture_%ld,",(long)i];
        }
        [params setValue:picSeq forKey:@"pic_seqs"];
    }
    
    if(self.imageArray.count > 0)
    {
//        NotificationItem *notificationItem = [[NotificationItem alloc] init];
//        [notificationItem setImageArray:self.imageArray];
//        [notificationItem setWords:self.params[@"words"]];
//        [notificationItem setParams:params];
//        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPublishNotification object:nil userInfo:@{@"item" : notificationItem}];
//        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        
        MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:self.view];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/send" withParams:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (NSInteger i = 0; i < self.imageArray.count; i++)
            {
                NSString *filename = [NSString stringWithFormat:@"picture_%ld",(long)i];
                [formData appendPartWithFileData:UIImageJPEGRepresentation(self.imageArray[i], 0.8) name:filename fileName:filename mimeType:@"image/jpeg"];
            }
            if(self.audioData)
                [formData appendPartWithFileData:self.audioData name:@"voice" fileName:@"voice" mimeType:@"audio/AMR"];
        } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [hud hide:NO];
            [ProgressHUD showSuccess:@"发送成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        } fail:^(NSString *errMsg) {
            [hud hide:NO];
            [ProgressHUD showHintText:errMsg];
        }];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
