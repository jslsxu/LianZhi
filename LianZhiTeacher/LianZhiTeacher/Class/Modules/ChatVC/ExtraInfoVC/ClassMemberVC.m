//
//  ClassMemberVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/9/14.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ClassMemberVC.h"
#import "JSMessagesViewController.h"
#import "StudentParentsVC.h"
@implementation MemberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(15, (self.height - 32) / 2, 32, 32)];
        [self addSubview:_avatarView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 180, self.height)];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_nameLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
    }
    return self;
}
- (void)setUserInfo:(UserInfo *)userInfo
{
    _userInfo = userInfo;
    if([_userInfo isKindOfClass:[TeacherInfo class]])
        [_nameLabel setText:[(TeacherInfo *)userInfo name]];
    else if([_userInfo isKindOfClass:[StudentInfo class]])
        [_nameLabel setText:[(StudentInfo *)_userInfo name]];
    [_avatarView setImageWithUrl:[NSURL URLWithString:_userInfo.avatar]];
    [_avatarView setStatus:_userInfo.actived ? nil : @"未下载"];
}

@end

@interface ClassMemberVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)NSArray *teacherArray;
@property (nonatomic, strong)NSArray *studentArray;
@end

@implementation ClassMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger spaceYStart = 0;
    if(self.showSound)
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
        [self setupHeaderView:headerView];
        [self.view addSubview:headerView];
        spaceYStart = 40;
    }

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, spaceYStart, self.view.width, self.view.height - 64 - spaceYStart) style:UITableViewStylePlain];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [_tableView setSectionIndexColor:[UIColor colorWithHexString:@"666666"]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
    
    [self requestData];
    if(self.showSound)
        [self requestSoundStats];
}

- (void)setupHeaderView:(UIView *)viewParent
{
    [viewParent setBackgroundColor:[UIColor colorWithHexString:@"0fabc1"]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 50, viewParent.height)];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setText:@"静音"];
    [viewParent addSubview:label];
    
    _soundSwitch = [[UISwitch alloc] init];
    [_soundSwitch setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
    [_soundSwitch setOrigin:CGPointMake(viewParent.width - 15 - _soundSwitch.width, (viewParent.height - _soundSwitch.height) / 2)];
    [_soundSwitch addTarget:self action:@selector(onSoundSwitchClicked) forControlEvents:UIControlEventValueChanged];
    [_soundSwitch setTintColor:[UIColor colorWithHexString:@"95e065"]];
    [viewParent addSubview:_soundSwitch];
}

- (void)onSoundSwitchClicked
{
    BOOL isOn = _soundSwitch.isOn;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.classID forKey:@"from_id"];
    [params setValue:kStringFromValue(ChatTypeClass) forKey:@"from_type"];
    [params setValue:isOn ? @"close" : @"open" forKey:@"sound"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/set_thread" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        
    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)requestSoundStats
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.classID forKey:@"from_id"];
    [params setValue:kStringFromValue(ChatTypeClass) forKey:@"from_type"];
//    [params setValue:[UserCenter sharedInstance].curSchool.schoolID forKey:@"objid"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/get_sound" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        NSString *status = [responseObject getStringForKey:@"sound"];
        if([status isEqualToString:@"open"])
            [_soundSwitch setOn:NO];
        else
            [_soundSwitch setOn:YES];
    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)requestData
{
    if(self.classID)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:self.classID forKey:@"class_id"];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"app/contact_of_class" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            TNDataWrapper *classWrapper = [responseObject getDataWrapperForKey:@"class"];
            if(classWrapper.count > 0)
            {
                
//                TNDataWrapper *schoolWrapper = [classWrapper getDataWrapperForKey:@"school"];
//                if(schoolWrapper.count > 0)
//                {
//                    SchoolInfo *schoolInfo = [[SchoolInfo alloc] init];
//                    [schoolInfo parseData:schoolWrapper];
//                    self.schooldInfo = schoolInfo;
//                }
                
                TNDataWrapper *teacherArrayWrapper = [classWrapper getDataWrapperForKey:@"teachers"];
                if(teacherArrayWrapper.count > 0)
                {
                    NSMutableArray *teacherArray = [NSMutableArray array];
                    for (NSInteger i = 0; i < teacherArrayWrapper.count; i++)
                    {
                        TNDataWrapper *teacherItemWrapper = [teacherArrayWrapper getDataWrapperForIndex:i];
                        TeacherInfo *teacherInfo = [[TeacherInfo alloc] init];
                        [teacherInfo parseData:teacherItemWrapper];
                        [teacherArray addObject:teacherInfo];
                    }
                    self.teacherArray = teacherArray;
                }
                
                TNDataWrapper *studentArrayWrapper = [classWrapper getDataWrapperForKey:@"students"];
                if(studentArrayWrapper.count > 0)
                {
                    NSMutableArray *studentArray = [NSMutableArray array];
                    for (NSInteger i = 0; i < studentArrayWrapper.count; i++)
                    {
                        TNDataWrapper *studentItemWrapper = [studentArrayWrapper getDataWrapperForIndex:i];
                        StudentInfo *studentInfo = [[StudentInfo alloc] init];
                        [studentInfo parseData:studentItemWrapper];
                        [studentArray addObject:studentInfo];
                    }
                    
                    NSMutableArray *students = [NSMutableArray array];
                    for (StudentInfo *childInfo in studentArray)
                    {
                        BOOL isIn = NO;
                        for (ContactGroup *group in students)
                        {
                            if([group.key isEqualToString:childInfo.first_letter])
                            {
                                isIn = YES;
                                [group.contacts addObject:childInfo];
                            }
                        }
                        if(!isIn)
                        {
                            ContactGroup *group = [[ContactGroup alloc] init];
                            [group setKey:childInfo.first_letter];
                            [group.contacts addObject:childInfo];
                            [students addObject:group];
                        }
                    }
                    
                    [students sortUsingComparator:^NSComparisonResult(ContactGroup* obj1, ContactGroup* obj2) {
                        NSString *index1 = obj1.key;
                        NSString *index2 = obj2.key;
                        return [index1 compare:index2];
                    }];
                    self.studentArray = students;
                    
                }
                [_tableView reloadData];
            }
        } fail:^(NSString *errMsg) {
            
        }];
    }
    else if(self.groupID)
    {
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"app/groups" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"school_id" : [UserCenter sharedInstance].curSchool.schoolID} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            TNDataWrapper *listWrappwr = [responseObject getDataWrapperForKey:@"list"];
            if(listWrappwr.count > 0)
            {
                for (NSInteger i = 0; i < listWrappwr.count; i ++)
                {
                    TNDataWrapper *itemWrapper = [listWrappwr getDataWrapperForIndex:i];
                    TeacherGroup *group = [[TeacherGroup alloc] init];
                    [group parseData:itemWrapper];
                    if([group.groupID isEqualToString:self.groupID])
                    {
                        self.teacherArray = group.teachers;
                        break;
                    }
                }
                [_tableView reloadData];
            }
        } fail:^(NSString *errMsg) {
            
        }];
    }
}

#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 + self.studentArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return self.teacherArray.count;
    else
    {
        ContactGroup *group = self.studentArray[section - 1];
        return group.contacts.count;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *titleArray = [NSMutableArray array];
    [titleArray addObject:@"师"];
    for (ContactGroup *group in self.studentArray)
    {
        [titleArray addObject:group.key];
    }
    return titleArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if(section == 0)
        title = @"教师";
    else
    {
        ContactGroup *group = self.studentArray[section - 1];
        title = group.key;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 25)];
    [headerView setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, headerView.width - 15, headerView.height)];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"8e8e8e"]];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setText:title];
    [headerView addSubview:titleLabel];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"MemberCell";
    MemberCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[MemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    if(indexPath.section == 0)
    {
        [cell setUserInfo:self.teacherArray[indexPath.row]];
//        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChatButtonNormal"]]];
        [cell setAccessoryView:nil];
    }
    else
    {
        ContactGroup *group = self.studentArray[indexPath.section - 1];
        StudentInfo *studentInfo = group.contacts[indexPath.row];
        [cell setUserInfo:studentInfo];
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section >= 1)
    {
        ContactGroup *group = self.studentArray[indexPath.section - 1];
        StudentInfo *studentInfo = group.contacts[indexPath.row];
        StudentParentsVC *studentParentsVC = [[StudentParentsVC alloc] init];
        [studentParentsVC setStudentInfo:studentInfo];
        [CurrentROOTNavigationVC pushViewController:studentParentsVC animated:YES];
    }
    else
    {
        TeacherInfo *teacherInfo = self.teacherArray[indexPath.row];
        if(teacherInfo.actived)
        {
            JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
            [chatVC setTo_objid:[UserCenter sharedInstance].curSchool.schoolID];
            [chatVC setTargetID:teacherInfo.uid];
            [chatVC setChatType:ChatTypeTeacher];
            [chatVC setMobile:teacherInfo.mobile];
            [chatVC setTitle:teacherInfo.name];
            [ApplicationDelegate popAndPush:chatVC];
        }
        else
        {
            TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消" action:nil];
            TNButtonItem *callItem = [TNButtonItem itemWithTitle:@"拨打电话" action:^{
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",teacherInfo.mobile];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }];
            TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"该用户尚未下载使用连枝，您可打电话与用户联系" buttonItems:@[cancelItem, callItem]];
            [alertView show];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
