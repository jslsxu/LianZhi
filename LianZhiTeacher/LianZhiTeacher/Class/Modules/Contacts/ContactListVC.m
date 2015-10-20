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
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurSchoolChanged) name:kUserCenterChangedSchoolNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onCurSchoolChanged) name:kUserInfoVCNeedRefreshNotificaiotn object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserInfoChanged) name:kUserInfoChangedNotification object:nil];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 45)];
    [self setupHeaderView:headerView];
    [self.view addSubview:headerView];
    
    if([UserCenter sharedInstance].curSchool.classes.count > 0)
        self.title = @"新聊天";
    else
    {
        ClassInfo *classInfo = [UserCenter sharedInstance].curSchool.classes[0];
        self.title = classInfo.className;
    }
    
    _classesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.bottom, self.view.width, self.view.height - headerView.height) style:UITableViewStylePlain];
    [_classesTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_classesTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_classesTableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [_classesTableView setSectionIndexColor:kCommonTeacherTintColor];
    [_classesTableView setDelegate:self];
    [_classesTableView setDataSource:self];
    [_classesTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_classesTableView];
    
    _studentsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.bottom, self.view.width, self.view.height - headerView.height) style:UITableViewStylePlain];
    [_studentsTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_studentsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_studentsTableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [_studentsTableView setSectionIndexColor:kCommonTeacherTintColor];
    [_studentsTableView setDelegate:self];
    [_studentsTableView setDataSource:self];
    [_studentsTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_studentsTableView];
    
    _teacherTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.bottom, self.view.width, self.view.height - headerView.height) style:UITableViewStylePlain];
    [_teacherTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_teacherTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_teacherTableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [_teacherTableView setSectionIndexColor:kCommonTeacherTintColor];
    [_teacherTableView setDelegate:self];
    [_teacherTableView setDataSource:self];
    [_teacherTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_teacherTableView];
    
    _contactModel = [[ContactModel alloc] init];
    [self setCurIndex:0];
}

- (void)setupHeaderView:(UIView *)viewParent
{
    [viewParent setBackgroundColor:[UIColor colorWithHexString:@"0fabc1"]];
    if([[UserCenter sharedInstance] teachAtCurSchool])
    {
        _segCtrl = [[UISegmentedControl alloc] initWithItems:@[@"家长",@"同事"]];
        [_segCtrl setTintColor:[UIColor colorWithHexString:@"96e065"]];
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
    [_studentsTableView reloadData];
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
            _studentsTableView.hidden = (_contactModel.students.count == 0);
            _classesTableView.hidden = (_contactModel.students.count > 0);
            _teacherTableView.hidden = YES;
        }
        else
        {
            _classesTableView.hidden = YES;
            _studentsTableView.hidden = YES;
            _teacherTableView.hidden = NO;
        }

    }
    else
    {
        _classesTableView.hidden = YES;
        _studentsTableView.hidden = YES;
        _teacherTableView.hidden = NO;
    }
}


#pragma mark UItableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == _classesTableView)
        return _contactModel.classes.count;
    else if(tableView == _studentsTableView)
        return _contactModel.students.count + 1;
    else
        return _contactModel.teachers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _classesTableView)
    {
        ContactGroup *group = [_contactModel.classes objectAtIndex:section];
        return group.contacts.count;
    }
    else if(tableView == _studentsTableView)
    {
        if(section == 0)
            return 1;
        else
        {
            ContactGroup *group = [_contactModel.students objectAtIndex:section - 1];
            return group.contacts.count;
        }
    }
    else
    {
        ContactGroup *group = [_contactModel.teachers objectAtIndex:section];
        return group.contacts.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _studentsTableView)
    {
        if(indexPath.section == 0)
        {
            NSString *cellID = @"ClassItemCell";
            ClassItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if(nil == cell)
            {
                cell = [[ClassItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            NSArray *classes = [UserCenter sharedInstance].curSchool.classes;
            ClassInfo *classInfo = nil;
            if(classes.count > 0)
                classInfo = classes[0];
            [cell setClassInfo:classInfo];
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
            [cell setDelegate:self];
            ContactGroup *group = [_contactModel.students objectAtIndex:indexPath.section - 1];
            UserInfo *userInfo = [[group contacts] objectAtIndex:indexPath.row];
            [cell setUserInfo:userInfo];
            return cell;
        }
    }
    else if(tableView == _teacherTableView)
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
        NSString *cellID = @"ClassItemCell";
        ClassItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(cell == nil)
        {
            cell = [[ClassItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        [cell.chatButton setHidden:YES];
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]]];
        ContactGroup *group = [_contactModel.classes objectAtIndex:indexPath.section];
        ClassInfo *classInfo = [group.contacts objectAtIndex:indexPath.row];
        [cell setClassInfo:classInfo];
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(tableView == _classesTableView)
    {
        ContactGroup *group = [_contactModel.classes objectAtIndex:section];
        return group.key;
    }
    else if(tableView == _studentsTableView)
    {
        if(section == 0)
        {
            return @"群";
        }
        else
        {
            ContactGroup *group = [_contactModel.students objectAtIndex:section - 1];
            return group.key;
        }
    }
    else
    {
        ContactGroup *group = [_contactModel.teachers objectAtIndex:section];
        return group.key;
    }
    
}
//
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    if(tableView == _classesTableView)
//        return nil;
//    else if(tableView == _studentsTableView)
//        return [_contactModel studentsKeys];
//    else
//        return [_contactModel teacherKeys];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(tableView == _classesTableView)
    {
        ContactGroup *group = [_contactModel.classes objectAtIndex:indexPath.section];
        ClassInfo *classInfo = [group.contacts objectAtIndex:indexPath.row];
        ContactStudentsVC *studentsVC = [[ContactStudentsVC alloc] init];
        [studentsVC setClassInfo:classInfo];
        [self.navigationController pushViewController:studentsVC animated:YES];
    }
    else if(tableView == _studentsTableView)
    {
        if(indexPath.section == 0)
        {
            ClassInfo *classInfo = [UserCenter sharedInstance].curSchool.classes[0];
            JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
            [chatVC setTo_objid:[UserCenter sharedInstance].curSchool.schoolID];
            [chatVC setTargetID:classInfo.classID];
            [chatVC setChatType:ChatTypeClass];
            [chatVC setTitle:classInfo.className];
            [ApplicationDelegate popAndPush:chatVC];
        }
        else
        {
            ContactGroup *group = [_contactModel.students objectAtIndex:indexPath.section - 1];
            StudentInfo *student = [group.contacts objectAtIndex:indexPath.row];
            ContactParentsVC *parentsVC = [[ContactParentsVC alloc] init];
            [parentsVC setStudentInfo:student];
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
        [chatVC setTitle:teacher.name];
        [ApplicationDelegate popAndPush:chatVC];
    }
}

//#pragma mark - ContactDelegate
//- (void)contactItemChatClicked:(UserInfo *)userInfo
//{
//    JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
//    [chatVC setTargetID:userInfo.uid];
//    [chatVC setChatType:ChatTypeTeacher];
//    [chatVC setTitle:userInfo.name];
//    [ApplicationDelegate popAndPush:chatVC];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
