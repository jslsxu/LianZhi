//
//  StudentParentsVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/9/14.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "StudentParentsVC.h"
#import "JSMessagesViewController.h"

#define kCellHeight             46

@implementation ContactGroup

- (id)init
{
    self = [super init];
    if(self)
    {
        NSMutableArray *contactsArray = [[NSMutableArray alloc] initWithCapacity:0];
        [self setContacts:contactsArray];
    }
    return self;
}
@end

@implementation StudentParentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.width = kScreenWidth;
        self.moreOptionsButtonTitle = nil;
        _avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(10, (kCellHeight - 36) / 2, 36, 36)];
        [self.actualContentView addSubview:_avatarView];
        
        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatButton setUserInteractionEnabled:NO];
        [_chatButton setFrame:CGRectMake(self.width - 40 - 10, (self.height - 30) / 2, 40, 30)];
        [_chatButton setImage:[UIImage imageNamed:@"SingleChatNormal"] forState:UIControlStateNormal];
        [_chatButton setImage:[UIImage imageNamed:@"SignleChatHighlighted"] forState:UIControlStateHighlighted];
        [self.actualContentView addSubview:_chatButton];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, _chatButton.left - 10 - 55, kCellHeight)];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [self.actualContentView addSubview:_nameLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self.actualContentView addSubview:_sepLine];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.moreOptionsButton.width = 0;
}

- (void)setFamilyInfo:(FamilyInfo *)familyInfo
{
    _familyInfo = familyInfo;
    [_avatarView setImageWithUrl:[NSURL URLWithString:_familyInfo.avatar]];
    [_avatarView setStatus:_familyInfo.actived ? nil : @"未下载" ];
    
    [_nameLabel setText:_familyInfo.name];
}

- (void)setIsInBlackList:(BOOL)isInBlackList
{
    _isInBlackList = isInBlackList;
    self.deleteButtonTitle = _isInBlackList ? @"取消拉黑" : @"拉黑";
    [self.deleteButton setBackgroundColor:_isInBlackList ? [UIColor colorWithHexString:@"999999"] : [UIColor colorWithRed:246 / 25.f green:82 / 255.f blue:114 / 255.f alpha:1.f]];
}

@end

@interface StudentParentsVC ()
@property (nonatomic, strong)NSMutableArray *blackList;
@property (nonatomic, strong)NSArray *formatterMemberArray;
@end

@implementation StudentParentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%ld人",self.childInfo.family.count] style:UIBarButtonItemStyleBordered target:self action:nil];
    self.blackList = [NSMutableArray array];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.title = self.childInfo.name;
    [self requestBalckList];
}

- (void)setChildInfo:(ChildInfo *)childInfo
{
    _childInfo = childInfo;
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:0];
    for (FamilyInfo *item in _childInfo.family) {
        if(item.relation)
        {
            BOOL contains = NO;
            for (NSString *key in keys) {
                if([key isEqualToString:item.relation])
                    contains = YES;
            }
            if(contains)
                continue;
            else
                [keys addObject:item.relation];
        }
    }
    
    NSMutableArray *parentsArray = [NSMutableArray array];
    for (NSString *key in keys) {
        ContactGroup *group = [[ContactGroup alloc] init];
        [group setKey:key];
        [parentsArray addObject:group];
        for (FamilyInfo *item in _childInfo.family)
        {
            if([item.relation isEqualToString:key])
                [group.contacts addObject:item];
        }
    }
    self.formatterMemberArray = parentsArray;
}

- (void)requestBalckList
{
    __weak typeof(self) wself = self;
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/get_bl" method:REQUEST_GET type:REQUEST_REFRESH withParams:nil observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        if(responseObject.count > 0)
        {
            NSMutableArray *blackListArray = [NSMutableArray array];
            for (NSInteger i = 0; i < responseObject.count; i++)
            {
                TNDataWrapper *userInfoWrapper = [responseObject getDataWrapperForIndex:i];
                NSString *uid = [userInfoWrapper getStringForKey:@"uid"];
                [blackListArray addObject:uid];
            }
            wself.blackList = blackListArray;
        }
        [wself.tableView reloadData];
    } fail:^(NSString *errMsg) {
        
    }];
}

- (BOOL)isInBlackList:(NSString *)userID
{
    BOOL isIn = NO;
    for (NSString *uid in self.blackList)
    {
        if([userID isEqualToString:uid])
            isIn = YES;
    }
    return isIn;
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.formatterMemberArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ContactGroup *group = [self.formatterMemberArray objectAtIndex:section];
    return group.contacts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ContactGroup *group = [self.formatterMemberArray objectAtIndex:section];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 25)];
    [headerView setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, headerView.width - 15, headerView.height)];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"8e8e8e"]];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setText:group.key];
    [headerView addSubview:titleLabel];
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"ParentCell";
    StudentParentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[StudentParentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    ContactGroup *group = [self.formatterMemberArray objectAtIndex:indexPath.section];
    FamilyInfo *familyInfo = group.contacts[indexPath.row];
    [cell setFamilyInfo:familyInfo];
    [cell setDelegate:self];
    [cell setIsInBlackList:[self isInBlackList:familyInfo.uid]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ContactGroup *group = [self.formatterMemberArray objectAtIndex:indexPath.section];
    FamilyInfo *familyInfo = group.contacts[indexPath.row];
    if(familyInfo.actived)
    {
        JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
        [chatVC setChatType:ChatTypeParents];
        [chatVC setTargetID:familyInfo.uid];
        [chatVC setTo_objid:self.childInfo.uid];
        [chatVC setMobile:familyInfo.mobile];
        //    [chatVC setTitle:familyInfo.name];
        [chatVC setTitle:[NSString stringWithFormat:@"%@的%@",self.childInfo.name, familyInfo.relation]];
        [ApplicationDelegate popAndPush:chatVC];
    }
    else
    {
        TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消" action:nil];
        TNButtonItem *callItem = [TNButtonItem itemWithTitle:@"拨打电话" action:^{
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",familyInfo.mobile];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
        TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"该用户尚未下载使用连枝，您可打电话与用户联系" buttonItems:@[cancelItem, callItem]];
        [alertView show];
    }
}

- (void)contextMenuCellDidSelectDeleteOption:(DAContextMenuCell *)cell
{
    StudentParentCell *contentCell = (StudentParentCell *)cell;
    FamilyInfo *familyInfo = contentCell.familyInfo;
    BOOL isInBlackList = contentCell.isInBlackList;
    __weak typeof(self) wself = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:kStringFromValue(ChatTypeParents) forKey:@"to_type"];
    if(isInBlackList)
    {
            [params setValue:familyInfo.uid forKey:@"to_uid"];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/del_bl" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            NSMutableArray *deletedArray = [NSMutableArray array];
            for (NSString *uid in wself.blackList)
            {
                if([uid isEqualToString:familyInfo.uid])
                    [deletedArray addObject:uid];
            }
            [wself.blackList removeObjectsInArray:deletedArray];
            [wself.tableView reloadData];
        } fail:^(NSString *errMsg) {
            [wself.tableView reloadData];
        }];
    }
    else
    {
        [params setValue:familyInfo.uid forKey:@"to_id"];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/add_bl" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [wself.blackList addObject:familyInfo.uid];
            [wself.tableView reloadData];
        } fail:^(NSString *errMsg) {
            [wself.tableView reloadData];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
