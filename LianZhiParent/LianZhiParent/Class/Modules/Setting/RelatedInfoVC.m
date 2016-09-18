//
//  RelatedInfoVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/16.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "RelatedInfoVC.h"
#import "AddRelationVC.h"
#import "ChildrenInfoVC.h"
#import "ReportProblemVC.h"
@implementation RelatedHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        CGFloat margin = 10;
        _bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"WhiteBG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [_bgImageView setFrame:CGRectInset(self.bounds, 15, 15)];
        [self addSubview:_bgImageView];
        
        _avtarView = [[AvatarView alloc] initWithFrame:CGRectMake(15, margin, _bgImageView.height - margin * 2, _bgImageView.height - margin * 2)];
        [_bgImageView addSubview:_avtarView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setFont:[UIFont systemFontOfSize:18]];
        [_nameLabel setTextColor:[UIColor grayColor]];
        [_bgImageView addSubview:_nameLabel];
        
        _genderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [_bgImageView addSubview:_genderImageView];
        
        _birthdayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_birthdayLabel setFont:[UIFont systemFontOfSize:16]];
        [_birthdayLabel setTextColor:[UIColor grayColor]];
        [_bgImageView addSubview:_birthdayLabel];
        
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ParentRelationArrow.png"]];
        [_arrowImageView setOrigin:CGPointMake(_bgImageView.width - _arrowImageView.width - margin, (_bgImageView.height - _arrowImageView.height) / 2)];
        [_bgImageView addSubview:_arrowImageView];
    }
    return self;
}

- (void)setChildInfo:(ChildInfo *)childInfo
{
    _childInfo = childInfo;
    [_avtarView sd_setImageWithURL:[NSURL URLWithString:_childInfo.avatar]];
    [_nameLabel setText:_childInfo.name];
    [_nameLabel sizeToFit];
    [_nameLabel setOrigin:CGPointMake(_avtarView.right + 10, _bgImageView.height / 2 - 5 - _nameLabel.height)];
    
    [_genderImageView setImage:[UIImage imageNamed:_childInfo.sex == GenderMale ? @"GenderMale.png" : @"GenderFemale.png"]];
    [_genderImageView setOrigin:CGPointMake(_nameLabel.right + 10, _nameLabel.top + (_nameLabel.height - _genderImageView.height) / 2)];
    
    NSString *birthday = [NSString stringWithFormat:@"%@ (%@)",_childInfo.birthday,_childInfo.constellation];
    [_birthdayLabel setText:birthday];
    [_birthdayLabel sizeToFit];
    [_birthdayLabel setOrigin:CGPointMake(_avtarView.right + 10, _bgImageView.height / 2 + 5)];
}

@end

@implementation RelatedItemInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        
        _bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"CellBGFirst.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [_bgImageView setFrame:CGRectMake(15, 0, self.width - 15 * 2, 60)];
        [self addSubview:_bgImageView];
        
        _logoView = [[LogoView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [_bgImageView addSubview:_logoView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setFont:[UIFont systemFontOfSize:15]];
        [_nameLabel setTextColor:[UIColor grayColor]];
        [_bgImageView addSubview:_nameLabel];
        
        _mobileLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_mobileLabel setFont:[UIFont systemFontOfSize:15]];
        [_mobileLabel setTextColor:[UIColor grayColor]];
        [_bgImageView addSubview:_mobileLabel];
    }
    return self;
}

- (void)setItem:(TNModelItem *)item
{
    _item = item;
    NSString *logo = nil, *name = nil, *mobile = nil;
    if([_item isKindOfClass:[ClassInfo class]])
    {
        ClassInfo *classItem = (ClassInfo *)item;
        name = [NSString stringWithFormat:@"%@ %@",classItem.school.schoolName, classItem.name];
        logo = classItem.logo;
    }
    else
    {
        FamilyInfo *familyItem = (FamilyInfo *)item;
        name = [NSString stringWithFormat:@"%@ (%@)",familyItem.name,familyItem.relation];
        logo = familyItem.avatar;
        mobile = familyItem.mobile;
    }
    [_logoView sd_setImageWithURL:[NSURL URLWithString:logo]];
    [_mobileLabel setText:[mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
    [_mobileLabel sizeToFit];
    [_mobileLabel setOrigin:CGPointMake(_bgImageView.width - 10 - _mobileLabel.width, (_bgImageView.height - _mobileLabel.height) / 2)];
    
    [_nameLabel setText:name];
    [_nameLabel sizeToFit];
    [_nameLabel setOrigin:CGPointMake(_logoView.right + 10, (_bgImageView.height - _nameLabel.height) / 2)];
    [_nameLabel setWidth:_mobileLabel.left - _nameLabel.left - 10];
    
}

- (void)setCellType:(TableViewCellType)cellType
{
    _cellType = cellType;
    NSString *bgStr = nil;
    if(cellType == TableViewCellTypeLast)
        bgStr = @"CellBGLast.png";
    else if(cellType == TableViewCellTypeMiddle)
        bgStr = @"CellBGMiddle.png";
    else if(cellType == TableViewCellTypeFirst)
        bgStr = @"CellBGFirst.png";
    else
        bgStr = @"WhiteBG.png";
    [_bgImageView setImage:[[UIImage imageNamed:bgStr] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
}
@end



@interface RelatedInfoVC()
@property (nonatomic, assign)NSInteger curIndex;

@end

@implementation RelatedInfoVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_collectionView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"关联信息";
}

- (void)setupSubviews
{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 120)];
    [self setupHeaderView:_headerView];
    [self.view addSubview:_headerView];
    
    CGFloat spaceYStart = _headerView.bottom;
    if([UserCenter sharedInstance].children.count > 1)
    {
        UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, spaceYStart, self.view.width, 15)];
        [hintLabel setFont:[UIFont systemFontOfSize:12]];
        [hintLabel setTextColor:[UIColor lightGrayColor]];
        [hintLabel setTextAlignment:NSTextAlignmentCenter];
        [hintLabel setText:@"左右滑动可查看其他孩子信息"];
        [self.view addSubview:hintLabel];
        spaceYStart += hintLabel.height;
    }
    
    UIButton *reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [reportButton setFrame:CGRectMake(15, self.view.height - 45 - 15, self.view.width - 15 * 2, 45)];
    [reportButton addTarget:self action:@selector(onReport) forControlEvents:UIControlEventTouchUpInside];
    [reportButton setBackgroundImage:[UIImage imageWithColor:kCommonParentTintColor size:reportButton.size cornerRadius:5] forState:UIControlStateNormal];
    [reportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reportButton setTitle:@"报告关联错误" forState:UIControlStateNormal];
    [reportButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:reportButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, spaceYStart, self.view.width, reportButton.top - 10 - spaceYStart) style:UITableViewStyleGrouped];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    if([UserCenter sharedInstance].statusManager.changed != ChangedTypeNone)
        [self refreshRelatedInfo];
}

- (void)refreshRelatedInfo
{
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"user/get_related_info" method:REQUEST_GET type:REQUEST_REFRESH withParams:nil observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        if(responseObject.count > 0)
        {
            [[UserCenter sharedInstance].userData parseData:responseObject];
            [[UserCenter sharedInstance] save];
        }
    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)setupHeaderView:(UIView *)viewParent
{
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [_flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [_flowLayout setItemSize:viewParent.size];
    [_flowLayout setMinimumInteritemSpacing:0];
    [_flowLayout setMinimumLineSpacing:0];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:viewParent.bounds collectionViewLayout:_flowLayout];
    [_collectionView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_collectionView setPagingEnabled:YES];
    [_collectionView setShowsHorizontalScrollIndicator:NO];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView registerClass:[RelatedHeaderView class] forCellWithReuseIdentifier:@"RelatedHeaderView"];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [viewParent addSubview:_collectionView];
}

- (void)setCurIndex:(NSInteger)curIndex
{
    _curIndex = curIndex;
    [_tableView reloadData];
}

- (void)onReport
{
//    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"setting/feedback" method:REQUEST_POST type:REQUEST_REFRESH withParams:@{@"type":@"2",@"content":@"1"} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
//        [ProgressHUD showHintText:@"报告关联错误成功"];
//    } fail:^(NSString *errMsg) {
//        
//    }];
    ReportProblemVC *reportVC = [[ReportProblemVC alloc] init];
    [reportVC setType:2];
    [self.navigationController pushViewController:reportVC animated:YES];
}

- (void)onAddReleation
{
    AddRelationVC *addRelationVC = [[AddRelationVC alloc] init];
    [self.navigationController pushViewController:addRelationVC animated:YES];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [UserCenter sharedInstance].children.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RelatedHeaderView *childInfoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RelatedHeaderView" forIndexPath:indexPath];
    [childInfoCell setChildInfo:[UserCenter sharedInstance].children[indexPath.row]];
    return childInfoCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChildrenInfoVC *childInfoVC = [[ChildrenInfoVC alloc] init];
    [childInfoVC setCurIndex:self.curIndex];
    [self.navigationController pushViewController:childInfoVC animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == _collectionView)
    {
        CGFloat offsetX = scrollView.contentOffset.x;
        [self setCurIndex:(offsetX + 1) / scrollView.width];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    ChildInfo *childInfo = [UserCenter sharedInstance].children[self.curIndex];
    NSInteger num = 0;
    if(childInfo.classes.count > 0)
        num ++;
    if(childInfo.family.count > 0)
        num++;
    return num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ChildInfo *childInfo = [UserCenter sharedInstance].children[self.curIndex];
    NSArray *classes = childInfo.classes;
    NSArray *family = childInfo.family;
    NSInteger num = 0;
    if(section == 0 && classes.count > 0)
    {
        num = classes.count;
    }
    else
    {
        num = family.count;
    }
    return num;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ChildInfo *childInfo = [UserCenter sharedInstance].children[self.curIndex];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 25)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, headerView.width - 20 * 2, 25)];
    [titleLabel setTextColor:[UIColor lightGrayColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:16]];
    [headerView addSubview:titleLabel];
    if(section == 0 && childInfo.classes.count > 0)
        [titleLabel setText:@"就读于"];
    else
    {
        [titleLabel setText:@"家庭成员"];
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton setFrame:CGRectMake(headerView.width - 50 - 15, 0, 50, headerView.height)];
        [addButton setTitleColor:kCommonParentTintColor forState:UIControlStateNormal];
        [addButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [addButton setTitle:@"添加" forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(onAddReleation) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:addButton];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChildInfo *childInfo = [UserCenter sharedInstance].children[self.curIndex];
    static NSString *cellID = @"RelatedItemInfoCell";
    RelatedItemInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(nil == cell)
        cell = [[RelatedItemInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    if(indexPath.section == 0 && childInfo.classes.count)
        [cell setItem:childInfo.classes[indexPath.row]];
    else
        [cell setItem:childInfo.family[indexPath.row]];
    [cell setCellType:[BGTableViewCell cellTypeForTableView:tableView atIndexPath:indexPath]];
    return cell;
}
@end
