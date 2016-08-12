//
//  ContactListVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "ContactListVC.h"
#import "JSMessagesViewController.h"
#import "ClassMemberVC.h"
#import "ContactParentsView.h"
@implementation ContactListHeaderView
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSize:CGSizeMake(kScreenWidth, 60)];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        _logoView = [[LogoView alloc] initWithFrame:CGRectMake(12, (self.height - 36) / 2, 36,36)];
        [self.contentView addSubview:_logoView];
        
        _classLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_classLabel setBackgroundColor:[UIColor clearColor]];
        [_classLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [self.contentView addSubview:_classLabel];
        
        _schoolLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_schoolLabel setBackgroundColor:[UIColor clearColor]];
        [_schoolLabel setTextColor:[UIColor colorWithHexString:@"02c994"]];
        [_schoolLabel setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:_schoolLabel];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_numLabel setBackgroundColor:[UIColor clearColor]];
        [_numLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_numLabel setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:_numLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self.contentView addSubview:_sepLine];
        
        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatButton setFrame:CGRectMake(self.width - 40, 0, 40, self.height)];
        [_chatButton addTarget:self action:@selector(onChatClicked) forControlEvents:UIControlEventTouchUpInside];
        [_chatButton setImage:[UIImage imageNamed:@"MassChatNormal"] forState:UIControlStateNormal];
        [self.contentView addSubview:_chatButton];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCoverButtonClicked)];
        [self.contentView addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setClassInfo:(ClassInfo *)classInfo
{
    _classInfo = classInfo;
    
    [_logoView setImageWithUrl:[NSURL URLWithString:classInfo.logo]];
    NSInteger vMargin = 12;
    [_classLabel setText:classInfo.name];
    [_classLabel sizeToFit];
    [_classLabel setOrigin:CGPointMake(_logoView.right + 5, vMargin)];
    
    [_schoolLabel setText:self.classInfo.school.schoolName];
    [_schoolLabel sizeToFit];
    [_schoolLabel setOrigin:CGPointMake(_classLabel.right + 5, _classLabel.centerY - _schoolLabel.height / 2)];
    
    [_numLabel setText:[NSString stringWithFormat:@"老师:%zd人 学生:%zd人",_classInfo.teachers.count, _classInfo.students.count]];
    [_numLabel sizeToFit];
    [_numLabel setOrigin:CGPointMake(_logoView.right + 5, self.height - vMargin - _numLabel.height)];
}

- (void)onCoverButtonClicked
{
    if(self.expandCallback){
        self.expandCallback();
    }
}

- (void)onChatClicked{
    if(self.chatCallback){
        self.chatCallback();
    }
}

@end

@interface ContactListVC ()
@property (nonatomic, strong)ContactParentsView*    parentsView;
@property (nonatomic, strong)NSMutableDictionary* expandDictionary;
@end

@implementation ContactListVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:ApplicationDelegate.homeVC.curChildrenSelectView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationItem setLeftBarButtonItem:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UserCenter sharedInstance] updateUserInfo];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kUserCenterChangedCurChildNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kUserInfoVCNeedRefreshNotificaiotn object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kUserInfoChangedNotification object:nil];
    [self reloadData];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissParentsView)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeGesture];
}

- (void)reloadData
{
    self.expandDictionary = [NSMutableDictionary dictionary];
    NSArray *classArray = [UserCenter sharedInstance].curChild.classes;
    BOOL expand = (classArray.count == 1);
    for (ClassInfo *classInfo in classArray) {
        [self.expandDictionary setValue:@(expand) forKey:classInfo.classID];
    }
    [_tableView reloadData];
}

- (void)dismissParentsView{
    if(self.parentsView.x < self.view.width){
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:0.3 animations:^{
            self.parentsView.x = self.view.width;
        }completion:^(BOOL finished) {
            
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
    }
}

- (void)showInfoWithStudentInfo:(ChildInfo *)studentInfo{
    if(self.parentsView == nil){
        self.parentsView = [[ContactParentsView alloc] initWithFrame:CGRectMake(self.view.width, 0, self.view.width - 60, self.view.height)];
        [self.view addSubview:self.parentsView];
    }
    [self.parentsView setStudentInfo:studentInfo];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.3 animations:^{
        self.parentsView.x = 60;
    }completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

#pragma mark UItableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [UserCenter sharedInstance].curChild.classes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ClassInfo *class = [UserCenter sharedInstance].curChild.classes[section];
    BOOL expand = [self.expandDictionary[class.classID] boolValue];
    if(expand){
        NSArray *teacherArray = class.teachers;
        NSArray *studentArray = class.students;
        return teacherArray.count + studentArray.count;
    }
    else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *reuseHeaderID = @"HeaderView";
    ContactListHeaderView *headerView = (ContactListHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseHeaderID];
    if(headerView == nil)
    {
        headerView = [[ContactListHeaderView alloc] initWithReuseIdentifier:reuseHeaderID];
    }
    ClassInfo *class = [UserCenter sharedInstance].curChild.classes[section];
    [headerView setClassInfo:class];
    __weak typeof(self) wself = self;
    [headerView setExpandCallback:^{
        BOOL expand = [wself.expandDictionary[class.classID] boolValue];
        [wself.expandDictionary setValue:@(!expand) forKey:class.classID];
        [tableView reloadData];
    }];
    [headerView setChatCallback:^{
        JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
        [chatVC setTo_objid:class.school.schoolID];
        [chatVC setTargetID:class.classID];
        [chatVC setTitle:class.name];
        [chatVC setChatType:ChatTypeClass];
        [CurrentROOTNavigationVC pushViewController:chatVC animated:YES];
    }];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ContactItemCell";
    ContactItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[ContactItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    ClassInfo *class = [UserCenter sharedInstance].curChild.classes[indexPath.section];
    NSArray *teacherArray = class.teachers;
    NSInteger row = indexPath.row;
    if(row <= teacherArray.count - 1){
        [cell setUserInfo:teacherArray[row]];
    }
    else{
        NSArray *students = class.students;
        [cell setUserInfo:students[row - teacherArray.count]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ContactItemCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UserInfo *userInfo = cell.userInfo;
    if([userInfo isKindOfClass:[TeacherInfo class]]){
        TeacherInfo *teacherInfo = (TeacherInfo *)userInfo;
        if(teacherInfo.actived)
        {
            NSInteger section = indexPath.section;
            ClassInfo *classInfo = [UserCenter sharedInstance].curChild.classes[section];
            JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
            [chatVC setChatType:ChatTypeTeacher];
            [chatVC setTo_objid:classInfo.school.schoolID];
            [chatVC setTargetID:teacherInfo.uid];
            [chatVC setMobile:teacherInfo.mobile];
            NSString *title = [NSString stringWithFormat:@"%@",teacherInfo.name];
            if(teacherInfo.course)
                title = [NSString stringWithFormat:@"%@(%@)",title, teacherInfo.course];
            [chatVC setTitle:title];
            [CurrentROOTNavigationVC pushViewController:chatVC animated:YES];
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

    }else{
        ChildInfo *childInfo = (ChildInfo *)userInfo;
        [self showInfoWithStudentInfo:childInfo];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self dismissParentsView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
