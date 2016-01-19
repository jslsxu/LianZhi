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
    _contactModel = [[ContactModel alloc] init];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurSchoolChanged) name:kUserCenterChangedSchoolNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onCurSchoolChanged) name:kUserInfoVCNeedRefreshNotificaiotn object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserInfoChanged) name:kUserInfoChangedNotification object:nil];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 45)];
    [self setupHeaderView:headerView];
    [self.view addSubview:headerView];
//    if([UserCenter sharedInstance].curSchool.classNum > 0)
//        self.title = @"新聊天";
//    else
//    {
//        ClassInfo *classInfo = nil;
//        if([UserCenter sharedInstance].curSchool.classes.count > 0)
//            classInfo = [UserCenter sharedInstance].curSchool.classes[0];
//        else
//            classInfo = [UserCenter sharedInstance].curSchool.managedClasses[0];
//        self.title = classInfo.className;
//    }
    
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
    
    [self setCurIndex:0];
}

- (void)setupHeaderView:(UIView *)viewParent
{
    [viewParent setBackgroundColor:[UIColor colorWithHexString:@"0fabc1"]];
    NSMutableArray *titleArray = [NSMutableArray array];
    if(_contactModel.classes.count > 0 || _contactModel.students.count > 0)
        [titleArray addObject:@"家长"];
    if(_contactModel.teachers.count > 0)
        [titleArray addObject:@"同事"];
        _segCtrl = [[UISegmentedControl alloc] initWithItems:titleArray];
        [_segCtrl setTintColor:[UIColor colorWithHexString:@"96e065"]];
        [_segCtrl setWidth:160];
        [_segCtrl setOrigin:CGPointMake((viewParent.width - _segCtrl.width) / 2, (viewParent.height - _segCtrl.height) / 2)];
        [_segCtrl addTarget:self action:@selector(onSegmentValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_segCtrl setSelectedSegmentIndex:0];
        [viewParent addSubview:_segCtrl];

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
    _classesTableView.hidden = YES;
    _studentsTableView.hidden = YES;
    _teacherTableView.hidden = YES;
    if(_curIndex == 1)
    {
        _teacherTableView.hidden = NO;
    }
    else
    {
        if(_contactModel.students.count > 0)
        {
            [_studentsTableView setHidden:NO];
        }
        else if(_contactModel.classes.count > 0)
        {
            [_classesTableView setHidden:NO];
        }
        else if(_contactModel.teachers.count > 0)
            [_teacherTableView setHidden:NO];
    }
}


#pragma mark UItableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == _classesTableView)
        return 0;
    return 25;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == _classesTableView)
        return 1;
    else if(tableView == _studentsTableView)
        return _contactModel.students.count + 1;
    else
        return _contactModel.teachers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _classesTableView)
    {
        return _contactModel.classes.count;
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
        ClassInfo *classInfo = [_contactModel.classes objectAtIndex:indexPath.row];
        [cell setClassInfo:classInfo];
        return cell;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 25)];
    [headerView setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    NSString *title = nil;
    if(tableView == _classesTableView)
    {
        
    }
    else if(tableView == _studentsTableView)
    {
        if(section == 0)
        {
            title = @"群";
        }
        else
        {
            ContactGroup *group = [_contactModel.students objectAtIndex:section - 1];
            title = group.key;
        }
    }
    else
    {
        ContactGroup *group = [_contactModel.teachers objectAtIndex:section];
        title = group.key;
    }

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, headerView.width - 15, headerView.height)];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"8e8e8e"]];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setText:title];
    [headerView addSubview:titleLabel];
    return headerView;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if(tableView == _classesTableView)
//    {
//        ContactGroup *group = [_contactModel.classes objectAtIndex:section];
//        return group.key;
//    }
//    else if(tableView == _studentsTableView)
//    {
//        if(section == 0)
//        {
//            return @"群";
//        }
//        else
//        {
//            ContactGroup *group = [_contactModel.students objectAtIndex:section - 1];
//            return group.key;
//        }
//    }
//    else
//    {
//        ContactGroup *group = [_contactModel.teachers objectAtIndex:section];
//        return group.key;
//    }
//    
//}
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
        ClassInfo *classInfo = [_contactModel.classes objectAtIndex:indexPath.row];
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
        if([teacher isKindOfClass:[TeacherInfo class]])
        {
            if(teacher.activited)
            {
                [chatVC setTargetID:teacher.uid];
                [chatVC setChatType:ChatTypeTeacher];
                [chatVC setMobile:teacher.mobile];
                NSString *title = teacher.name;
                if(teacher.title.length)
                    title = [NSString stringWithFormat:@"%@(%@)",title,teacher.title];
                [chatVC setTitle:title];
            }
            else
            {
                TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消" action:nil];
                TNButtonItem *callItem = [TNButtonItem itemWithTitle:@"拨打电话" action:^{
                    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",teacher.mobile];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                }];
                TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"该用户尚未下载使用连枝，您可打电话与用户联系" buttonItems:@[cancelItem, callItem]];
                [alertView show];
                return;
            }
        }
        else if([teacher isKindOfClass:[TeacherGroup class]])
        {
            TeacherGroup *group = (TeacherGroup *)teacher;
            [chatVC setTargetID:group.groupID];
            [chatVC setChatType:ChatTypeGroup];
            [chatVC setTitle:group.groupName];
        }
        [ApplicationDelegate popAndPush:chatVC];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
