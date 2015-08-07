//
//  ExchangeSchoolVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/2/5.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ExchangeSchoolVC.h"

@implementation SchoolInfoCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, self.width - 15 * 2, 60)];
        [_bgImageView setImage:[[UIImage imageNamed:MJRefreshSrcName(@"CellBGFirst.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [self addSubview:_bgImageView];
        
        _logoView = [[LogoView alloc] initWithFrame:CGRectMake(30, 10, 40, 40)];
        [self addSubview:_logoView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setFont:[UIFont systemFontOfSize:17]];
        [_nameLabel setTextColor:[UIColor grayColor]];
        [self addSubview:_nameLabel];
        
        _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MJRefreshSrcName(@"BlueRightArrow.png")]];
        [_arrowImage setOrigin:CGPointMake(self.width - _arrowImage.width - 30, (60 - _arrowImage.height) / 2)];
        [self addSubview:_arrowImage];
    }
    return self;
}


- (void)setSchoolInfo:(SchoolInfo *)schoolInfo
{
    _schoolInfo = schoolInfo;
    [_logoView setImageWithUrl:[NSURL URLWithString:_schoolInfo.logoUrl]];
    [_nameLabel setText:_schoolInfo.schoolName];
    [_nameLabel sizeToFit];
    [_nameLabel setOrigin:CGPointMake(_logoView.right + 10, (60 - _nameLabel.height) / 2)];
}

@end

@implementation SchoolMessageCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, self.width - 15 * 2, 60)];
        [_bgImageView setImage:[[UIImage imageNamed:MJRefreshSrcName(@"CellBGLast.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [self addSubview:_bgImageView];
        
        _logoView = [[LogoView alloc] initWithFrame:CGRectMake(30, 10, 40, 40)];
        [self addSubview:_logoView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_logoView.right + 10, 10, 200, 20)];
        [_nameLabel setFont:[UIFont systemFontOfSize:16]];
        [_nameLabel setTextColor:[UIColor grayColor]];
        [self addSubview:_nameLabel];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(_logoView.right + 10, 30, 200, 15)];
        [_messageLabel setTextColor:[UIColor grayColor]];
        [_messageLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:_messageLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setTextColor:[UIColor grayColor]];
        [_timeLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:_timeLabel];
    }
    return self;
}


- (void)setMessageGroup:(MessageGroupItem *)messageGroup
{
    _messageGroup = messageGroup;
    [_nameLabel setText:_messageGroup.fromInfo.name];
    [_messageLabel setText:_messageGroup.content];
    [_timeLabel setText:_messageGroup.formatTime];
    [_timeLabel sizeToFit];
    [_timeLabel setOrigin:CGPointMake(self.width - _timeLabel.width - 25, 10)];
}
@end

@implementation ExchangeSchoolVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"切换学校";
    _schools = [[NSMutableArray alloc] initWithCapacity:0];
    SchoolInfo *curSchool = [UserCenter sharedInstance].curSchool;
    for (SchoolInfo *school in [UserCenter sharedInstance].userData.schools) {
        if(![curSchool.schoolID isEqualToString:school.schoolID])
            [_schools addObject:school];
    }
    
    _messages = [[NSMutableArray alloc] initWithArray:_schools];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%ld所",(long)[UserCenter sharedInstance].userData.schools.count] style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.view setBackgroundColor:[UIColor colorWithRed:229 / 255.0 green:229 / 255.0 blue:229 / 255.0 alpha:1.f]];
}

- (void)setupSubviews
{
    if(nil == _tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 100) style:UITableViewStylePlain];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [self.view addSubview:_tableView];
    }
    
    if(nil == _curSchoolView)
    {
        _curSchoolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 100, self.view.width, 100)];
        [self setupCurSchoolView:_curSchoolView];
        [self.view addSubview:_curSchoolView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
        [_curSchoolView addGestureRecognizer:tapGesture];
    }
    
    [self requestData];
}

- (void)setupCurSchoolView:(UIView *)viewParent
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:MJRefreshSrcName(@"GrayBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    [bgImageView setFrame:CGRectInset(viewParent.bounds, 15, 15)];
    [viewParent addSubview:bgImageView];
    
    LogoView *logoView = [[LogoView alloc] initWithFrame:CGRectMake(10, 10, bgImageView.height - 10 * 2, bgImageView.height - 10 * 2)];
    [logoView setImageWithUrl:[NSURL URLWithString:[UserCenter sharedInstance].curSchool.logoUrl]];
    [bgImageView addSubview:logoView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [nameLabel setFont:[UIFont systemFontOfSize:17]];
    [nameLabel setTextColor:[UIColor grayColor]];
    [nameLabel setText:[NSString stringWithFormat:@"%@(当前)",[UserCenter sharedInstance].curSchool.schoolName]];
    [nameLabel sizeToFit];
    [nameLabel setOrigin:CGPointMake(logoView.right + 10, (bgImageView.height - nameLabel.height) / 2)];
    [bgImageView addSubview:nameLabel];
    
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MJRefreshSrcName(@"WhiteRightArrow.png")]];
    [arrow setOrigin:CGPointMake(bgImageView.width - arrow.width - 15, (bgImageView.height - arrow.height) / 2)];
    [bgImageView addSubview:arrow];
    
}

- (void)requestData
{
    for (SchoolInfo *schoolInfo in _messages) {
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/index" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"school_id":schoolInfo.schoolID} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                TNDataWrapper *listWrapper = [responseObject getDataWrapperForKey:@"list"];
                if(listWrapper.count > 0)
                {
                    MessageGroupItem *groupItem = [[MessageGroupItem alloc] init];
                    for (NSInteger i = 0; i < listWrapper.count; i++) {
                         TNDataWrapper *firstMessageWrapper = [listWrapper getDataWrapperForIndex:0];
                        NSInteger unread = [firstMessageWrapper getIntegerForKey:@"unread"];
                        if(unread > 0)
                        {
                            [groupItem parseData:firstMessageWrapper];
                            [_messages replaceObjectAtIndex:[_messages indexOfObject:schoolInfo] withObject:groupItem];
                            [_tableView reloadData];
                            break;
                        }
                    }
                }
        } fail:^(NSString *errMsg) {
            
        }];
    }
}

- (void)onTap
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteNotifications
{
    [_messages removeAllObjects];
    [_messages addObjectsFromArray:_schools];
    [_tableView reloadData];
    [[UserCenter sharedInstance].statusManager setNotice:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kStatusChangedNotification object:nil];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _schools.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id item = [_messages objectAtIndex:section];
    if([item isKindOfClass:[MessageGroupItem class]])
        return 2;
    else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *headerID = @"headerID";
    UIView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if(nil == headerView)
    {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 15)];
        [headerView setBackgroundColor:[UIColor clearColor]];
    }
    return headerView;

}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [deleteButton setImage:[UIImage imageNamed:MJRefreshSrcName(@"MessageTrash.png")] forState:UIControlStateNormal];
//    [deleteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [deleteButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
//    [deleteButton setTitle:@"清空快捷提醒" forState:UIControlStateNormal];
//    [deleteButton setFrame:CGRectMake(0, 0, tableView.width, 60)];
//    [deleteButton addTarget:self action:@selector(deleteNotifications) forControlEvents:UIControlEventTouchUpInside];
//    
//    BOOL hasNew = NO;
//    for (id item in _messages) {
//        if([item isKindOfClass:[MessageGroupItem class]])
//            hasNew = YES;
//    }
//    [deleteButton setHidden:!hasNew];
//    return deleteButton;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 60;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        static NSString *cellID = @"SchoolCell";
        SchoolInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(nil == cell)
            cell = [[SchoolInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell setSchoolInfo:_schools[indexPath.section]];
        return cell;
    }
    else
    {
        static NSString *schoolCellID = @"SchoolMessagecell";
        SchoolMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:schoolCellID];
        if(nil == cell)
            cell = [[SchoolMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:schoolCellID];
        [cell setMessageGroup:[_messages objectAtIndex:indexPath.section]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SchoolInfo *selectedSchool = _schools[indexPath.section];
    if(indexPath.row == 0)
    {
        [[UserCenter sharedInstance] changeCurSchool:selectedSchool];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (indexPath.row == 1)
    {
        [[UserCenter sharedInstance] changeCurSchool:selectedSchool];
        [ApplicationDelegate.homeVC switchToIndex:0];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
