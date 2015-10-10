//
//  ContactListVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "ContactListVC.h"
#import "ContactStudentsVC.h"
#import "ContactParentsVC.h"
@implementation ContactListHeaderView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextColor:[UIColor lightGrayColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_titleLabel];
    }
    return self;
}
@end

@interface ContactListVC ()
@property (nonatomic, assign)NSInteger curIndex;
@end

@implementation ContactListVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *classes = [UserCenter sharedInstance].curSchool.classes;
    if(classes.count > 1)
        self.title = @"新聊天";
    else if(classes.count == 1)
    {
        ClassInfo *classInfo = classes[0];
        self.title = classInfo.className;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurSchoolChanged) name:kUserCenterChangedSchoolNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onCurSchoolChanged) name:kUserInfoVCNeedRefreshNotificaiotn object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserInfoChanged) name:kUserInfoChangedNotification object:nil];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 45)];
    [self setupHeaderView:headerView];
    [self.view addSubview:headerView];
    
    _classesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.bottom, self.view.width, self.view.height - headerView.height) style:UITableViewStyleGrouped];
    [_classesTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_classesTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_classesTableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [_classesTableView setSectionIndexColor:kCommonTeacherTintColor];
    [_classesTableView setDelegate:self];
    [_classesTableView setDataSource:self];
    [self.view addSubview:_classesTableView];
    
    _teacherTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.bottom, self.view.width, self.view.height - headerView.height) style:UITableViewStylePlain];
    [_teacherTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_teacherTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_teacherTableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [_teacherTableView setSectionIndexColor:kCommonTeacherTintColor];
    [_teacherTableView setDelegate:self];
    [_teacherTableView setDataSource:self];
    [self.view addSubview:_teacherTableView];
    
    _contactModel = [[ContactModel alloc] init];
    [self setCurIndex:0];
}

- (void)setupHeaderView:(UIView *)viewParent
{
    if([[UserCenter sharedInstance] teachAtCurSchool])
    {
        _segCtrl = [[UISegmentedControl alloc] initWithItems:@[@"家长",@"同事"]];
        [_segCtrl setTintColor:kCommonTeacherTintColor];
        [_segCtrl setWidth:160];
        [_segCtrl setOrigin:CGPointMake((viewParent.width - _segCtrl.width) / 2, (viewParent.height - _segCtrl.height) / 2)];
        [_segCtrl addTarget:self action:@selector(onSegmentValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_segCtrl setSelectedSegmentIndex:0];
        [viewParent addSubview:_segCtrl];
    }

}

- (void)onCurSchoolChanged
{
    [_contactModel refresh];
    [_classesTableView reloadData];
    [_teacherTableView reloadData];
    [self setCurIndex:self.curIndex];
}

- (void)onUserInfoChanged
{
    [self onCurSchoolChanged];
}

- (void)onSegmentValueChanged:(id)sender
{
    UISegmentedControl *segCtrl = (UISegmentedControl *)sender;
    NSInteger selectedIndex = segCtrl.selectedSegmentIndex;
    [self setCurIndex:selectedIndex];
}

- (void)setCurIndex:(NSInteger)curIndex
{
    _curIndex = curIndex;
    if([UserCenter sharedInstance].teachAtCurSchool)
    {
        if(_curIndex == 0)
        {
            _classesTableView.hidden = NO;
            _teacherTableView.hidden = YES;
        }
        else
        {
            _classesTableView.hidden = YES;
            _teacherTableView.hidden = NO;
        }

    }
    else
    {
        _classesTableView.hidden = YES;
        _teacherTableView.hidden = NO;
    }
}


#pragma mark UItableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == _teacherTableView)
        return 30;
    else
        return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == _classesTableView)
        return [UserCenter sharedInstance].curSchool.classes.count;
    else
        return _contactModel.teachers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _classesTableView)
    {
        ClassInfo *classInfo = [UserCenter sharedInstance].curSchool.classes[section];
        return classInfo.students.count + 1;
    }
    else
    {
        ContactGroup *group = [_contactModel.teachers objectAtIndex:section];
        return group.contacts.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _teacherTableView)
    {
        NSString *cellID = @"ContactItemCell";
        ContactItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(nil == cell)
        {
            cell = [[ContactItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        [cell setDelegate:self];
        ContactGroup *group = [_contactModel.teachers objectAtIndex:indexPath.section];
        UserInfo *userInfo = [[group contacts] objectAtIndex:indexPath.row];
        [cell setUserInfo:userInfo];
        return cell;
    }
    else
    {
        if(indexPath.row == 0)
        {
            NSString *cellID = @"ClassItemCell";
            ClassItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if(cell == nil)
            {
                cell = [[ClassItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            NSArray *classes = [UserCenter sharedInstance].curSchool.classes;
            ClassInfo *classInfo = classes[indexPath.section];
            [cell setClassInfo:classInfo];
            return cell;
        }
        else
        {
            NSString *cellID = @"ContactItemCell";
            ContactItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if(cell == nil)
            {
                cell = [[ContactItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            NSArray *classes = [UserCenter sharedInstance].curSchool.classes;
            ClassInfo *classInfo = classes[indexPath.section];
            [cell setUserInfo:classInfo.students[indexPath.row - 1]];
            return cell;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(tableView == _classesTableView)
    {
        return nil;
    }
    else
    {
        ContactGroup *group = [_contactModel.teachers objectAtIndex:section];
        return group.key;
    }
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if(tableView == _classesTableView)
        return nil;
    else
        return [_contactModel teacherKeys];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(tableView == _classesTableView)
    {
        NSArray *classes = [UserCenter sharedInstance].curSchool.classes;
        if(indexPath.row == 0)
        {
            ClassInfo *classInfo = classes[indexPath.section];
            JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
            [chatVC setTo_objid:[UserCenter sharedInstance].curSchool.schoolID];
            [chatVC setTargetID:classInfo.classID];
            [chatVC setChatType:ChatTypeClass];
            [chatVC setTitle:classInfo.className];
            [ApplicationDelegate popAndPush:chatVC];
        }
        else
        {
            ClassInfo *classInfo = [classes objectAtIndex:indexPath.section];
            StudentInfo *studentInfo = [classInfo.students objectAtIndex:indexPath.row];
            ContactParentsVC *parentsVC = [[ContactParentsVC alloc] init];
            [parentsVC setStudentInfo:studentInfo];
            [self.navigationController pushViewController:parentsVC animated:YES];
        }
    }
    else//同事
    {
        ContactGroup *group = [_contactModel.teachers objectAtIndex:indexPath.section];
        TeacherInfo *teacher = [group.contacts objectAtIndex:indexPath.row];
        JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
        [chatVC setTo_objid:[UserCenter sharedInstance].curSchool.schoolID];
        [chatVC setTargetID:teacher.uid];
        [chatVC setChatType:ChatTypeTeacher];
        [chatVC setMobile:teacher.mobile];
        [chatVC setTitle:teacher.name];
        [ApplicationDelegate popAndPush:chatVC];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
