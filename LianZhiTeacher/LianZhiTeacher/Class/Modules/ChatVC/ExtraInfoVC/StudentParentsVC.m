//
//  StudentParentsVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/9/14.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "StudentParentsVC.h"
#import "JSMessagesViewController.h"

@implementation StudentParentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _avatar = [[AvatarView alloc] initWithFrame:CGRectMake(15, 6, 32, 32)];
        [self addSubview:_avatar];
        
        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatButton setUserInteractionEnabled:NO];
        [_chatButton setFrame:CGRectMake(self.width - 40 - 10, (self.height - 30) / 2, 40, 30)];
        [_chatButton setImage:[UIImage imageNamed:@"ChatButtonNormal"] forState:UIControlStateNormal];
        [self addSubview:_chatButton];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 + _avatar.right, 0, _chatButton.left - 10 - (15 + _avatar.right), self.height)];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [self addSubview:_nameLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
    }
    return self;
}

- (void)setFamilyInfo:(FamilyInfo *)familyInfo
{
    _familyInfo = familyInfo;
    [_avatar setImageWithUrl:[NSURL URLWithString:_familyInfo.avatar]];
    [_avatar setStatus:_familyInfo.activited ? nil : @"未开通"];
    [_nameLabel setText:_familyInfo.name];
}

@end

@interface StudentParentsVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)NSArray *formatterMemberArray;
@end

@implementation StudentParentsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.studentInfo.name;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
}

- (void)setStudentInfo:(StudentInfo *)studentInfo
{
    _studentInfo = studentInfo;
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:0];
    for (FamilyInfo *item in _studentInfo.family) {
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
        for (FamilyInfo *item in _studentInfo.family)
        {
            if([item.relation isEqualToString:key])
                [group.contacts addObject:item];
        }
    }
    self.formatterMemberArray = parentsArray;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    ContactGroup *group = [self.formatterMemberArray objectAtIndex:section];
    return group.key;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"ParentCell";
    StudentParentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[StudentParentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.textLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
    }
    ContactGroup *group = [self.formatterMemberArray objectAtIndex:indexPath.section];
    FamilyInfo *familyInfo = group.contacts[indexPath.row];
    [cell setFamilyInfo:familyInfo];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ContactGroup *group = [self.formatterMemberArray objectAtIndex:indexPath.section];
    FamilyInfo *familyInfo = group.contacts[indexPath.row];
    JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
    [chatVC setChatType:ChatTypeParents];
    [chatVC setTargetID:familyInfo.uid];
    [chatVC setTo_objid:self.studentInfo.uid];
    [chatVC setMobile:familyInfo.mobile];
    [chatVC setTitle:familyInfo.name];
    [ApplicationDelegate popAndPush:chatVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
