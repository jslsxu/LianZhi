//
//  AttendanceDetailVC.m
//  LianZhiParent
//
//  Created by jslsxu on 16/12/25.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "AttendanceDetailVC.h"
#import "Calendar.h"
#import "NotificationDetailActionView.h"
#import "StudentAttendanceHeaderView.h"
#import "RequestVacationVC.h"
@interface AttendanceDetailVC ()<CalendarDelegate>
@property (nonatomic, strong)UIButton* moreButton;
@property (nonatomic, strong)Calendar* calendar;
@property (nonatomic, strong)UIScrollView* scrollView;
@property (nonatomic, strong)StudentAttendanceHeaderView* headerView;
@property (nonatomic, strong)UIView* bottomView;
@end

@implementation AttendanceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    [self setupTitle];
    [self setRightbarButtonHighlighted:NO];
    [self.view addSubview:[self calendar]];
    [self.view addSubview:[self bottomView]];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.calendar.height, self.view.width, self.bottomView.top - self.calendar.height)];
    [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_scrollView setAlwaysBounceVertical:YES];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_scrollView];
    
    [_scrollView addSubview:[self headerView]];
    UIView* contentView = [self contentView];
    [contentView setOrigin:CGPointMake(10, self.headerView.bottom + 10)];
    [_scrollView addSubview:contentView];
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, contentView.bottom + 10)];
}

- (Calendar *)calendar{
    if(_calendar == nil){
        _calendar = [[Calendar alloc] initWithDate:[NSDate date]];
        [_calendar setDelegate:self];
    }
    return _calendar;
}

- (void)setupTitle{
    UserInfo* userInfo = [UserCenter sharedInstance].curChild;
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setNumberOfLines:0];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"525252"]];
    NSMutableAttributedString* titleString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@考勤详情\n", userInfo.name] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]}];
    [titleString appendAttributedString:[[NSAttributedString alloc] initWithString:self.classInfo.name attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}]];
    [titleLabel setAttributedText:titleString];
    [titleLabel sizeToFit];
    [self.navigationItem setTitleView:titleLabel];
}

- (void)setRightbarButtonHighlighted:(BOOL)highlighted{
    if(_moreButton == nil){
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setSize:CGSizeMake(30, 40)];
        [_moreButton addTarget:self action:@selector(onMoreClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    [_moreButton setImage:[UIImage imageNamed:highlighted ? @"noti_detail_more_highlighted" : @"noti_detail_more"] forState:UIControlStateNormal];
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:_moreButton];
    self.navigationItem.rightBarButtonItem = moreItem;
}

- (void)onMoreClicked{
    [self setRightbarButtonHighlighted:YES];
    __weak typeof(self) wself = self;
    NotificationActionItem *cancelItem = [NotificationActionItem actionItemWithTitle:@"取消当日假条" action:^{
        [wself cancelLeave];
    } destroyItem:NO];
    [NotificationDetailActionView showWithActions:@[cancelItem] completion:^{
        [wself setRightbarButtonHighlighted:NO];
    }];
}

- (void)cancelLeave{
    LGAlertView* alertView = [[LGAlertView alloc] initWithTitle:@"提示" message:@"您确定取消2016-04-04的请假吗?" style:LGAlertViewStyleAlert buttonTitles:@[@"取消", @"确定"] cancelButtonTitle:nil destructiveButtonTitle:nil];
    [alertView setButtonsTitleColor:kCommonParentTintColor];
    [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
        if(index == 1){
            
        }
    }];
    [alertView showAnimated:YES completionHandler:nil];
}

- (void)requestLeave{
    RequestVacationVC* requestVC = [[RequestVacationVC alloc] init];
    [self.navigationController pushViewController:requestVC animated:YES];
}

- (UIView *)bottomView{
    if(nil == _bottomView){
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 60, self.view.width, 60)];
        [_bottomView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        [_bottomView setBackgroundColor:[UIColor whiteColor]];
        
        UIView* topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bottomView.width, kLineHeight)];
        [topLine setBackgroundColor:kSepLineColor];
        [_bottomView addSubview:topLine];
        
        UIButton* requestButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [requestButton setFrame:CGRectInset(_bottomView.bounds, 10, 10)];
        [requestButton setBackgroundImage:[UIImage imageWithColor:kCommonParentTintColor size:requestButton.size cornerRadius:5] forState:UIControlStateNormal];
        [requestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [requestButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [requestButton setTitle:@"在线请假" forState:UIControlStateNormal];
        [requestButton addTarget:self action:@selector(requestLeave) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:requestButton];
    }
    return _bottomView;
}

- (UIView *)contentView{
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.view.width - 10 * 2, 0)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [bgView.layer setCornerRadius:10];
    [bgView.layer setMasksToBounds:YES];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    [titleLabel setTextColor:kColor_33];
    [titleLabel setText:@"当日记录"];
    [titleLabel sizeToFit];
    [titleLabel setOrigin:CGPointMake(10, 10)];
    [bgView addSubview:titleLabel];
    
    UILabel* dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [dateLabel setTextColor:kCommonParentTintColor];
    [dateLabel setFont:[UIFont systemFontOfSize:14]];
    [dateLabel setText:@"2016年4月4日"];
    [dateLabel sizeToFit];
    [dateLabel setOrigin:CGPointMake(bgView.width - 10 - dateLabel.width, 10)];
    [bgView addSubview:dateLabel];
    
    CGFloat spaceYStart = titleLabel.bottom + 10;
    for (NSInteger i = 0; i < 10; i++) {
        UIView* dot = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 6, 6)];
        [dot setBackgroundColor:kCommonParentTintColor];
        [dot.layer setCornerRadius:3];
        [dot.layer setMasksToBounds:YES];
        [bgView addSubview:dot];
        
        UILabel* timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [timeLabel setTextColor:kCommonParentTintColor];
        [timeLabel setFont:[UIFont systemFontOfSize:14]];
        [timeLabel setText:@"08:10"];
        [timeLabel sizeToFit];
        [timeLabel setOrigin:CGPointMake(dot.right + 10, spaceYStart)];
        [bgView addSubview:timeLabel];
        
        [dot setOrigin:CGPointMake(10, timeLabel.centerY - dot.height / 2)];
        
        UILabel* contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLabel.left, 0, bgView.width - 10 - timeLabel.left, 0)];
        [contentLabel setTextColor:kColor_66];
        [contentLabel setNumberOfLines:0];
        [contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [contentLabel setFont:[UIFont systemFontOfSize:14]];
        [contentLabel setText:@"陈琦老师提交未出勤，备注，病好了，来学校了，打卡机记录考勤"];
        [contentLabel sizeToFit];
        [contentLabel setOrigin:CGPointMake(timeLabel.left, timeLabel.bottom + 5)];
        [bgView addSubview:contentLabel];
        
        spaceYStart = contentLabel.bottom + 10;
    }
    
    [bgView setHeight:spaceYStart];
    
    return bgView;
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
