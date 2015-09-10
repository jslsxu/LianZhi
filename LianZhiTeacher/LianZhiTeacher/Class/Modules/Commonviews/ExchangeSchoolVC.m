//
//  ExchangeSchoolVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/2/5.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ExchangeSchoolVC.h"

#define kSchoolCellHeight                       60

@implementation SchoolInfoCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _logoView = [[LogoView alloc] initWithFrame:CGRectMake(15, (kSchoolCellHeight - 36) / 2, 36, 36)];
        [self addSubview:_logoView];
        
        _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(@"RightArrow")]];
        [_arrowImage setOrigin:CGPointMake(self.width - _arrowImage.width - 30, (60 - _arrowImage.height) / 2)];
        [self addSubview:_arrowImage];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_statusLabel setTextColor:kCommonTeacherTintColor];
        [_statusLabel setFont:[UIFont systemFontOfSize:14]];
        [_statusLabel setText:@"当前"];
        [_statusLabel sizeToFit];
        [_statusLabel setFrame:CGRectMake(self.width - 20 - _statusLabel.width, (kSchoolCellHeight - _statusLabel.height) / 2, _statusLabel.width, _statusLabel.height)];
        [self addSubview:_statusLabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_logoView.right + 10, 0, _statusLabel.x - 10 - (_logoView.right + 10), kSchoolCellHeight)];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextColor:[UIColor grayColor]];
        [self addSubview:_nameLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, kSchoolCellHeight - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
    }
    return self;
}


- (void)setSchoolInfo:(SchoolInfo *)schoolInfo
{
    _schoolInfo = schoolInfo;
    [_logoView setImageWithUrl:[NSURL URLWithString:_schoolInfo.logoUrl]];
    [_nameLabel setText:_schoolInfo.schoolName];
    [_nameLabel sizeToFit];
    [_nameLabel setOrigin:CGPointMake(_logoView.right + 10, (60 - _nameLabel.height) / 2)];
}

- (void)setIsCurSchool:(BOOL)isCurSchool
{
    _isCurSchool = isCurSchool;
    [_statusLabel setHidden:!_isCurSchool];
    [_arrowImage setHidden:_isCurSchool];
}

@end


@implementation ExchangeSchoolVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"切换学校";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%ld所",(long)[UserCenter sharedInstance].userData.schools.count] style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.view setBackgroundColor:[UIColor colorWithRed:229 / 255.0 green:229 / 255.0 blue:229 / 255.0 alpha:1.f]];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [UserCenter sharedInstance].schools.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kSchoolCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"SchoolCell";
    SchoolInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(nil == cell)
        cell = [[SchoolInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    SchoolInfo *schoolInfo = [UserCenter sharedInstance].schools[indexPath.row];
    [cell setSchoolInfo:schoolInfo];
    [cell setIsCurSchool:[schoolInfo.schoolID isEqualToString:[UserCenter sharedInstance].curSchool.schoolID]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SchoolInfo *selectedSchool = [UserCenter sharedInstance].schools[indexPath.row];
    [[UserCenter sharedInstance] changeCurSchool:selectedSchool];
    [_tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
