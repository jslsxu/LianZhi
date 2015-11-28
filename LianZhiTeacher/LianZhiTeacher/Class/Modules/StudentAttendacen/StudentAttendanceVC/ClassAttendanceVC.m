//
//  ClassAttendanceVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/11/27.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "ClassAttendanceVC.h"
#import "StudentAttendanceVC.h"
@implementation ClassAttendanceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _logoView = [[LogoView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        [self addSubview:_logoView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_logoView.right + 10, 0, 100, 50)];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextColor:[UIColor grayColor]];
        [self addSubview:_nameLabel];
        [self setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]]];
    }
    return self;
}

- (void)setClassInfo:(ClassInfo *)classInfo
{
    _classInfo = classInfo;
    [_logoView setImageWithUrl:[NSURL URLWithString:_classInfo.logoUrl] placeHolder:nil];
    [_nameLabel setText:_classInfo.className];
}

@end

@interface ClassAttendanceVC ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ClassAttendanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我所有的班";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegae
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [UserCenter sharedInstance].curSchool.classes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseID = @"ClassCell";
    ClassAttendanceCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[ClassAttendanceCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.detailTextLabel setTextColor:kCommonTeacherTintColor];
    }
    ClassInfo *classInfo = [UserCenter sharedInstance].curSchool.classes[indexPath.row];
    [cell setClassInfo:classInfo];
    [cell.detailTextLabel setText:@"1人请假"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    StudentAttendanceVC *studentAttendanceVC = [[StudentAttendanceVC alloc] init];
    [studentAttendanceVC setClassInfo:[UserCenter sharedInstance].curSchool.classes[indexPath.row]];
    [self.navigationController pushViewController:studentAttendanceVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
