//
//  HomeworkSuperSettingVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkSuperSettingVC.h"
#import "NotificationSelectTimeView.h"
@implementation HomeworkSuperSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.textLabel setFont:[UIFont systemFontOfSize:15]];
        [self.textLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [sepLine setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];

    }
    return self;
}

- (void)setActionView:(UIView *)actionView{
    if(_actionView != actionView){
        [_actionView removeFromSuperview];
        _actionView = actionView;
        [_actionView setOrigin:CGPointMake(self.width - 10 - _actionView.width, (self.height - _actionView.height) / 2)];
        [self addSubview:_actionView];
    }
}
@end

@interface HomeworkSuperSettingVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView*   tableView;
@property (nonatomic, strong)UISwitch*      smsSwitch;
@property (nonatomic, strong)UISwitch*      replyEndSwitch;
@property (nonatomic, strong)UILabel*       endTimeLabel;
@end

@implementation HomeworkSuperSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"高级设置";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:self.tableView];
}

- (void)onSmsSwitchChanged{
    
}

- (void)onReplyEndSwitchChanged{
    
}

- (UISwitch *)smsSwitch{
    if(_smsSwitch == nil){
        _smsSwitch = [[UISwitch alloc] init];
        [_smsSwitch setOnTintColor:kCommonTeacherTintColor];
        [_smsSwitch setOn:YES];
        [_smsSwitch addTarget:self action:@selector(onSmsSwitchChanged) forControlEvents:UIControlEventValueChanged];
        [_smsSwitch setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
    }
    return _smsSwitch;
}

- (UISwitch *)replyEndSwitch{
    if(_replyEndSwitch == nil){
        _replyEndSwitch = [[UISwitch alloc] init];
        [_replyEndSwitch setOnTintColor:kCommonTeacherTintColor];
        [_replyEndSwitch setOn:YES];
        [_replyEndSwitch addTarget:self action:@selector(onReplyEndSwitchChanged) forControlEvents:UIControlEventValueChanged];
        [_replyEndSwitch setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
    }
    return _replyEndSwitch;
}

- (UILabel *)endTimeLabel{
    if(_endTimeLabel == nil){
        _endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
        [_endTimeLabel setFont:[UIFont systemFontOfSize:15]];
        [_endTimeLabel setTextColor:kCommonTeacherTintColor];
        [_endTimeLabel setTextAlignment:NSTextAlignmentRight];
    }
    return _endTimeLabel;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseID = @"SuperSettingCell";
    HomeworkSuperSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(cell == nil){
        cell = [[HomeworkSuperSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    static NSString *title[3] = {@"代发短信", @"开启作业回复截止时间", @"回复截止时间"};
    [cell.textLabel setText:title[indexPath.row]];
    if(indexPath.row == 0){
        [cell setActionView:self.smsSwitch];
    }
    else if(indexPath.row == 1){
        [cell setActionView:self.replyEndSwitch];
    }
    else{
        [cell setActionView:self.endTimeLabel];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 2){
        __weak typeof(self) wself = self;
         [NotificationSelectTimeView showWithCompletion:^(NSInteger timeInterval) {
             NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
             NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
             [formmater setDateFormat:@"yyyy-MM-dd HH:mm"];
             NSString *dateString = [formmater stringFromDate:date];
             [wself.endTimeLabel setText:dateString];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
