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
        
        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatButton setFrame:CGRectMake(self.width - 40 - 10, (self.height - 30) / 2, 40, 30)];
        [_chatButton addTarget:self action:@selector(onChatClicked) forControlEvents:UIControlEventTouchUpInside];
        [_chatButton setImage:[UIImage imageNamed:@"SingleChatNormal"] forState:UIControlStateNormal];
        [_chatButton setImage:[UIImage imageNamed:@"SignleChatHighlighted"] forState:UIControlStateHighlighted];
        [self addSubview:_chatButton];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
    }
    return self;
}

- (void)onChatClicked
{
    JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
    [ApplicationDelegate popAndPush:chatVC];
}

@end

@interface ClassMemberVC ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ClassMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
}


#pragma mark 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
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
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.chatButton setHidden:NO];
    }
    else
    {
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [cell.chatButton setHidden:YES];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 1)
    {
        StudentParentsVC *studentParentsVC = [[StudentParentsVC alloc] init];
        [CurrentROOTNavigationVC pushViewController:studentParentsVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
