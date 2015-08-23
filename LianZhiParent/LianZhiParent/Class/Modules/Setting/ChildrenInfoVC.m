//
//  ChildrenInfoVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/16.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ChildrenInfoVC.h"
#import "AddRelationVC.h"
#define kChildInfoCellAvatarNotificaton         @"kChildInfoCellAvatarNotificaton"
#define kChildInfoCellKey                       @"ChildInfoCellKey"

#define kAvatarCellHeight                       64

@implementation AvatarCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.width = kScreenWidth;
        _avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(15, (kAvatarCellHeight - 46) / 2, 46, 46)];
        [self addSubview:_avatarView];
        
        _modifyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_modifyLabel setTextColor:kCommonParentTintColor];
        [_modifyLabel setFont:[UIFont systemFontOfSize:14]];
        [_modifyLabel setText:@"编辑"];
        [_modifyLabel sizeToFit];
        [_modifyLabel setOrigin:CGPointMake(self.width - 12 - _modifyLabel.width, (kAvatarCellHeight - _modifyLabel.height) / 2)];
        [self addSubview:_modifyLabel];
    }
    return self;
}

- (void)setChildInfo:(ChildInfo *)childInfo
{
    _childInfo = childInfo;
    [_avatarView setImageWithUrl:[NSURL URLWithString:_childInfo.avatar]];
}

@end

@implementation ChildrenExtraInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.width = kScreenWidth;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _logoView = [[LogoView alloc] initWithFrame:CGRectMake(12, 10, 35, 35)];
        [self addSubview:_logoView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_logoView.right + 10, 0, 0, 0)];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_titleLabel];
        
        _extraLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_extraLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [_extraLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:_extraLabel];
        
        _reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reportButton setBackgroundImage:[[UIImage imageWithColor:[UIColor colorWithHexString:@"949494"] size:CGSizeMake(18, 18) cornerRadius:9] resizableImageWithCapInsets:UIEdgeInsetsMake(9, 9, 9, 9)] forState:UIControlStateNormal];
        [_reportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_reportButton.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [_reportButton setTitle:@"报错" forState:UIControlStateNormal];
        [_reportButton setFrame:CGRectMake(self.width - 12 - 36, (55 - 18) / 2, 36, 18)];
        [self addSubview:_reportButton];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 55 - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
    }
    return self;
}
- (void)setText:(NSString *)text extra:(NSString *)extra
{
    [_titleLabel setText:text];
    [_titleLabel sizeToFit];
    [_titleLabel setOrigin:CGPointMake(_logoView.right + 10, (55 - _titleLabel.height) / 2)];
    [_extraLabel setText:extra];
    [_extraLabel sizeToFit];
    [_extraLabel setOrigin:CGPointMake(_titleLabel.right + 10, (55 - _extraLabel.height) / 2)];
}

@end

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
@property (nonatomic, strong)UIImage *avatarImage;
@property (nonatomic, strong)NSMutableArray *infoArray;
@end

@implementation ChildrenInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"孩子档案";
    self.infoArray = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
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

- (void)onAdd
{
    AddRelationVC *addRelationVC = [[AddRelationVC alloc] init];
    [CurrentROOTNavigationVC pushViewController:addRelationVC animated:YES];
}

- (void)modifyAvatar
{
    TNButtonItem *destructiveItem = [TNButtonItem itemWithTitle:@"取消本次操作" action:^{
        
    }];
    TNButtonItem *takePhotoItem = [TNButtonItem itemWithTitle:@"拍摄一张清晰头像" action:^{
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setAllowsEditing:YES];
        [imagePicker setDelegate:self];
        [CurrentROOTNavigationVC presentViewController:imagePicker animated:YES completion:nil];
    }];
    TNButtonItem *albumItem = [TNButtonItem itemWithTitle:@"从手机相册选择" action:^{
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [imagePicker setAllowsEditing:YES];
        [imagePicker setDelegate:self];
        [CurrentROOTNavigationVC presentViewController:imagePicker animated:YES completion:nil];
    }];
    TNActionSheet *actionSheet = [[TNActionSheet alloc] initWithTitle:@"头像是快捷身份识别标志\n请您务必上传真实照片" descriptionView:nil destructiveButton:destructiveItem cancelItem:nil otherItems:@[takePhotoItem,albumItem]];
    [actionSheet show];
}

- (void)saveInfo
{
    NSArray *infoArray = self.infoArray;
    ChildInfo *childInfo = [UserCenter sharedInstance].children[self.curIndex];
    
    PersonalInfoItem *nameItem = [infoArray objectAtIndex:0];
    if([nameItem.value length] == 0)
    {
        [ProgressHUD showHintText:@"孩子姓名不能为空"];
        return;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (PersonalInfoItem *item in infoArray) {
        [params setValue:item.value forKey:item.requestKey];
        if([item.requestKey isEqualToString:@"nick"])
        {
            if(item.value.length > 8)
            {
                [ProgressHUD showHintText:@"孩子昵称不能超过8个字符"];
                return;
            }
        }
        else if ([item.requestKey isEqualToString:@"height"])
        {
            CGFloat height = item.value.floatValue;
            if(height > 250 || height < 0)
            {
                [ProgressHUD showHintText:@"请输入正常的身高"];
                return;
            }
        }
        else if([item.requestKey isEqualToString:@"weight"])
        {
            CGFloat weight = item.value.floatValue;
            if(weight > 150 || weight < 0)
            {
                [ProgressHUD showHintText:@"请输入正常的体重"];
                return;
            }
        }
        else if ([item.requestKey isEqualToString:@"name"])
        {
            if(item.value.length > 8)
            {
                [ProgressHUD showHintText:@"孩子名字不能超过8个字"];
                return;
            }
        }
    }
    [params setValue:childInfo.uid forKey:@"child_id"];
    __weak typeof(self) wself = self;
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在修改孩子信息" toView:self.view];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"setting/set_child_info" withParams:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(wself.avatarImage)
            [formData appendPartWithFileData:UIImageJPEGRepresentation(wself.avatarImage, 0.8) name:@"head" fileName:@"head" mimeType:@"image/JPEG"];
    } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        wself.avatarImage = nil;
        TNDataWrapper *childWrapper = [responseObject getDataWrapperForKey:@"child"];
        if([childInfo.uid isEqualToString:[childWrapper getStringForKey:@"id"]])
        {
            [childInfo parseData:childWrapper];
            [[UserCenter sharedInstance] save];
            [[NSNotificationCenter defaultCenter] postNotificationName:kChildInfoChangedNotification object:nil];
        }
        [_headerView reloadData];
        [_tableView reloadData];
        [hud hide:YES];
        [ProgressHUD showHintText:@"修改信息成功"];
    } fail:^(NSString *errMsg) {
        [hud hide:YES];
        [ProgressHUD showHintText:errMsg];
    }];

}

#pragma mark - UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.avatarImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self saveInfo];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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


- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
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
    ChildInfo *childInfo = [UserCenter sharedInstance].children[self.curIndex];
    if(section == 0)
    {
        return self.infoArray.count + 1;
    }
    else if(section == 1)
    {
        return childInfo.classes.count;
    }
    else
    {
        return childInfo.family.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
            return kAvatarCellHeight;
        return 50;
    }
    else
        return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
    [headerView setBackgroundColor:kCommonBackgroundColor];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, headerView.width - 10 * 2, headerView.height)];
    [headerLabel setFont:[UIFont systemFontOfSize:13]];
    [headerLabel setTextColor:[UIColor colorWithHexString:@"8f8f8f"]];
    if(section == 0)
        [headerLabel setText:@"孩子信息"];
    else if(section == 1)
        [headerLabel setText:@"学校信息"];
    else
        [headerLabel setText:@"家庭信息"];
    [headerView addSubview:headerLabel];
    
    if(section == 2)
    {
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton setTitle:@"添加" forState:UIControlStateNormal];
        [addButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [addButton addTarget:self action:@selector(onAdd) forControlEvents:UIControlEventTouchUpInside];
        [addButton setTitleColor:kCommonParentTintColor forState:UIControlStateNormal];
        [addButton setFrame:CGRectMake(headerView.width - 50, 0, 50, headerView.height)];
        [headerView addSubview:addButton];
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == 0)
    {
        if(row == 0)
        {
            NSString *reuseID = @"AvatarCell";
            AvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
            if(cell == nil)
            {
                cell = [[AvatarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            }
            [cell setChildInfo:[UserCenter sharedInstance].children[self.curIndex]];
            return cell;
        }
        else
        {
            NSString *reuseID = @"InfoCell";
            PersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
            if(nil == cell)
            {
                cell = [[PersonalInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
            }
            [cell setInfoItem:self.infoArray[row - 1]];
            return cell;
        }
    }
    else
    {
        NSString *reuseID = @"ExtraInfoCell";
        ChildrenExtraInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if(nil == cell)
        {
            cell = [[ChildrenExtraInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        }
        ChildInfo *childInfo = [UserCenter sharedInstance].children[self.curIndex];
        if(section == 1)
        {
            ClassInfo *classInfo = childInfo.classes[row];
            [cell.logoView setImageWithUrl:[NSURL URLWithString:classInfo.schoolInfo.logo]];
            [cell.logoView setHidden:NO];
            [cell setText:classInfo.schoolInfo.schoolName extra:classInfo.className];
        }
        else
        {
            FamilyInfo *familyInfo = childInfo.family[row];
            [cell.logoView setHidden:YES];
            [cell setText:[NSString stringWithFormat:@"%@(%@)",familyInfo.name,familyInfo.relation] extra:[NSString stringWithFormat:@"(%@)",familyInfo.mobile]];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == 0 && row == 0)
    {
        [self modifyAvatar];
    }
}


@end
