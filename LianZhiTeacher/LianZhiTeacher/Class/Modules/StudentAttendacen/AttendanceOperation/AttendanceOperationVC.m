//
//  AttendanceOperationVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/8.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "AttendanceOperationVC.h"
#import "RefuseVC.h"
@interface AttendanceOperationVC ()

@end

@implementation AttendanceOperationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"RecordHistory"] style:UIBarButtonItemStylePlain target:self action:@selector(showAttendanceHistory)];
    
    [self requestData];
}

- (void)setup
{
    UIView *offView = [[UIView alloc] initWithFrame:CGRectMake(12, 15, self.view.width - 12 * 2, 60)];
    [self.view addSubview:offView];
    
    UIView *attendanceView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, offView.width, offView.height - 5 * 2)];
    [attendanceView setBackgroundColor:[UIColor whiteColor]];
    [attendanceView.layer setCornerRadius:attendanceView.height / 2];
    [attendanceView.layer setMasksToBounds:YES];
    [offView addSubview:attendanceView];
    
    AvatarView *avatar = [[AvatarView alloc] initWithFrame:CGRectMake(0, 0, offView.height, offView.height)];
    [avatar setImageWithUrl:[NSURL URLWithString:[UserCenter sharedInstance].userInfo.avatar]];
    [offView addSubview:avatar];
    
    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, attendanceView.width - 70 - 30, attendanceView.height / 2)];
    [startLabel setFont:[UIFont systemFontOfSize:13]];
    [startLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
    [startLabel setText:@"自15年07月15日 周五 下午13:00"];
    [attendanceView addSubview:startLabel];
    
    UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, startLabel.height, attendanceView.width - 70 - 30, attendanceView.height / 2)];
    [endLabel setFont:[UIFont systemFontOfSize:13]];
    [endLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
    [endLabel setText:@"至15年07月15日 周五 下午16:00"];
    [attendanceView addSubview:endLabel];
    
    
    UIButton *refuseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refuseButton setFrame:CGRectMake(12, self.view.height - 64 - 30 - 34, self.view.width - 12 * 2, 34)];
    [refuseButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"fb5472"] size:refuseButton.size cornerRadius:17] forState:UIControlStateNormal];
    [refuseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [refuseButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [refuseButton setTitle:@"拒绝" forState:UIControlStateNormal];
    [refuseButton addTarget:self action:@selector(onRefuse) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refuseButton];
    
    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [applyButton setFrame:CGRectMake(12, refuseButton.y - 34 - 10, self.view.width - 12 * 2, 34)];
    [applyButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"5ed016"] size:refuseButton.size cornerRadius:17] forState:UIControlStateNormal];
    [applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [applyButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [applyButton setTitle:@"同意并计入考勤" forState:UIControlStateNormal];
    [applyButton addTarget:self action:@selector(onApply) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applyButton];
    
    UIView *reasonView = [[UIView alloc] initWithFrame:CGRectMake(12, offView.bottom + 20, self.view.width - 12 * 2, applyButton.y - 20 - (offView.bottom + 20))];
    [reasonView setBackgroundColor:[UIColor whiteColor]];
    [reasonView.layer setCornerRadius:10];
    [reasonView.layer setMasksToBounds:YES];
    [self.view addSubview:reasonView];
    
    UIView *hLine = [[UIView alloc] initWithFrame:CGRectMake(0, 26, reasonView.width, kLineHeight)];
    [hLine setBackgroundColor:kSepLineColor];
    [reasonView addSubview:hLine];
    
    UILabel *reasonHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, reasonView.width, 26)];
    [reasonHintLabel setTextAlignment:NSTextAlignmentCenter];
    [reasonHintLabel setFont:[UIFont systemFontOfSize:14]];
    [reasonHintLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
    [reasonHintLabel setText:@"请事假"];
    [reasonView addSubview:reasonHintLabel];
    
    UILabel *reasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, reasonView.width - 20 * 2, reasonView.height - 20 * 2 - 26 * 2)];
    [reasonLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
    [reasonLabel setFont:[UIFont systemFontOfSize:13]];
    [reasonLabel setNumberOfLines:0];
    [reasonLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [reasonLabel setText:@"原因说明\n李老师您好，贝贝今天病了"];
    [reasonView addSubview:reasonLabel];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, reasonView.height - 26, reasonView.width, kLineHeight)];
    [bottomLine setBackgroundColor:kSepLineColor];
    [reasonView addSubview:bottomLine];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, bottomLine.bottom, 0, 26)];
    [timeLabel setFont:[UIFont systemFontOfSize:12]];
    [timeLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
    [timeLabel setText:@"2015年7月15日 09:00"];
    [timeLabel sizeToFit];
    [timeLabel setOrigin:CGPointMake(15, bottomLine.bottom + (26 - timeLabel.height) / 2)];
    [reasonView addSubview:timeLabel];
    
    UILabel *fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, bottomLine.bottom, 0, 26)];
    [fromLabel setFont:[UIFont systemFontOfSize:12]];
    [fromLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
    [fromLabel setText:@"来自 贝贝的妈妈"];
    [fromLabel sizeToFit];
    [fromLabel setOrigin:CGPointMake(reasonView.width - fromLabel.width - 15, bottomLine.bottom + (26 - fromLabel.height) / 2)];
    [reasonView addSubview:fromLabel];
}

- (void)requestData
{
    [self setup];
}

- (void)showAttendanceHistory
{
    
}

- (void)onRefuse
{
    RefuseVC *refuseVC = [[RefuseVC alloc] init];
    [self.navigationController pushViewController:refuseVC animated:YES];
}

- (void)onApply
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
