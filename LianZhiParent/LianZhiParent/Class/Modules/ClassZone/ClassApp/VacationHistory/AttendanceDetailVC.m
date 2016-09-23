//
//  AttendanceDetailVC.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/9/23.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "AttendanceDetailVC.h"
#import "RequestVacationVC.h"
@implementation AttendanceMonthDetailView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
    }
    return self;
}

@end

@implementation AttendanceDayDetailView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
    }
    return self;
}

@end

@interface AttendanceDetailVC ()
@property (nonatomic, strong)UIButton*  requestButton;
@end

@implementation AttendanceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@考勤详情",[UserCenter sharedInstance].curChild.name];
    
    
    [self.view addSubview:self.requestButton];
}

- (UIButton *)requestButton{
    if(!_requestButton){
        _requestButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_requestButton setSize:CGSizeMake(self.view.width - 10 * 2, 40)];
        [_requestButton addTarget:self action:@selector(requestVacation) forControlEvents:UIControlEventTouchUpInside];
        [_requestButton setBackgroundImage:[UIImage imageWithColor:kCommonParentTintColor size:_requestButton.size cornerRadius:5] forState:UIControlStateNormal];
        [_requestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_requestButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_requestButton setTitle:@"在线请假" forState:UIControlStateNormal];
        [_requestButton setFrame:CGRectMake(10, self.view.height - 10 - 40, self.view.width - 10 * 2, 40)];
        [_requestButton setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    }
    return _requestButton;
}

- (void)requestVacation{
    RequestVacationVC *requestVC = [[RequestVacationVC alloc] init];
    [self.navigationController pushViewController:requestVC animated:YES];

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
