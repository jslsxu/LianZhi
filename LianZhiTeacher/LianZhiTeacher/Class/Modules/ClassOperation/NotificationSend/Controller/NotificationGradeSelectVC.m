//
//  NotificationGradeSelectVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 2017/4/29.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "NotificationGradeSelectVC.h"

@interface NotificationGradeCell ()
@property (nonatomic, strong)UILabel* titleLabel;
@property (nonatomic, strong)UIImageView* checkImageView;
@end

@implementation NotificationGradeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"send_sms_off"]];
        [self.checkImageView setOrigin:CGPointMake(self.width - 20 - self.checkImageView.width, (60 - self.checkImageView.height) / 2)];
        [self addSubview:self.checkImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.checkImageView.left - 10 - 10, 60)];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.titleLabel setTextColor:kColor_33];
        [self addSubview:self.titleLabel];
        
        UIView* sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [sepLine setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
    }
    return self;
}

- (void)setGradeInfo:(GradeInfo *)gradeInfo{
    _gradeInfo = gradeInfo;
    [self.titleLabel setText:_gradeInfo.gradeName];
}


- (void)setChosen:(BOOL)chosen{
    _chosen = chosen;
    NSString* imageName = chosen ? @"send_sms_on" : @"send_sms_off";
    [self.checkImageView setImage:[UIImage imageNamed:imageName]];
}

@end

@interface NotificationGradeSelectVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView* tableView;

@end

@implementation NotificationGradeSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择年级";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirm)];
    [self.view addSubview:[self tableView]];
}

- (void)confirm{
    
}

- (UITableView *)tableView{
    if(nil == _tableView){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationGradeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationGradeCell"];
    if(cell == nil){
        cell = [[NotificationGradeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NotificationGradeCell"];
    }
    GradeInfo* gradeInfo = [GradeInfo new];
    [gradeInfo setGradeName:@"而是一种"];
    [cell setGradeInfo:gradeInfo];
    [cell setChosen:YES];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

@end
