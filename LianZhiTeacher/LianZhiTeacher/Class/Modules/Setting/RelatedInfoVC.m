//
//  RelatedInfoVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/2/5.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "RelatedInfoVC.h"
#import "PersonalInfoVC.h"
#import "ReportProblemVC.h"

#define kSchoolCellHeight                       50
#define kClassCellHeight                        35

@implementation RelatedSchoolCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.width = kScreenWidth;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _logoView = [[LogoView alloc] initWithFrame:CGRectMake(10, 9, 32, 32)];
        [self addSubview:_logoView];
        
        _reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reportButton addTarget:self action:@selector(onReportError) forControlEvents:UIControlEventTouchUpInside];
        [_reportButton setBackgroundImage:[[UIImage imageWithColor:[UIColor colorWithHexString:@"949494"] size:CGSizeMake(18, 18) cornerRadius:9] resizableImageWithCapInsets:UIEdgeInsetsMake(9, 9, 9, 9)] forState:UIControlStateNormal];
        [_reportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_reportButton.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [_reportButton setTitle:@"报错" forState:UIControlStateNormal];
        [_reportButton setFrame:CGRectMake(self.width - 12 - 36, (kSchoolCellHeight - 18) / 2, 36, 18)];
        [self addSubview:_reportButton];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_logoView.right + 10, 0, _reportButton.left - 10 - (_logoView.right + 10), kSchoolCellHeight)];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [self addSubview:_nameLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, kSchoolCellHeight - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kCommonSeparatorColor];
        [self addSubview:_sepLine];
    }
    return self;
}
- (void)setSchoolInfo:(SchoolInfo *)schoolInfo
{
    _schoolInfo = schoolInfo;
    [_logoView sd_setImageWithURL:[NSURL URLWithString:schoolInfo.logoUrl]];
    [_nameLabel setText:_schoolInfo.schoolName];
    
}

- (void)onReportError
{
    ReportProblemVC *reportVC = [[ReportProblemVC alloc] init];
    [reportVC setType:3];
    [CurrentROOTNavigationVC pushViewController:reportVC animated:YES];
}
@end

@implementation RelatedClassCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reportButton addTarget:self action:@selector(onReportError) forControlEvents:UIControlEventTouchUpInside];
        [_reportButton setBackgroundImage:[[UIImage imageWithColor:[UIColor colorWithHexString:@"949494"] size:CGSizeMake(18, 18) cornerRadius:9] resizableImageWithCapInsets:UIEdgeInsetsMake(9, 9, 9, 9)] forState:UIControlStateNormal];
        [_reportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_reportButton.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [_reportButton setTitle:@"报错" forState:UIControlStateNormal];
        [_reportButton setFrame:CGRectMake(self.width - 12 - 36, (kClassCellHeight - 18) / 2, 36, 18)];
        [self addSubview:_reportButton];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, _reportButton.left - 10 - 55, kClassCellHeight)];
        [_nameLabel setFont:[UIFont systemFontOfSize:12]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [self addSubview:_nameLabel];

        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, kClassCellHeight - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kCommonSeparatorColor];
        [self addSubview:_sepLine];
    }
    return self;
}

- (void)setClassInfo:(ClassInfo *)classInfo
{
    _classInfo = classInfo;
    [_nameLabel setText:[NSString stringWithFormat:@"%@ (%@)",classInfo.name,_classInfo.course]];
}

- (void)onReportError
{
    ReportProblemVC *reportVC = [[ReportProblemVC alloc] init];
    [reportVC setType:3];
    [CurrentROOTNavigationVC pushViewController:reportVC animated:YES];
}

@end
@implementation RelatedInfoVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的学校";
}

- (void)refreshData
{
    [_tableView reloadData];
    [self setupHeaderView:_headerView];
}

- (void)setupSubviews
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 95)];
    [self setupHeaderView:_headerView];
    [_tableView setTableHeaderView:_headerView];
}

- (void)setupHeaderView:(UIView *)viewParent
{
    NSArray *subviews = [viewParent subviews];
    [subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [viewParent setBackgroundColor:[UIColor whiteColor]];
    CGFloat margin = 10;
    NSInteger infoHeight = viewParent.height - 20;
    
    AvatarView *avatar = [[AvatarView alloc] initWithFrame:CGRectMake(20, 10, 55, 55)];
    [avatar sd_setImageWithURL:[NSURL URLWithString:[UserCenter sharedInstance].userInfo.avatar]];
    [viewParent addSubview:avatar];
    
    UILabel*    nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [nameLabel setFont:[UIFont systemFontOfSize:16]];
    [nameLabel setTextColor:[UIColor grayColor]];
    [nameLabel setText:[UserCenter sharedInstance].userInfo.name];
    [nameLabel sizeToFit];
    [nameLabel setOrigin:CGPointMake(avatar.right + margin, infoHeight / 2 - 2 - nameLabel.height)];
    [viewParent addSubview:nameLabel];
    
    GenderType gender = [UserCenter sharedInstance].userInfo.sex;
    NSString *imageStr = gender == GenderMale ? (@"GenderMale.png") : (@"GenderFemale.png");
    UIImageView *genderImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageStr]];
    [genderImage setOrigin:CGPointMake(nameLabel.right + 10, nameLabel.top + (nameLabel.height - genderImage.height) / 2)];
    [viewParent addSubview:genderImage];
    
    UILabel*    birthdayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [birthdayLabel setFont:[UIFont systemFontOfSize:14]];
    [birthdayLabel setTextColor:[UIColor grayColor]];
    NSString *birthday = [NSString stringWithFormat:@"%@ (%@)",[UserCenter sharedInstance].userInfo.birthday,[UserCenter sharedInstance].userInfo.constellation];
    [birthdayLabel setText:birthday];
    [birthdayLabel sizeToFit];
    [birthdayLabel setOrigin:CGPointMake(avatar.right + 10, infoHeight / 2 + 2)];
    [viewParent addSubview:birthdayLabel];

    UIImageView*    arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]];
    [arrowImage setOrigin:CGPointMake(viewParent.width - arrowImage.width - margin, (infoHeight - arrowImage.height) / 2)];
    [viewParent addSubview:arrowImage];
    
    UIView* bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, viewParent.height - kLineHeight, viewParent.width, kLineHeight)];
    [bottomLine setBackgroundColor:kCommonSeparatorColor];
    [viewParent addSubview:bottomLine];
    
    UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [coverButton setFrame:viewParent.bounds];
    [coverButton addTarget:self action:@selector(onCoverButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [viewParent addSubview:coverButton];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, viewParent.height - 20, viewParent.width, 20)];
    [headerView setBackgroundColor:kCommonBackgroundColor];
    [viewParent addSubview:headerView];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, headerView.width - 10 * 2, headerView.height)];
    [headerLabel setFont:[UIFont systemFontOfSize:14]];
    [headerLabel setTextColor:[UIColor colorWithHexString:@"8f8f8f"]];
    [headerLabel setText:@"任职于"];
    [headerView addSubview:headerLabel];
}

- (void)onCoverButtonClicked
{
    PersonalInfoVC *personalInfoVC = [[PersonalInfoVC alloc] init];
    [self.navigationController pushViewController:personalInfoVC animated:YES];
}

- (void)onReport
{
    ReportProblemVC *reportVC = [[ReportProblemVC alloc] init];
    [reportVC setType:2];
    [self.navigationController pushViewController:reportVC animated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [UserCenter sharedInstance].userData.schools.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *schools = [UserCenter sharedInstance].userData.schools;
    SchoolInfo *school = schools[section];
    return [school.classes count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return kSchoolCellHeight;
    else
        return kClassCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 15)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0)
    {
        static NSString *cellID = @"SchoolCell";
        RelatedSchoolCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(nil == cell)
            cell = [[RelatedSchoolCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell setSchoolInfo:[UserCenter sharedInstance].userData.schools[indexPath.section]];
        return cell;
    }
    else
    {
        static NSString *cellID = @"ClassCell";
        RelatedClassCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(nil == cell)
            cell = [[RelatedClassCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        SchoolInfo *school = [UserCenter sharedInstance].userData.schools[indexPath.section];
        [cell setClassInfo:school.classes[indexPath.row - 1]];
        [cell setCellType:[BGTableViewCell cellTypeForTableView:tableView atIndexPath:indexPath]];
        return cell;
    }
}
@end
