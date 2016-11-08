//
//  HomeworkSettingVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkSettingVC.h"
#import "NumOperationView.h"
#import "HomeworkSettingManager.h"
@interface HomeworkSettingVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UIButton*  moreButton;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UISwitch*  homeworkReplySwitch;
@property (nonatomic, strong)UISwitch*  timeSwitch;
@property (nonatomic, strong)UISwitch*  smsSwitch;
@property (nonatomic, strong)NumOperationView*  numView;
@property (nonatomic, strong)NSArray*   titleArray;
@end

@implementation HomeworkSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"偏好设置";
    [self setRightNavigationItemHighlighted:NO];
    self.titleArray = @[@"开启作业回复",@"题目数量",@"开启作业回复截止时间",@"代发短信"];
    [self.view addSubview:[self tableView]];
    // Do any additional setup after loading the view.
}

- (void)setRightNavigationItemHighlighted:(BOOL)highlighted{
    if(!_moreButton){
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setSize:CGSizeMake(30, 40)];
        [_moreButton addTarget:self action:@selector(showDescription) forControlEvents:UIControlEventTouchUpInside];
    }
    if(highlighted){
        [_moreButton setImage:[UIImage imageNamed:@"settingIconHighlighted"] forState:UIControlStateNormal];
    }
    else{
        [_moreButton setImage:[UIImage imageNamed:@"settingIconNormal"] forState:UIControlStateNormal];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.moreButton];
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
        [_tableView addGestureRecognizer:tapGesture];
    }
    return _tableView;
}

- (void)onTap{
    [self.view endEditing:YES];
}

- (void)showDescription{
    [self setRightNavigationItemHighlighted:YES];
    __weak typeof(self) wself = self;
    [HomeworkDetailHintView showWithTitle:@"偏好设置" description:@"每一次进入到编辑作业界面，都会使用您在偏好设置中的配置" completion:^{
        [wself setRightNavigationItemHighlighted:NO];
    }];
}

- (UISwitch *)homeworkReplySwitch{
    if(!_homeworkReplySwitch){
        _homeworkReplySwitch = [[UISwitch alloc] init];
        [_homeworkReplySwitch addTarget:self action:@selector(onSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_homeworkReplySwitch setOnTintColor:kCommonTeacherTintColor];
        [_homeworkReplySwitch setOn:[[HomeworkSettingManager sharedInstance].getHomeworkSetting etype]];
    }
    return _homeworkReplySwitch;
}

- (UISwitch *)timeSwitch{
    if(!_timeSwitch){
        _timeSwitch = [[UISwitch alloc] init];
        [_timeSwitch setOnTintColor:kCommonTeacherTintColor];
        [_timeSwitch addTarget:self action:@selector(onSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_timeSwitch setOn:[[HomeworkSettingManager sharedInstance] getHomeworkSetting].replyEndOn];
    }
    return _timeSwitch;
}

- (UISwitch *)smsSwitch{
    if(!_smsSwitch){
        _smsSwitch = [[UISwitch alloc] init];
        [_smsSwitch setOnTintColor:kCommonTeacherTintColor];
        [_smsSwitch setOn:[[HomeworkSettingManager sharedInstance] getHomeworkSetting].sendSms];
        [_smsSwitch addTarget:self action:@selector(onSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _smsSwitch;
}

- (NumOperationView *)numView{
    if(!_numView){
        _numView = [[NumOperationView alloc] initWithMin:1 max:99];
        [_numView setNum:[[HomeworkSettingManager sharedInstance] getHomeworkSetting].homeworkNum];
        [_numView setNumChangedCallback:^(NSInteger num) {
            [[[HomeworkSettingManager sharedInstance] getHomeworkSetting] setHomeworkNum:num];
            [[HomeworkSettingManager sharedInstance] save];
        }];
    }
    return _numView;
}

- (void)onSwitchValueChanged:(UISwitch *)switchCtrl{
    BOOL isOn = switchCtrl.on;
    HomeworkSetting *setting = [[HomeworkSettingManager sharedInstance] getHomeworkSetting];
    if(switchCtrl == self.homeworkReplySwitch){
        setting.etype = isOn;
        if(!setting.etype){
            [self.timeSwitch setOn:NO];
            setting.replyEndOn = NO;
        }
    }
    else if(switchCtrl == self.timeSwitch){
        setting.replyEndOn = isOn;
        if(setting.replyEndOn){
            [self.homeworkReplySwitch setOn:YES];
            setting.etype = YES;
        }
    }
    else if(switchCtrl == self.smsSwitch){
        setting.sendSms = isOn;
    }
    [[HomeworkSettingManager sharedInstance] save];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeworkSettingCell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeworkSettingCell"];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.textLabel setTextColor:[UIColor colorWithHexString:@"525252"]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, cell.height - kLineHeight, cell.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [sepLine setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        [cell addSubview:sepLine];
    }
    NSInteger row = indexPath.row;
    [cell.textLabel setText:self.titleArray[row]];
    if(row == 0){
        [cell setAccessoryView:self.homeworkReplySwitch];
    }
    else if(row == 1){
        [cell setAccessoryView:self.numView];
    }
    else if(row == 2){
        [cell setAccessoryView:self.timeSwitch];
    }
    else{
        [cell setAccessoryView:self.smsSwitch];
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
