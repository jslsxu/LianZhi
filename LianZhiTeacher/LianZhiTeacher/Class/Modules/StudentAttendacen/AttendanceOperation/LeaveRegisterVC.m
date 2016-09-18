//
//  LeaveRegisterVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/8.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "LeaveRegisterVC.h"

@interface LeaveRegisterVC ()<UITextViewDelegate>

@end

@implementation LeaveRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *leaveView = [[UIView alloc] initWithFrame:CGRectMake(12, 15, self.view.width - 12 * 2, 60)];
    [self setupLeaveView:leaveView];
    [self.view addSubview:leaveView];
    
    _typeSegment = [[UISegmentedControl alloc] initWithItems:@[@"事假",@"病假",@"缺勤"]];
    [_typeSegment setFrame:CGRectMake(12, leaveView.bottom + 15, self.view.width - 12 * 2, 30)];
    [_typeSegment setTintColor:kCommonTeacherTintColor];
    [_typeSegment setSelectedSegmentIndex:0];
    [self.view addSubview:_typeSegment];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton addTarget:self action:@selector(onConfirm) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setFrame:CGRectMake(10, self.view.height - 64 - 34 - 30, self.view.width - 10 * 2, 34)];
    [confirmButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"5ed016"] size:confirmButton.size cornerRadius:confirmButton.height / 2] forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [confirmButton setTitle:@"登记并通知家长" forState:UIControlStateNormal];
    [self.view addSubview:confirmButton];
    
    UIView *reasonView = [[UIView alloc] initWithFrame:CGRectMake(12, _typeSegment.bottom + 20, self.view.width - 12 * 2, confirmButton.y - 20 - (_typeSegment.bottom + 20))];
    [reasonView setBackgroundColor:[UIColor whiteColor]];
    [reasonView.layer setCornerRadius:10];
    [reasonView.layer setMasksToBounds:YES];
    [self.view addSubview:reasonView];
    
    _textView = [[UTPlaceholderTextView alloc] initWithFrame:CGRectInset(reasonView.bounds, 10, 10)];
    [_textView setReturnKeyType:UIReturnKeyDone];
    [_textView setFont:[UIFont systemFontOfSize:14]];
    [_textView setDelegate:self];
    [reasonView addSubview:_textView];
}

- (void)setupLeaveView:(UIView *)viewParent
{
    UIView *attendanceView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, viewParent.width, viewParent.height - 5 * 2)];
    [attendanceView setBackgroundColor:[UIColor whiteColor]];
    [attendanceView.layer setCornerRadius:attendanceView.height / 2];
    [attendanceView.layer setMasksToBounds:YES];
    [viewParent addSubview:attendanceView];
    
    AvatarView *avatar = [[AvatarView alloc] initWithFrame:CGRectMake(0, 0, viewParent.height, viewParent.height)];
    [avatar sd_setImageWithURL:[NSURL URLWithString:[UserCenter sharedInstance].userInfo.avatar]];
    [viewParent addSubview:avatar];
    
    _startLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, attendanceView.width - 70 - 30, attendanceView.height / 2)];
    [_startLabel setFont:[UIFont systemFontOfSize:13]];
    [_startLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
    [_startLabel setText:@"自15年07月15日 周五 下午13:00"];
    [attendanceView addSubview:_startLabel];
    
    UIButton* editStartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editStartButton setImage:[UIImage imageNamed:@"LeaveEdit"] forState:UIControlStateNormal];
    [editStartButton setFrame:CGRectMake(_startLabel.right, _startLabel.y, _startLabel.height, _startLabel.height)];
    [editStartButton addTarget:self action:@selector(onEditStart) forControlEvents:UIControlEventTouchUpInside];
    [attendanceView addSubview:editStartButton];
    
    _endLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, _startLabel.height, attendanceView.width - 70 - 30, attendanceView.height / 2)];
    [_endLabel setFont:[UIFont systemFontOfSize:13]];
    [_endLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
    [_endLabel setText:@"至15年07月15日 周五 下午16:00"];
    [attendanceView addSubview:_endLabel];
    
    UIButton* editEndButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editEndButton setImage:[UIImage imageNamed:@"LeaveEdit"] forState:UIControlStateNormal];
    [editEndButton setFrame:CGRectMake(_endLabel.right, _endLabel.y, _endLabel.height, _endLabel.height)];
    [editEndButton addTarget:self action:@selector(onEditEnd) forControlEvents:UIControlEventTouchUpInside];
    [attendanceView addSubview:editEndButton];
}

- (void)onEditStart
{
    
}

- (void)onEditEnd
{
    
}

- (void)onConfirm
{
    
}

#pragma mark - UItextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
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
