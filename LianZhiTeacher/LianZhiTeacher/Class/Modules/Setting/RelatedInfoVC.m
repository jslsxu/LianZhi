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

@implementation RelatedSchoolCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        _bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:(@"CellBGFirst.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [_bgImageView setFrame:CGRectMake(15, 0, self.width - 15 * 2, 60)];
        [self addSubview:_bgImageView];
        
        _logoView = [[LogoView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [_bgImageView addSubview:_logoView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setFont:[UIFont systemFontOfSize:17]];
        [_nameLabel setTextColor:[UIColor grayColor]];
        [_bgImageView addSubview:_nameLabel];
        
    }
    return self;
}
- (void)setSchoolInfo:(SchoolInfo *)schoolInfo
{
    _schoolInfo = schoolInfo;
    [_logoView setImageWithUrl:[NSURL URLWithString:schoolInfo.logoUrl]];
    [_nameLabel setText:_schoolInfo.schoolName];
    [_nameLabel sizeToFit];
    [_nameLabel setOrigin:CGPointMake(_logoView.right + 15, (_bgImageView.height - _nameLabel.height) / 2)];
}
@end

@implementation RelatedClassCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        _bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:(@"CellBGFirst.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [_bgImageView setFrame:CGRectMake(15, 0, self.width - 15 * 2, 60)];
        [self addSubview:_bgImageView];
        
        _logoView = [[LogoView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [_bgImageView addSubview:_logoView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setFont:[UIFont systemFontOfSize:15]];
        [_nameLabel setTextColor:[UIColor grayColor]];
        [_bgImageView addSubview:_nameLabel];

    }
    return self;
}

- (void)setCellType:(TableViewCellType)cellType
{
    _cellType = cellType;
    if(cellType == TableViewCellTypeLast)
        [_bgImageView setImage:[[UIImage imageNamed:(@"CellBGLast.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    else
        [_bgImageView setImage:[[UIImage imageNamed:(@"CellBGMiddle.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
}
- (void)setClassInfo:(ClassInfo *)classInfo
{
    _classInfo = classInfo;
    [_logoView setImageWithUrl:[NSURL URLWithString:classInfo.logoUrl]];
    [_nameLabel setText:[NSString stringWithFormat:@"%@ (%@)",classInfo.className,_classInfo.course]];
    [_nameLabel sizeToFit];
    [_nameLabel setOrigin:CGPointMake(_logoView.right + 15, (_bgImageView.height - _nameLabel.height) / 2)];
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
    self.title = @"关联信息";
}

- (void)refreshData
{
    [_tableView reloadData];
    [self setupHeaderView:_headerView];
}

- (void)setupSubviews
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 70) style:UITableViewStylePlain];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 120)];
    [self setupHeaderView:_headerView];
    [_tableView setTableHeaderView:_headerView];
    
    UIButton *reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reportButton setFrame:CGRectMake(15, self.view.height - 60, self.view.width - 15 * 2, 45)];
    [reportButton addTarget:self action:@selector(onReport) forControlEvents:UIControlEventTouchUpInside];
    [reportButton setBackgroundImage:[[UIImage imageNamed:(@"BlueBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [reportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reportButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [reportButton setTitle:@"报告关联错误" forState:UIControlStateNormal];
    [self.view addSubview:reportButton];
}

- (void)setupHeaderView:(UIView *)viewParent
{
    NSArray *subviews = [viewParent subviews];
    [subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat margin = 10;
    UIImageView*    bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:(@"WhiteBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    [bgImageView setFrame:CGRectInset(viewParent.bounds, 15, 15)];
    [viewParent addSubview:bgImageView];
    
    AvatarView *avatar = [[AvatarView alloc] initWithFrame:CGRectMake(15, margin, bgImageView.height - margin * 2, bgImageView.height - margin * 2)];
    [avatar setImageWithUrl:[NSURL URLWithString:[UserCenter sharedInstance].userInfo.avatar]];
    [bgImageView addSubview:avatar];
    
    UILabel*    nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [nameLabel setFont:[UIFont systemFontOfSize:18]];
    [nameLabel setTextColor:[UIColor grayColor]];
    [nameLabel setText:[UserCenter sharedInstance].userInfo.name];
    [nameLabel sizeToFit];
    [nameLabel setOrigin:CGPointMake(avatar.right + margin, bgImageView.height / 2 - 5 - nameLabel.height)];
    [bgImageView addSubview:nameLabel];
    
    GenderType gender = [UserCenter sharedInstance].userInfo.gender;
    NSString *imageStr = gender == GenderMale ? (@"GenderMale.png") : (@"GenderFemale.png");
    UIImageView *genderImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageStr]];
    [genderImage setOrigin:CGPointMake(nameLabel.right + 10, nameLabel.top + (nameLabel.height - genderImage.height) / 2)];
    [bgImageView addSubview:genderImage];
    
    UILabel*    birthdayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [birthdayLabel setFont:[UIFont systemFontOfSize:16]];
    [birthdayLabel setTextColor:[UIColor grayColor]];
    NSString *birthday = [NSString stringWithFormat:@"%@ (%@)",[UserCenter sharedInstance].userInfo.birthDay,[UserCenter sharedInstance].userInfo.constellation];
    [birthdayLabel setText:birthday];
    [birthdayLabel sizeToFit];
    [birthdayLabel setOrigin:CGPointMake(avatar.right + 10, bgImageView.height / 2 + 5)];
    [bgImageView addSubview:birthdayLabel];

    UIImageView*    arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]];
    [arrowImage setOrigin:CGPointMake(bgImageView.width - arrowImage.width - margin, (bgImageView.height - arrowImage.height) / 2)];
    [bgImageView addSubview:arrowImage];
    
    UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [coverButton setFrame:viewParent.bounds];
    [coverButton addTarget:self action:@selector(onCoverButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [viewParent addSubview:coverButton];
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
//    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"setting/feedback" method:REQUEST_POST type:REQUEST_REFRESH withParams:@{@"type":@"2",@"content":@"1"} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
//        [ProgressHUD showHintText:@"报告关联错误成功"];
//    } fail:^(NSString *errMsg) {
//        
//    }];
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
    return 60;
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
