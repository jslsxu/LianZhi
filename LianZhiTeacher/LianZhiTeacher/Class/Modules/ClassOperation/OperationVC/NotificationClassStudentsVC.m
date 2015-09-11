//
//  NotificationClassStudentsVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/11.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "NotificationClassStudentsVC.h"

@implementation NotificationStudentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(10, (self.height - 32) / 2, 32, 32)];
        [self addSubview:_avatarView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarView.right + 10, 0, 0, 0)];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_nameLabel];
        
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarView.right + 10, 0, 0, 0)];
        [_infoLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [_infoLabel setFont:[UIFont systemFontOfSize:10]];
        [self addSubview:_infoLabel];
        
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkButton setFrame:CGRectMake(self.width - 20 - 20, (self.height - 20) / 2, 20, 20)];
        [_checkButton setImage:[UIImage imageNamed:@"ControlDefault"] forState:UIControlStateNormal];
        [_checkButton setImage:[UIImage imageNamed:@"ControlHighlighted"] forState:UIControlStateSelected];
        [self addSubview:_checkButton];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
        
    }
    return self;
}

- (void)setStudentInfo:(StudentInfo *)studentInfo
{
    _studentInfo = studentInfo;
//    [_avatarView setImageWithUrl:[NSURL URLWithString:_studentInfo.avatar]];
//    [_nameLabel setText:_studentInfo.name];
//    [_infoLabel setText:[NSString stringWithFormat:@"(%ld位家长)",(long)_studentInfo.family.count]];
    [_avatarView setImageWithUrl:[NSURL URLWithString:[UserCenter sharedInstance].userInfo.avatar]];
    [_nameLabel setText:[UserCenter sharedInstance].userInfo.name];
    [_nameLabel sizeToFit];
    [_nameLabel setOrigin:CGPointMake(_avatarView.right + 10, (self.height - _nameLabel.height) / 2)];
    [_infoLabel setText:[NSString stringWithFormat:@"(%ld位家长)",(long)_studentInfo.family.count]];
    [_infoLabel sizeToFit];
    [_infoLabel setOrigin:CGPointMake(_nameLabel.right + 10, (self.height - _infoLabel.height) / 2)];
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
}

@end

@interface NotificationClassStudentsVC ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation NotificationClassStudentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onConfirm)];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView setSectionIndexColor:kCommonTeacherTintColor];
    [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"NotificationStudentCell";
    NotificationStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[NotificationStudentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    [cell setStudentInfo:nil];
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray *titleArray = @[@"A",@"B",@"C",@"D"];
    return titleArray;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *titleArray = @[@"A",@"B",@"C",@"D"];
    return titleArray[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)onConfirm
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
