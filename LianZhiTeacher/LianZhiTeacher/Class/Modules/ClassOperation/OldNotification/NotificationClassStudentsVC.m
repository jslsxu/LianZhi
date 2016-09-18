//
//  NotificationClassStudentsVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/11.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "NotificationClassStudentsVC.h"
#import "ContactModel.h"

@implementation NotificationStudentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(10, (self.height - 32) / 2, 32, 32)];
        [self addSubview:_avatarView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarView.right + 10, 0, 0, 0)];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_nameLabel];
        
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarView.right + 10, 0, 0, 0)];
        [_infoLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [_infoLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_infoLabel];
        
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkButton setUserInteractionEnabled:NO];
        [_checkButton setFrame:CGRectMake(self.width - 20 - 20, (self.height - 20) / 2, 20, 20)];
        [_checkButton setImage:[UIImage imageNamed:@"ControlDefault"] forState:UIControlStateNormal];
        [_checkButton setImage:[UIImage imageNamed:@"ControlSelectAll"] forState:UIControlStateSelected];
        [self addSubview:_checkButton];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
        
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    if([modelItem isKindOfClass:[StudentInfo class]])
    {
        StudentInfo *studentInfo = (StudentInfo *)modelItem;
        [_avatarView sd_setImageWithURL:[NSURL URLWithString:studentInfo.avatar]];
        [_nameLabel setText:studentInfo.name];
        [_nameLabel sizeToFit];
        [_nameLabel setOrigin:CGPointMake(_avatarView.right + 10, (self.height - _nameLabel.height) / 2)];
        [_infoLabel setText:[NSString stringWithFormat:@"(%ld位家长)",(long)studentInfo.family.count]];
        [_infoLabel sizeToFit];
        [_infoLabel setOrigin:CGPointMake(_nameLabel.right + 10, (self.height - _infoLabel.height) / 2)];
    }
    else
    {
        TeacherInfo *teacherInfo = (TeacherInfo *)modelItem;
        [_avatarView sd_setImageWithURL:[NSURL URLWithString:teacherInfo.avatar]];
        [_nameLabel setText:teacherInfo.name];
        [_nameLabel sizeToFit];
        [_nameLabel setOrigin:CGPointMake(_avatarView.right + 10, (self.height - _nameLabel.height) / 2)];
        
        if(teacherInfo.label.length > 0)
        {
            [_infoLabel setHidden:NO];
            [_infoLabel setText:teacherInfo.label];
            [_infoLabel sizeToFit];
            [_infoLabel setOrigin:CGPointMake(_nameLabel.right + 10, (self.height - _infoLabel.height) / 2)];
        }
        else
            [_infoLabel setHidden:YES];
    }
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    [_checkButton setSelected:_checked];
}

@end

@interface NotificationClassStudentsVC ()

@end

@implementation NotificationClassStudentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.seletedArray = [NSMutableArray array];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(onSend)];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
- (BOOL)selectedForStudent:(StudentInfo *)studentInfo
{
    BOOL selected = NO;
    for (NSString *studentId in self.seletedArray)
    {
        if([studentId isEqualToString:studentInfo.uid])
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
    StudentInfo *studentInfo = group.contacts[indexPath.row];
    [cell onReloadData:studentInfo];
    [cell setChecked:[self selectedForStudent:studentInfo]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactGroup *group = self.students[indexPath.section];
    StudentInfo *studentInfo = group.contacts[indexPath.row];
    if([self selectedForStudent:studentInfo])
        [self.seletedArray removeObject:studentInfo.uid];
    else
    {
        [self.seletedArray addObject:studentInfo.uid];
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
    [params setValue:[NSString stringWithJSONObject:@[@{@"classid" : self.classInfo.classID,@"students":self.seletedArray}]] forKey:@"classes"];
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
