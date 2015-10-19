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
    [_avatarView setStatus:_userInfo.activited ? nil : @"未开通"];
}

@end

@interface ClassMemberVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)SchoolInfo* schooldInfo;
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
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
    
    [self requestData];
    if(self.showSound)
        [self requestSoundStats];
}

- (void)setupHeaderView:(UIView *)viewParent
{
    [viewParent setBackgroundColor:kCommonTeacherTintColor];
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
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.classID forKey:@"class_id"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"app/contact_of_class" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        TNDataWrapper *classWrapper = [responseObject getDataWrapperForKey:@"class"];
        if(classWrapper.count > 0)
        {
            
            TNDataWrapper *schoolWrapper = [classWrapper getDataWrapperForKey:@"school"];
            if(schoolWrapper.count > 0)
            {
                SchoolInfo *schoolInfo = [[SchoolInfo alloc] init];
                [schoolInfo parseData:schoolWrapper];
                self.schooldInfo = schoolInfo;
            }
            
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
                for (NSInteger i = 0; i < teacherArrayWrapper.count; i++)
                {
                    TNDataWrapper *studentItemWrapper = [studentArrayWrapper getDataWrapperForIndex:i];
                    StudentInfo *studentInfo = [[StudentInfo alloc] init];
                    [studentInfo parseData:studentItemWrapper];
                    [studentArray addObject:studentInfo];
                }
                self.studentArray = studentArray;
            }
            [_tableView reloadData];
        }
    } fail:^(NSString *errMsg) {
        
    }];
}

#pragma mark 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return self.teacherArray.count;
    else
        return self.studentArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return @"教师";
    else
        return @"学生";
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
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChatButtonNormal"]]];
    }
    else
    {
        [cell setUserInfo:self.studentArray[indexPath.row]];
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 1)
    {
        StudentInfo *studentInfo = self.studentArray[indexPath.row];
        StudentParentsVC *studentParentsVC = [[StudentParentsVC alloc] init];
        [studentParentsVC setStudentInfo:studentInfo];
        [CurrentROOTNavigationVC pushViewController:studentParentsVC animated:YES];
    }
    else
    {
        TeacherInfo *teacherInfo = self.teacherArray[indexPath.row];
        JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
        [chatVC setTo_objid:self.schooldInfo.schoolID];
        [chatVC setTargetID:teacherInfo.uid];
        [chatVC setChatType:ChatTypeTeacher];
        [chatVC setMobile:teacherInfo.mobile];
        [chatVC setTitle:teacherInfo.name];
        [ApplicationDelegate popAndPush:chatVC];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
