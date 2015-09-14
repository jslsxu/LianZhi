//
//  NotificationTargetSelectVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "NotificationTargetSelectVC.h"
#import "NotificationClassStudentsVC.h"
@implementation NotificationTargetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkButton setFrame:CGRectMake(30, 0, 20, self.height)];
        [_checkButton setUserInteractionEnabled:NO];
        [_checkButton setImage:[UIImage imageNamed:@"ControlSelectPart"] forState:UIControlStateNormal];
        [_checkButton setImage:[UIImage imageNamed:@"ControlSelectAll"] forState:UIControlStateSelected];
        [self addSubview:_checkButton];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_checkButton.right + 10, 0, 200, self.height)];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"767676"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:12]];
        [_nameLabel setText:@"我教授的半"];
        [self addSubview:_nameLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
        
        [self setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]]];
    }
    return self;
}

@end

@implementation NotificationGroupHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkButton setFrame:CGRectMake(20, 0, 20, self.height)];
        [_checkButton setUserInteractionEnabled:NO];
        [_checkButton setImage:[UIImage imageNamed:@"ControlSelectPart"] forState:UIControlStateNormal];
        [_checkButton setImage:[UIImage imageNamed:@"ControlSelectAll"] forState:UIControlStateSelected];
        [self addSubview:_checkButton];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_checkButton.right + 10, 0, 200, 50)];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"767676"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:12]];
        [_nameLabel setText:@"三年一班"];
        [self addSubview:_nameLabel];

    }
    return self;
}

@end

@interface NotificationTargetSelectVC ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation NotificationTargetSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    [headerView setBackgroundColor:kCommonTeacherTintColor];
    [self.view addSubview:headerView];
    
    _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"发给家长",@"发给同事"]];
    [_segmentControl setTintColor:[UIColor colorWithHexString:@"87de53"]];
    [_segmentControl setFrame:CGRectMake((headerView.width - 160) / 2, (headerView.height - 30) / 2, 160, 30)];
    [_segmentControl addTarget:self action:@selector(onSegmentChanged) forControlEvents:UIControlEventValueChanged];
    [headerView addSubview:_segmentControl];
    [_segmentControl setSelectedSegmentIndex:0];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headerView.bottom, self.view.width, self.view.height - headerView.bottom - 64) style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(onSendClicked)];
}

- (void)onSegmentChanged
{
    
}

- (void)onSendClicked
{
    if(self.completion)
        self.completion(nil);
}

#pragma mark = UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NotificationGroupHeaderView *headerView = [[NotificationGroupHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 50)];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"NotificationTargetCell";
    NotificationTargetCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[NotificationTargetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NotificationClassStudentsVC *studentVC = [[NotificationClassStudentsVC alloc] init];
    [studentVC setTitle:@"三年级二班"];
    [self.navigationController pushViewController:studentVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
