//
//  ChildrenInfoVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/16.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ChildrenInfoVC.h"

#define kChildInfoCellAvatarNotificaton         @"kChildInfoCellAvatarNotificaton"
#define kChildInfoCellKey                       @"ChildInfoCellKey"

@implementation ChildrenItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _avatar = [[AvatarView alloc] initWithFrame:CGRectMake((self.width - 60) / 2, 0, 60, 60)];
        [self addSubview:_avatar];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _avatar.bottom + 5, self.width, 15)];
        [_nameLabel setTextColor:[UIColor whiteColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:13]];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_nameLabel];
    }
    return self;
}

- (void)setChildInfo:(ChildInfo *)childInfo
{
    _childInfo = childInfo;
    [_avatar setImageWithUrl:[NSURL URLWithString:_childInfo.avatar]];
    [_nameLabel setText:_childInfo.name];
}

@end

@interface ChildrenInfoVC ()
@property (nonatomic, strong)NSMutableArray *infoArray;
@end

@implementation ChildrenInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"孩子档案";
    self.infoArray = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorColor:kSepLineColor];
    [self.view addSubview:_tableView];
    
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 100)];
    [headerView setImage:[UIImage imageNamed:@"ChildrenBG"]];
    [headerView setUserInteractionEnabled:YES];
    
    _headerView = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 100)];
    [_headerView setDataSource:self];
    [_headerView setDelegate:self];
    [_headerView setDecelerationRate:0.5];
    [_headerView setType:iCarouselTypeRotary];
    [headerView addSubview:_headerView];
    [_tableView setTableHeaderView:headerView];
    
    [self refreshData];
}

- (void)refreshData
{
    NSArray *childrenArray = [UserCenter sharedInstance].children;
    if(childrenArray.count > 0)
    {
        [self.infoArray removeAllObjects];
        ChildInfo *childInfo = childrenArray[self.curIndex];
        PersonalInfoItem *nameItem = [[PersonalInfoItem alloc] initWithKey:@"姓名" value:childInfo.name canEdit:YES];
        [nameItem setRequestKey:@"name"];
        PersonalInfoItem *genderItem = [[PersonalInfoItem alloc] initWithKey:@"性别" value:kStringFromValue(childInfo.gender) canEdit:YES];
        [genderItem setRequestKey:@"sex"];
        PersonalInfoItem *birthDayItem = [[PersonalInfoItem alloc] initWithKey:@"出生日期" value:childInfo.birthday canEdit:NO];
        [birthDayItem setRequestKey:@"birthday"];
        
        PersonalInfoItem *nickItem = [[PersonalInfoItem alloc] initWithKey:@"孩子昵称" value:childInfo.nickName canEdit:YES];
        [nickItem setRequestKey:@"nick"];
        PersonalInfoItem *heightItem = [[PersonalInfoItem alloc] initWithKey:@"身高(cm)" value:(childInfo.height) canEdit:YES];
        [heightItem setKeyboardType:UIKeyboardTypeDecimalPad];
        [heightItem setRequestKey:@"height"];
        PersonalInfoItem *weightItem = [[PersonalInfoItem alloc] initWithKey:@"体重(kg)" value:(childInfo.weight) canEdit:YES];
        [weightItem setKeyboardType:UIKeyboardTypeDecimalPad];
        [weightItem setRequestKey:@"weight"];
        
        [self.infoArray addObjectsFromArray:@[nameItem,genderItem,birthDayItem,nickItem,heightItem,weightItem]];
    }
    [_tableView reloadData];
}

#pragma mark - iCarouselDelegate
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [UserCenter sharedInstance].children.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if(view == nil)
    {
        NSInteger width = carousel.width;
        ChildrenItemView *itemView = [[ChildrenItemView alloc] initWithFrame:CGRectMake(width * 0.1, 0, width * 0.8, 80)];
        [itemView setChildInfo:[UserCenter sharedInstance].children[index]];
        view = itemView;
    }
    return view;
}

- (void)carouselDidEndDecelerating:(iCarousel *)carousel
{
    self.curIndex = carousel.currentItemIndex;
    [self refreshData];
}
#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return self.infoArray.count;
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
    [headerView setBackgroundColor:kCommonBackgroundColor];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, headerView.width - 10 * 2, headerView.height)];
    [headerLabel setFont:[UIFont systemFontOfSize:13]];
    [headerLabel setTextColor:[UIColor colorWithHexString:@"8f8f8f"]];
    [headerView addSubview:headerLabel];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    static NSString *reuseID = @"InfoCell";
    PersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[PersonalInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
    }
    if(section == 0)
    {
        [cell setInfoItem:self.infoArray[row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
