//
//  NotificationScopeVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 2017/4/29.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "NotificationScopeVC.h"
#import "NotificationGradeSelectVC.h"
#import "NotificationMemberSelectVC.h"
@implementation NotificationScopeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if(self){
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [self.titleLabel setTextColor:[UIColor colorWithHexString:@"222222"]];
        [self addSubview:self.titleLabel];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.detailLabel setFont:[UIFont systemFontOfSize:13]];
        [self.detailLabel setTextColor:kColor_99];
        [self addSubview:self.detailLabel];
        
        UIView* sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [sepLine setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
    }
    return self;
}

- (void)setTitle:(NSString *)title detail:(NSString *)detail{
    [self.titleLabel setText:title];
    [self.titleLabel sizeToFit];
    
    [self.detailLabel setText:detail];
    [self.detailLabel sizeToFit];
    [self.titleLabel setOrigin:CGPointMake(10, 15)];
    [self.detailLabel setOrigin:CGPointMake(10, 70 - 10 - self.detailLabel.height)];
}

@end

@interface NotificationScopeVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView* tableView;
@end

@implementation NotificationScopeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择发送范围";
    [self.view addSubview:[self tableView]];
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

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationScopeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationScopeCell"];
    if(cell == nil){
        cell = [[NotificationScopeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NotificationScopeCell"];
    }
    NSInteger row = indexPath.row;
    [cell setTitle:row == 0 ? @"按年级" : @"按班级,个人" detail:row == 0 ? @"选择要发送的年级，向整个发送通知" : @"选择发送的班级或个人发送通知"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0){
        NotificationGradeSelectVC *gradeVC = [[NotificationGradeSelectVC alloc] init];
        [self.navigationController pushViewController:gradeVC animated:YES];
    }
    else{
        NotificationMemberSelectVC* memberVC = [[NotificationMemberSelectVC alloc] init];
        [self.navigationController pushViewController:memberVC animated:YES];
    }
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
