//
//  HomeworkSettingVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkSettingVC.h"
#import "NumOperationView.h"
@interface HomeworkSettingDescriptionView ()
@property (nonatomic, strong)UIButton*  bgButton;
@property (nonatomic, strong)UIView*    contentView;
@property (nonatomic, strong)void (^dismissCallBack)();
@end

@implementation HomeworkSettingDescriptionView
+ (void)showWithDismissCallback:(void (^)(void))dismiss{
    HomeworkSettingDescriptionView *descriptionView = [[HomeworkSettingDescriptionView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    descriptionView.dismissCallBack = dismiss;
    [descriptionView show];
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgButton setFrame:self.bounds];
        [_bgButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
        [_bgButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bgButton];
        
        [self addSubview:self.contentView];
        [self.contentView setOrigin:CGPointMake((self.width - self.contentView.width) / 2, (self.height - self.contentView.height) / 2)];
    }
    return self;
}

- (UIView *)contentView{
    if(_contentView == nil){
        NSInteger width = self.width * 3 / 4;
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(self.width / 8, 0, width, 0)];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView.layer setCornerRadius:15];
        [_contentView.layer setMasksToBounds:YES];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLabel setText:@"偏好设置:"];
        [titleLabel setFont:[UIFont systemFontOfSize:15]];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"525252"]];
        [titleLabel sizeToFit];
        [_contentView addSubview:titleLabel];
        [titleLabel setOrigin:CGPointMake(15, 15)];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom + 15, _contentView.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [_contentView addSubview:sepLine];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [contentLabel setWidth:width - 15 * 2];
        [contentLabel setFont:[UIFont systemFontOfSize:15]];
        [contentLabel setTextColor:[UIColor colorWithHexString:@"525252"]];
        [contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [contentLabel setNumberOfLines:0];
        [contentLabel setText:@"每一次进入到编辑作业界面，都会使用您在偏好设置中的配置"];
        [contentLabel sizeToFit];
        [contentLabel setOrigin:CGPointMake(15, sepLine.bottom + 15)];
        [_contentView addSubview:contentLabel];
        [_contentView setHeight:contentLabel.bottom + 15];
    }
    return _contentView;
}


- (void)show{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    self.bgButton.alpha = 0.f;
    self.contentView.alpha = 1.f;
    [UIView animateWithDuration:0.3 animations:^{
        self.bgButton.alpha = 1.f;
        self.contentView.alpha = 1.f;
    }];
}

- (void)dismiss{
    if(self.dismissCallBack){
        self.dismissCallBack();
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.bgButton.alpha = 0.f;
        self.contentView.alpha = 0.f;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end

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
    self.titleArray = @[@"开启作业回复",@"作业数量",@"开启作业回复截止时间",@"代发短信"];
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
        [_moreButton setImage:[UIImage imageNamed:@"noti_detail_more_highlighted"] forState:UIControlStateNormal];
    }
    else{
        [_moreButton setImage:[UIImage imageNamed:@"noti_detail_more"] forState:UIControlStateNormal];
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
    [HomeworkSettingDescriptionView showWithDismissCallback:^{
        [wself setRightNavigationItemHighlighted:NO];
    }];
}

- (UISwitch *)homeworkReplySwitch{
    if(!_homeworkReplySwitch){
        _homeworkReplySwitch = [[UISwitch alloc] init];
        [_homeworkReplySwitch addTarget:self action:@selector(onSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_homeworkReplySwitch setOnTintColor:kCommonTeacherTintColor];
    }
    return _homeworkReplySwitch;
}

- (UISwitch *)timeSwitch{
    if(!_timeSwitch){
        _timeSwitch = [[UISwitch alloc] init];
        [_timeSwitch setOnTintColor:kCommonTeacherTintColor];
        [_timeSwitch addTarget:self action:@selector(onSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _timeSwitch;
}

- (UISwitch *)smsSwitch{
    if(!_smsSwitch){
        _smsSwitch = [[UISwitch alloc] init];
        [_smsSwitch setOnTintColor:kCommonTeacherTintColor];
        [_smsSwitch addTarget:self action:@selector(onSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _smsSwitch;
}

- (NumOperationView *)numView{
    if(!_numView){
        _numView = [[NumOperationView alloc] initWithMin:1 max:99];
        [_numView setNum:1];
    }
    return _numView;
}

- (void)onSwitchValueChanged:(UISwitch *)switchCtrl{
    BOOL isOn = switchCtrl.on;
    if(switchCtrl == self.homeworkReplySwitch){
        
    }
    else if(switchCtrl == self.timeSwitch){
        
    }
    else if(switchCtrl == self.smsSwitch){
        
    }
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
