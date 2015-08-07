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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurSchoolChanged) name:kUserCenterChangedSchoolNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onCurSchoolChanged) name:kUserInfoVCNeedRefreshNotificaiotn object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserInfoChanged) name:kUserInfoChangedNotification object:nil];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 45)];
    [self setupHeaderView:headerView];
    [self.view addSubview:headerView];
    
    _classesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.bottom, self.view.width, self.view.height - headerView.height) style:UITableViewStylePlain];
    [_classesTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_classesTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_classesTableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [_classesTableView setSectionIndexColor:kCommonTeacherTintColor];
    [_classesTableView setDelegate:self];
    [_classesTableView setDataSource:self];
    [self.view addSubview:_classesTableView];
    
    _studentsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.bottom, self.view.width, self.view.height - headerView.height) style:UITableViewStylePlain];
    [_studentsTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_studentsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_studentsTableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [_studentsTableView setSectionIndexColor:kCommonTeacherTintColor];
    [_studentsTableView setDelegate:self];
    [_studentsTableView setDataSource:self];
    [self.view addSubview:_studentsTableView];
    
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
    UILabel* hintLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [hintLabel setBackgroundColor:[UIColor clearColor]];
    [hintLabel setText:@"联系人"];
    [hintLabel setTextColor:kCommonTeacherTintColor];
    [hintLabel setFont:[UIFont systemFontOfSize:16]];
    [hintLabel sizeToFit];
    [hintLabel setOrigin:CGPointMake(10, (viewParent.height - hintLabel.height) / 2)];
    [viewParent addSubview:hintLabel];
    
    if([[UserCenter sharedInstance] teachAtCurSchool])
    {
        _segCtrl = [[UISegmentedControl alloc] initWithItems:@[@"家长",@"同事"]];
        [_segCtrl setTintColor:kCommonTeacherTintColor];
        [_segCtrl setWidth:100];
        [_segCtrl setOrigin:CGPointMake(viewParent.width - 12 - _segCtrl.width, (viewParent.height - _segCtrl.height) / 2)];
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
        return _contactModel.students.count;
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
        ContactGroup *group = [_contactModel.students objectAtIndex:section];
        return group.contacts.count;
    }
    else
    {
        ContactGroup *group = [_contactModel.teachers objectAtIndex:section];
        return group.contacts.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _studentsTableView || tableView == _teacherTableView)
    {
        static NSString *cellID = @"ContactItemCell";
        ContactItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(nil == cell)
        {
            cell = [[ContactItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        ContactGroup *group = nil;
        if(tableView == _studentsTableView)
            group = [_contactModel.students objectAtIndex:indexPath.section];
        else
            group = [_contactModel.teachers objectAtIndex:indexPath.section];
        UserInfo *userInfo = [[group contacts] objectAtIndex:indexPath.row];
        [cell setUserInfo:userInfo];
        return cell;
    }
    else
    {
        static NSString *cellID = @"ClassItemCell";
        ClassItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(cell == nil)
        {
            cell = [[ClassItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
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
        ContactGroup *group = [_contactModel.students objectAtIndex:section];
        return group.key;
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
    else if(tableView == _studentsTableView)
        return [_contactModel studentsKeys];
    else
        return [_contactModel teacherKeys];
}

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
        ContactGroup *group = [_contactModel.students objectAtIndex:indexPath.section];
        StudentInfo *student = [group.contacts objectAtIndex:indexPath.row];
        ContactParentsVC *parentsVC = [[ContactParentsVC alloc] init];
        [parentsVC setStudentInfo:student];
        [self.navigationController pushViewController:parentsVC animated:YES];
    }
    else//同事
    {
        ContactGroup *group = [_contactModel.teachers objectAtIndex:indexPath.section];
        TeacherInfo *teacher = [group.contacts objectAtIndex:indexPath.row];
        if(teacher.mobile.length > 0)
        {
            TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消" action:nil];
            TNButtonItem *item = [TNButtonItem itemWithTitle:@"拨打" action:^{
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",teacher.mobile];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }];
            TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:[NSString stringWithFormat:@"是否拨打电话%@",teacher.mobile] buttonItems:@[cancelItem,item]];
            [alertView show];
        }

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
