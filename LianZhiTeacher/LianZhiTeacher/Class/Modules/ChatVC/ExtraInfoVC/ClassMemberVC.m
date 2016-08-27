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
#import "ChatTeacherInfoVC.h"
#import "ChatParentInfoVC.h"

@implementation UserGroup

- (void)addGroup:(UserGroup *)userGroup{
    NSMutableArray *labelArray = [NSMutableArray arrayWithArray:self.labelArray];
    NSMutableArray *userArray = [NSMutableArray arrayWithArray:self.users];
    [labelArray addObjectsFromArray:userGroup.labelArray];
    [userArray addObjectsFromArray:userGroup.users];
    self.labelArray = labelArray;
    self.users = userArray;
}
@end

@implementation MemberSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self){
        [self setSize:CGSizeMake(kScreenWidth, 20)];
        [self.contentView setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.width - 10 * 2, self.height)];
        [_titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_titleLabel setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = [title copy];
    [_titleLabel setText:_title];
}
@end


@implementation MemberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSize:CGSizeMake(kScreenWidth, 45)];
        _avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(10, (self.height - 32) / 2, 32, 32)];
        [self addSubview:_avatarView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 180, self.height)];
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
    [_nameLabel setText:_userInfo.name];
    [_avatarView setImageWithUrl:[NSURL URLWithString:_userInfo.avatar]];
    [_avatarView setStatus:_userInfo.actived ? nil : @"未下载"];
}

- (void)setLabel:(NSString *)label{
    if(label.length > 0){
        _label = [label copy];
        [_nameLabel setText:_label];
    }
}

@end

@interface ClassMemberVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)NSMutableArray *sourceArray;
@property (nonatomic, strong)UITableView*   tableView;
@end

@implementation ClassMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.atCallback && self.cancelCallback){
        self.title = @"选择提醒的人";
        self.navigationItem.leftBarButtonItem  =[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    }
    else{
        self.title = @"群成员";
    }
    
    self.sourceArray = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [_tableView setSectionIndexColor:[UIColor colorWithHexString:@"666666"]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
    
    [self loadData];
}

- (void)dismiss{
    if(self.cancelCallback){
        self.cancelCallback();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadData{
    @weakify(self)
    if(self.classID)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:self.classID forKey:@"class_id"];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"app/contact_of_class" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            @strongify(self)
            TNDataWrapper *classWrapper = [responseObject getDataWrapperForKey:@"class"];
            NSArray *teacherArray = [TeacherInfo nh_modelArrayWithJson:[classWrapper getDataWrapperForKey:@"teachers"].data];
            NSArray *studentArray = [StudentInfo nh_modelArrayWithJson:[classWrapper getDataWrapperForKey:@"students"].data];
            
            UserGroup *teacherGroup = [[UserGroup alloc] init];
            [teacherGroup setTitle:@"教师"];
            [teacherGroup setIndexkey:@"师"];
            [teacherGroup setUsers:teacherArray];
            [self.sourceArray addObject:teacherGroup];

            NSMutableArray *studentGroupArray = [NSMutableArray array];
            for (StudentInfo *childInfo in studentArray) {
                UserGroup *studentGroup = [[UserGroup alloc] init];
                [studentGroup setChildID:childInfo.uid];
                [studentGroup setUsers:childInfo.family];
                [studentGroup setIndexkey:childInfo.first_letter];
                [studentGroup setTitle:childInfo.first_letter];
                
                NSMutableArray *labelArray = [NSMutableArray array];
                for (FamilyInfo *family in childInfo.family) {
                    [labelArray addObject:[NSString stringWithFormat:@"%@的%@",childInfo.name, family.relation]];
                }
                [studentGroup setLabelArray:labelArray];
                
                [studentGroupArray addObject:studentGroup];
            }
            [studentGroupArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                UserGroup *firstGroup = (UserGroup *)obj1;
                UserGroup *secondGroup = (UserGroup *)obj2;
                return [firstGroup.title compare:secondGroup.title];
            }];
            UserGroup *preGroup = nil;
            NSMutableArray *deleteArray = [NSMutableArray array];
            for (UserGroup *userGroup in studentGroupArray) {
                if([userGroup.indexkey isEqualToString:preGroup.indexkey]){
                    [preGroup addGroup:userGroup];
                    [deleteArray addObject:userGroup];
                }
                else{
                    preGroup = userGroup;
                }
            }
            if(deleteArray.count > 0){
                [studentGroupArray removeObjectsInArray:deleteArray];
            }
            [self.sourceArray addObjectsFromArray:studentGroupArray];
            [self.tableView reloadData];
        } fail:^(NSString *errMsg) {
            
        }];
    }
    else if(self.groupID)
    {
        for (TeacherGroup *teacherGroup in [UserCenter sharedInstance].curSchool.groups) {
            if([teacherGroup.groupID isEqualToString:self.groupID]){
                NSMutableDictionary *groupDic = [NSMutableDictionary dictionary];
                for (TeacherInfo *teacherInfo in teacherGroup.teachers) {
                    NSString *indexKey = teacherInfo.first_letter;
                    NSMutableArray *users = groupDic[indexKey];
                    if(users == nil){
                        users = [NSMutableArray array];
                        [groupDic setValue:users forKey:indexKey];
                        UserGroup *userGroup = [[UserGroup alloc] init];
                        [userGroup setTitle:teacherInfo.first_letter];
                        [userGroup setIndexkey:teacherInfo.first_letter];
                        [userGroup setUsers:users];
                        [self.sourceArray addObject:userGroup];
                    }
                    [users addObject:teacherInfo];
                }
                [self.sourceArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    UserGroup *firstGroup = (UserGroup *)obj1;
                    UserGroup *secondGroup = (UserGroup *)obj2;
                    return [firstGroup.indexkey compare:secondGroup.indexkey];
                }];
            }
        }
        [self.tableView reloadData];
    }

}

#pragma mark


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sourceArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UserGroup *group = self.sourceArray[section];
    return group.users.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *titleArray = [NSMutableArray array];
    for (UserGroup *group in self.sourceArray) {
        if(group.indexkey)
            [titleArray addObject:group.indexkey];
        else{
            [titleArray addObject:@""];
        }
    }
    return titleArray;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *reuseID = @"Memberheader";
    MemberSectionHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseID];
    if(headerView == nil){
        headerView = [[MemberSectionHeader alloc] initWithReuseIdentifier:reuseID];
    }
    UserGroup *group = self.sourceArray[section];
    [headerView setTitle:group.title];
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
    UserGroup *group = self.sourceArray[indexPath.section];
    UserInfo *userInfo = group.users[indexPath.row];
    [cell setUserInfo:userInfo];
    [cell setLabel:group.labelArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserGroup *group = self.sourceArray[indexPath.section];
    UserInfo *userInfo = group.users[indexPath.row];
    if(self.atCallback){
        NSString *label = group.labelArray[indexPath.row];
        if(label.length > 0){
            userInfo.name = label;
        }
        self.atCallback(userInfo);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        if([userInfo isKindOfClass:[TeacherInfo class]]){
            ChatTeacherInfoVC *teacherVC = [[ChatTeacherInfoVC alloc] init];
            [teacherVC setUid:userInfo.uid];
            [self.navigationController pushViewController:teacherVC animated:YES];
        }
        else{
            ChatParentInfoVC *parentVC = [[ChatParentInfoVC alloc] init];
            [parentVC setUid:userInfo.uid];
            [parentVC setChildID:group.childID];
            [self.navigationController pushViewController:parentVC animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
