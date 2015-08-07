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
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 150, 44)];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_titleLabel setTextColor:[UIColor darkGrayColor]];
        [self addSubview:_titleLabel];
        
        _switch = [[UISwitch alloc] init];
        [_switch setOrigin:CGPointMake(self.width - 25 - _switch.width, (self.height - _switch.height) / 2)];
        [_switch addTarget:self action:@selector(onSwitch) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_switch];
        
    }
    return self;
}

- (void)setIsOn:(BOOL)isOn
{
    _isOn = isOn;
    _switch.on = _isOn;
}

- (void)onSwitch
{
    _isOn = _switch.isOn;
    if(self.switchBlk)
        self.switchBlk(_isOn);
}

@end

@implementation NoDisturbingCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 120, self.height)];
        [_titleLabel setTextColor:[UIColor lightGrayColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_titleLabel];
        
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 120 - 20, 0, 120, self.height)];
        [_valueLabel setTextAlignment:NSTextAlignmentRight];
        [_valueLabel setTextColor:[UIColor lightGrayColor]];
        [_valueLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_valueLabel];
    }
    return self;
}

@end


@implementation PersonalSettingVC
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"个性设置";
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setContentInset:UIEdgeInsetsMake(15, 0, 5, 0)];
    [self.view addSubview:_tableView];
    
    [_tableView reloadData];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 4 && [UserCenter sharedInstance].personalSetting.noDisturbing)
        return 3;
    else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titleArray = @[@"仅WIFI下发送照片",@"自动省流量",@"声音提醒",@"震动提醒",@"免打扰模式"];
    if(indexPath.row == 0)
    {
        NSString *cellID = [NSString stringWithFormat:@"PersoanlSettingCell%ld-%ld",(long)indexPath.section,(long)indexPath.row];
        PersonalSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(cell == nil)
        {
            cell = [[PersonalSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        if(indexPath.section == 4 && [UserCenter sharedInstance].personalSetting.noDisturbing)
            [cell setCellType:TableViewCellTypeFirst];
        else
            [cell setCellType:TableViewCellTypeSingle];
        [cell.titleLabel setText:titleArray[indexPath.section]];
        
        PersonalSetting *personalSetting = [UserCenter sharedInstance].personalSetting;
        NSInteger section = indexPath.section;
        BOOL onValue = NO;
        if(section == 0)
            onValue = personalSetting.wifiSend;
        else if(section == 1)
            onValue = personalSetting.autoSave;
        else if(section == 2)
            onValue = personalSetting.soundOn;
        else if(section == 3)
            onValue = personalSetting.shakeOn;
        else
        {
            onValue = personalSetting.noDisturbing;
        }
        [cell setIsOn:onValue];
        [cell setSwitchBlk:^(BOOL isOn){
            if(section == 0)
                personalSetting.wifiSend = isOn;
            else if(section == 1)
                personalSetting.autoSave = isOn;
            else if(section == 2)
                personalSetting.soundOn = isOn;
            else if(section == 3)
                personalSetting.shakeOn = isOn;
            else
            {
                personalSetting.noDisturbing = isOn;
                [_tableView reloadData];
            }
            [self saveSettings];
        }];
        return cell;
    }
    else
    {
        NSString *cellID = [NSString stringWithFormat:@"personalSettingTime%ld",(long)indexPath.row];
        NoDisturbingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(nil == cell)
        {
            cell = [[NoDisturbingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        }
        if(indexPath.row == 1)
        {
            [cell.titleLabel setText:@"开始时间"];
            [cell setCellType:TableViewCellTypeMiddle];
            [cell.valueLabel setText:[UserCenter sharedInstance].personalSetting.startTime];
        }
        else
        {
            [cell.titleLabel setText:@"结束时间"];
            [cell setCellType:TableViewCellTypeLast];
            [cell.valueLabel setText:[UserCenter sharedInstance].personalSetting.endTime];
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row > 0)
    {
        SettingDatePickerView *datePicker = [[SettingDatePickerView alloc] initWithType:SettingDatePickerTypeTime];
        [datePicker setBlk:^(NSString *dateStr){
            if(indexPath.row == 1)
                [UserCenter sharedInstance].personalSetting.startTime = dateStr;
            else if(indexPath.row == 2)
                [UserCenter sharedInstance].personalSetting.endTime = dateStr;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self saveSettings];
        }];
        [datePicker show];
    }
    
}

- (void)saveSettings
{
    [[UserCenter sharedInstance].personalSetting save];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPersonalSettingChangedNotification object:nil];
}

@end
