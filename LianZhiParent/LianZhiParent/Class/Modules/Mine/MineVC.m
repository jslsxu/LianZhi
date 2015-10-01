//
//  MineVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/8/8.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "MineVC.h"
#import "PersonalInfoVC.h"
#import "ChildrenInfoVC.h"
#import "PersonalSettingVC.h"
#import "AboutVC.h"
#define kUserInfoCellHeight                     75

@implementation USerInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.width = kScreenWidth;
        _avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(20, 10, 55, 55)];
        [_avatarView setImageWithUrl:[NSURL URLWithString:[UserCenter sharedInstance].userInfo.avatar]];
        [self addSubview:_avatarView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setTextColor:[UIColor grayColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setText:[UserCenter sharedInstance].userInfo.name];
        [_nameLabel sizeToFit];
        [_nameLabel setOrigin:CGPointMake(_avatarView.right + 10, 20)];
        [self addSubview:_nameLabel];
        
        _genderView = [[UIImageView alloc] initWithFrame:CGRectZero];
        GenderType gender = [UserCenter sharedInstance].userInfo.gender;
        if(gender == GenderFemale)
            [_genderView setImage:[UIImage imageNamed:@"GenderFemale"]];
        else
            [_genderView setImage:[UIImage imageNamed:@"GenderMale"]];
        [_genderView setFrame:CGRectMake(_nameLabel.right + 5, _nameLabel.y, 15, 15)];
        [self addSubview:_genderView];
        
        _idLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_idLabel setTextColor:[UIColor lightGrayColor]];
        [_idLabel setFont:[UIFont systemFontOfSize:14]];
        [_idLabel setText:[NSString stringWithFormat:@"连枝号:%@",[UserCenter sharedInstance].userInfo.uid]];
        [_idLabel sizeToFit];
        [_idLabel setOrigin:CGPointMake(_avatarView.right + 10, kUserInfoCellHeight - 20 - _idLabel.height)];
        [self addSubview:_idLabel];
    }
    return self;
}

@end

@implementation MineVC
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.title = @"我";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView setSeparatorColor:kSepLineColor];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    else if(section == 1)
        return 2;
    else
        return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if(section == 0)
        return kUserInfoCellHeight;
    else
        return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSString *reuseID = nil;
    if(section == 0)
    {
        reuseID = @"USerInfoCell";
        USerInfoCell *cell = (USerInfoCell *)[tableView dequeueReusableCellWithIdentifier:reuseID];
        if(cell == nil)
        {
            cell = [[USerInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DatePickerNext"]]];
        }
        return cell;
    }
    else
    {
        reuseID = @"PersonalCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
            [cell.textLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
            [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DatePickerNext"]]];
        }
        NSArray *imageArray = @[@[@"MineChildren",@"MineSetting"],@[@"MineAbout",@"MineContact"]];
        NSArray *titleArray = @[@[@"孩子档案",@"系统设置"],@[@"关于连枝",@"联系客服"]];
        [cell.imageView setImage:[UIImage imageNamed:imageArray[section - 1][indexPath.row]]];
        [cell.textLabel setText:titleArray[section - 1][indexPath.row]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *actionArray = @[@[@"PersonalInfoVC"],@[@"ChildrenInfoVC",@"PersonalSettingVC"],@[@"AboutVC",@"ContactServiceVC"]];
    TNBaseViewController *vc = [[NSClassFromString(actionArray[indexPath.section][indexPath.row]) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
