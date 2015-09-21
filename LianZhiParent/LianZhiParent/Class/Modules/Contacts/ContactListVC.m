//
//  ContactListVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "ContactListVC.h"
#import "JSMessagesViewController.h"
@implementation ContactListHeaderView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        _logoView = [[LogoView alloc] initWithFrame:CGRectMake(10, 3, (self.height - 3 * 2),self.height - 3 * 2)];
        [self addSubview:_logoView];
        
        _classLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_classLabel setBackgroundColor:[UIColor clearColor]];
        [_classLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [self addSubview:_classLabel];
        
        _schoolLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_schoolLabel setBackgroundColor:[UIColor clearColor]];
        [_schoolLabel setTextColor:[UIColor lightGrayColor]];
        [_schoolLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_schoolLabel];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_numLabel setBackgroundColor:[UIColor clearColor]];
        [_numLabel setTextColor:[UIColor lightGrayColor]];
        [_numLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_numLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
        
        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatButton setFrame:CGRectMake(self.width - 40 - 10, (self.height - 30) / 2, 40, 30)];
        [_chatButton addTarget:self action:@selector(onChatClicked) forControlEvents:UIControlEventTouchUpInside];
        [_chatButton setImage:[UIImage imageNamed:@"MassChatNormal"] forState:UIControlStateNormal];
        [_chatButton setImage:[UIImage imageNamed:@"MassChatHighlighted"] forState:UIControlStateHighlighted];
        [self addSubview:_chatButton];
    }
    return self;
}

- (void)setClassInfo:(ClassInfo *)classInfo
{
    _classInfo = classInfo;
    
    [_logoView setImageWithUrl:[NSURL URLWithString:classInfo.logo]];
    
    [_classLabel setText:classInfo.className];
    [_classLabel sizeToFit];
    [_classLabel setOrigin:CGPointMake(_logoView.right + 5, 7)];
    
    [_schoolLabel setText:self.classInfo.schoolInfo.schoolName];
    [_schoolLabel sizeToFit];
    [_schoolLabel setOrigin:CGPointMake(_logoView.right + 5, self.height - _schoolLabel.height - 7)];
    
    [_numLabel setText:[NSString stringWithFormat:@"(共%ld位老师)",(long)_classInfo.teachers.count]];
    [_numLabel sizeToFit];
    [_numLabel setOrigin:CGPointMake(_classLabel.right + 10, 8)];
}

- (void)onChatClicked
{
    JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
    [ApplicationDelegate popAndPush:chatVC];
}

@end

@interface ContactListVC ()

@end

@implementation ContactListVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurChildChanged) name:kUserCenterChangedCurChildNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurChildChanged) name:kUserInfoVCNeedRefreshNotificaiotn object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserInfoChanged) name:kUserInfoChangedNotification object:nil];
}

- (void)onCurChildChanged
{
    [_tableView reloadData];
}

- (void)onUserInfoChanged
{
    [_tableView reloadData];
}

#pragma mark UItableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [UserCenter sharedInstance].curChild.classes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ClassInfo *class = [UserCenter sharedInstance].curChild.classes[section];
    return class.teachers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *reuseHeaderID = @"HeaderView";
    ContactListHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseHeaderID];
    if(headerView == nil)
    {
        headerView = [[ContactListHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 50)];
    }
    ClassInfo *class = [UserCenter sharedInstance].curChild.classes[section];
    [headerView setClassInfo:class];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
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
    [cell setTeachInfo:[[class teachers] objectAtIndex:indexPath.row]];
    [cell setSchoolInfo:class.schoolInfo];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClassInfo *class = [UserCenter sharedInstance].curChild.classes[indexPath.section];
    TeacherInfo *teacherInfo = [[class teachers] objectAtIndex:indexPath.row];
    if(teacherInfo.mobile.length > 0)
    {
        TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消" action:nil];
        TNButtonItem *item = [TNButtonItem itemWithTitle:@"拨打" action:^{
//            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",teacherInfo.mobile];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            JSMessagesViewController *messageVC = [[JSMessagesViewController alloc] init];
            [ApplicationDelegate popAndPush:messageVC];
        }];
        TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:[NSString stringWithFormat:@"是否拨打电话%@",teacherInfo.mobile] buttonItems:@[cancelItem,item]];
        [alertView show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
