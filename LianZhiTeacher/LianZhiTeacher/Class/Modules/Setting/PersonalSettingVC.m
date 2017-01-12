//
//  PersonalSettingVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/16.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "PersonalSettingVC.h"
#import "SettingDatePickerView.h"

@implementation PersonalSettingCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.width = kScreenWidth;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 150, 44)];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [self addSubview:_titleLabel];
        
        _switchCtl = [[UISwitch alloc] init];
        [_switchCtl setOnTintColor:[UIColor colorWithHexString:@"95e065"]];
        [_switchCtl setCenter:CGPointMake(self.width - 30 , self.height / 2)];
        [_switchCtl setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
        [_switchCtl addTarget:self action:@selector(onSwitch) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_switchCtl];
        
        _extraLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 100, 0, 80, self.height)];
        [_extraLabel setTextAlignment:NSTextAlignmentRight];
        [_extraLabel setBackgroundColor:[UIColor clearColor]];
        [_extraLabel setFont:[UIFont systemFontOfSize:12]];
        [_extraLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [self addSubview:_extraLabel];
        
    }
    return self;
}

- (void)setIsOn:(BOOL)isOn
{
    _isOn = isOn;
    _switchCtl.on = _isOn;
}

- (void)onSwitch
{
    _isOn = _switchCtl.isOn;
    if(self.switchBlk)
        self.switchBlk(_isOn);
}

@end

@interface PersonalSettingVC ()
@property (nonatomic, strong)NSArray *titleArray;
@end
@implementation PersonalSettingVC
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个性设置";
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView setSeparatorColor:kSepLineColor];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
    [self setupBottomView:bottomView];
    [_tableView setTableFooterView:bottomView];
    
    [self reloadData];
}

- (void)reloadData
{
    if([UserCenter sharedInstance].personalSetting.noDisturbing)
        self.titleArray = @[@[@"听筒模式"],@[@"仅WIFI下发送照片",@"自动省流量"],@[@"声音提醒",@"震动提醒"],@[@"免打扰模式",@"开始时间",@"结束时间"],@[@"清除缓存"]];
    else
        self.titleArray = @[@[@"听筒模式"],@[@"仅WIFI下发送照片",@"自动省流量"],@[@"声音提醒",@"震动提醒"],@[@"免打扰模式"],@[@"清除缓存"]];
    [_tableView reloadData];
}

- (void)setupBottomView:(UIView *)viewParent
{
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutButton addTarget:self action:@selector(onLogoutClicked) forControlEvents:UIControlEventTouchUpInside];
    [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutButton setFrame:CGRectMake(15, (viewParent.height - 35) / 2, viewParent.width - 15 * 2, 35)];
    [logoutButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"E82557"] size:logoutButton.size cornerRadius:15] forState:UIControlStateNormal];
    [viewParent addSubview:logoutButton];
}

- (void)onLogoutClicked
{
    TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消" action:nil];
    TNButtonItem *confirmItem = [TNButtonItem itemWithTitle:@"确定" action:^{
        [ApplicationDelegate logout];
    }];
    TNActionSheet *actionSheet = [[TNActionSheet alloc] initWithTitle:@"确定退出登录吗?" descriptionView:nil destructiveButton:cancelItem cancelItem:nil otherItems:@[confirmItem]];
    [actionSheet show];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = self.titleArray[section];
    return sectionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *cellID = [NSString stringWithFormat:@"PersoanlSettingCell%ld-%ld",(long)indexPath.section,(long)indexPath.row];
    PersonalSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[PersonalSettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    if(section == self.titleArray.count - 1)
    {
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [cell.switchCtl setHidden:YES];
        [NHFileManager totalCacheSizeWithCompletion:^(NSInteger totalSize) {
            [cell.extraLabel setText:[Utility sizeStrForSize:totalSize]];
        }];
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//        NSString *docDir = [paths objectAtIndex:0];
//        [cell.extraLabel setText:[Utility sizeAtPath:docDir diskMode:YES]];
    }
    else if(section == 3 && row > 0)
    {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.switchCtl setHidden:YES];
        if(row == 1)
            [cell.extraLabel setText:[UserCenter sharedInstance].personalSetting.startTime];
        else if(row == 2)
            [cell.extraLabel setText:[UserCenter sharedInstance].personalSetting.endTime];
    }
    else
    {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.switchCtl setHidden:NO];
        [cell.extraLabel setText:nil];
    }
    [cell.titleLabel setText:self.titleArray[section][row]];
    
    PersonalSetting *personalSetting = [UserCenter sharedInstance].personalSetting;
    BOOL onValue = NO;
    if(section == 0)
        onValue = personalSetting.earPhone;
    else if(section == 1)
    {
        if(row == 0)
            onValue = personalSetting.wifiSend;
        else
            onValue = personalSetting.autoSave;
    }
    else if(section == 2)
    {
        if(row == 0)
            onValue = personalSetting.soundOn;
        else
            onValue = personalSetting.shakeOn;
    }
    else
    {
        onValue = personalSetting.noDisturbing;
    }
    [cell setIsOn:onValue];
    [cell setSwitchBlk:^(BOOL isOn){
        if(section == 0)
            personalSetting.earPhone = isOn;
        else if(section == 1)
        {
            if(row == 0)
                personalSetting.wifiSend = isOn;
            else
                personalSetting.autoSave = isOn;
        }
        else if(section == 2)
        {
            if(row == 0)
                personalSetting.soundOn = isOn;
            else
                personalSetting.shakeOn = isOn;
        }
        else
        {
            personalSetting.noDisturbing = isOn;
            [[UserCenter sharedInstance] setNoDisturbindTime];
        }
        [self saveSettings];
        [self reloadData];
    }];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 4)
    {
        MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在清除缓存文件..." toView:ApplicationDelegate.window];
        [NHFileManager cleanCacheWithCompletion:^{
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [hud hide:NO];
            [ProgressHUD showHintText:@"清除缓存完成"];
        }];
    }
    else if (indexPath.section == 3 && indexPath.row > 0)
    {
        SettingDatePickerView *pickerView = [[SettingDatePickerView alloc] initWithType:SettingDatePickerTypeTime];
        [pickerView setBlk:^(NSString *dateStr){
            if(indexPath.row == 1)
            {
                [[UserCenter sharedInstance].personalSetting setStartTime:dateStr];
            }
            else
            {
                [[UserCenter sharedInstance].personalSetting setEndTime:dateStr];
            }
            [self saveSettings];
            [[UserCenter sharedInstance] setNoDisturbindTime];
            [self reloadData];
        }];
        [pickerView show];
    }
}

- (void)saveSettings
{
    [[UserCenter sharedInstance].personalSetting save];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPersonalSettingChangedNotification object:nil];
}

@end
