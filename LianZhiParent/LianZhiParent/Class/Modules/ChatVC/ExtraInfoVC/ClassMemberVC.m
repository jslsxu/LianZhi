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
    {
        [_nameLabel setText:[(TeacherInfo *)userInfo teacherName]];
        [_avatarView setStatus:_userInfo.actived ? nil : @"未开通"];
    }
    else if([_userInfo isKindOfClass:[ChildInfo class]])
    {
        [_nameLabel setText:[(ChildInfo *)_userInfo name]];
        [_avatarView setStatus:nil];
    }
    [_avatarView setImageWithUrl:[NSURL URLWithString:_userInfo.avatar]];
}

@end

@interface ClassMemberVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)ClassInfo *classInfo;
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
    [viewParent setBackgroundColor:kCommonParentTintColor];
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
    [params setValue:self.classInfo.classID forKey:@"from_id"];
    [params setValue:kStringFromValue(ChatTypeClass) forKey:@"from_type"];
    [params setValue:isOn ? @"open" : @"close" forKey:@"sound"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/set_thread" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {

    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)requestData
{
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"contact/list" method:REQUEST_GET type:REQUEST_REFRESH withParams:nil observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        if(responseObject.count > 0)
        {
            TNDataWrapper *classWrapper = [responseObject getDataWrapperForIndex:0];
            ClassInfo *classInfo = [[ClassInfo alloc] init];
            [classInfo parseData:classWrapper];
            self.classInfo = classInfo;
        }
        [_tableView reloadData];
    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)requestSoundStats
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.classID forKey:@"from_id"];
    [params setValue:kStringFromValue(ChatTypeClass) forKey:@"from_type"];
    [params setValue:[UserCenter sharedInstance].curChild.uid forKey:@"objid"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/get_sound" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        NSString *status = [responseObject getStringForKey:@"sound"];
        if([status isEqualToString:@"open"])
            [_soundSwitch setOn:YES];
        else
            [_soundSwitch setOn:NO];
    } fail:^(NSString *errMsg) {
        
    }];
}

#pragma mark 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.showParentsOnly)
        return 1;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.showParentsOnly)
    {
        return self.classInfo.students.count;
    }
    else
    {
        if(section == 0)
            return self.classInfo.teachers.count;
        else
            return self.classInfo.students.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(!self.showParentsOnly)
    {
        if(section == 0)
            return @"教师";
        else
            return @"学生";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"MemberCell";
    MemberCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[MemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    if(self.showParentsOnly)
    {
        [cell setUserInfo:self.classInfo.students[indexPath.row]];
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]]];
    }
    else
    {
        if(indexPath.section == 0)
        {
            [cell setUserInfo:self.classInfo.teachers[indexPath.row]];
            [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SingleChatNormal"]]];
        }
        else
        {
            [cell setUserInfo:self.classInfo.students[indexPath.row]];
            [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]]];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(!self.showParentsOnly)
    {
        if(indexPath.section == 1)
        {
            ChildInfo *childInfo = self.classInfo.students[indexPath.row];
            StudentParentsVC *studentParentsVC = [[StudentParentsVC alloc] init];
            [studentParentsVC setChildInfo:childInfo];
            [CurrentROOTNavigationVC pushViewController:studentParentsVC animated:YES];
        }
        else
        {
            TeacherInfo *teacherInfo = self.classInfo.teachers[indexPath.row];
            JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
            [chatVC setTo_objid:self.classInfo.schoolInfo.schoolID];
            [chatVC setTargetID:teacherInfo.uid];
            [chatVC setChatType:ChatTypeTeacher];
            [chatVC setMobile:teacherInfo.mobile];
            NSString *title = teacherInfo.teacherName;
            if(teacherInfo.course)
                title = [NSString stringWithFormat:@"%@(%@)",teacherInfo.teacherName, teacherInfo.course];
            [chatVC setTitle:title];
            [ApplicationDelegate popAndPush:chatVC];
        }
    }
    else
    {
        ChildInfo *childInfo = self.classInfo.students[indexPath.row];
        StudentParentsVC *studentParentsVC = [[StudentParentsVC alloc] init];
        [studentParentsVC setChildInfo:childInfo];
        [CurrentROOTNavigationVC pushViewController:studentParentsVC animated:YES];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
