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
        [_nameLabel setText:[(TeacherInfo *)userInfo teacherName]];
    else if([_userInfo isKindOfClass:[ChildInfo class]])
        [_nameLabel setText:[(ChildInfo *)_userInfo name]];
    [_avatarView setImageWithUrl:[NSURL URLWithString:_userInfo.avatar]];
}

@end

@interface ClassMemberVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)NSArray *teacherArray;
@property (nonatomic, strong)NSArray *studentArray;
@end

@implementation ClassMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
    
    [self requestData];
}

- (void)requestData
{
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"contact/list" method:REQUEST_GET type:REQUEST_REFRESH withParams:nil observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
//        TNDataWrapper *classesWrapper = [responseObject getDataWrapperForKey:@"class"];
        TNDataWrapper *classesWrapper = responseObject;
        if(classesWrapper.count > 0)
        {
            for (NSInteger i = 0; i < classesWrapper.count; i++)
            {
                TNDataWrapper *classWrapper = [classesWrapper getDataWrapperForIndex:i];
                if([self.classID isEqualToString:[classWrapper getStringForKey:@"id"]])
                {
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
                            ChildInfo *studentInfo = [[ChildInfo alloc] init];
                            [studentInfo parseData:studentItemWrapper];
                            [studentArray addObject:studentInfo];
                        }
                        self.studentArray = studentArray;
                    }
                }
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
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SingleChatNormal"]]];
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
        ChildInfo *childInfo = self.studentArray[indexPath.row];
        StudentParentsVC *studentParentsVC = [[StudentParentsVC alloc] init];
        [studentParentsVC setChildInfo:childInfo];
        [CurrentROOTNavigationVC pushViewController:studentParentsVC animated:YES];
    }
    else
    {
        TeacherInfo *teacherInfo = self.teacherArray[indexPath.row];
        JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
        [chatVC setTargetID:teacherInfo.uid];
        [chatVC setChatType:ChatTypeTeacher];
        [chatVC setTitle:teacherInfo.teacherName];
        [ApplicationDelegate popAndPush:chatVC];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
