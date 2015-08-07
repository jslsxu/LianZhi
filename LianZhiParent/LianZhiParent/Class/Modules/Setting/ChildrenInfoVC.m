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
@implementation ChildInfoCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:_tableView];
        
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 110)];
        [self setupHeaderView:_headerView];
        [_tableView setTableHeaderView:_headerView];
        
        if([UserCenter sharedInstance].children.count > 1)
        {
            UILabel *footerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 30)];
            [footerView setTextColor:[UIColor lightGrayColor]];
            [footerView setFont:[UIFont systemFontOfSize:12]];
            [footerView setTextAlignment:NSTextAlignmentCenter];
            [footerView setText:@"左右滑动查看其他孩子"];
            [_tableView setTableFooterView:footerView];
        }
    }
    return self;
}

- (void)setupHeaderView:(UIView *)viewParent
{
    
    _idLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_idLabel setTextColor:kCommonParentTintColor];
    [_idLabel setFont:[UIFont systemFontOfSize:14]];
    [_idLabel sizeToFit];
    [_idLabel setOrigin:CGPointMake(viewParent.width - _idLabel.width - 10, 5)];
    [viewParent addSubview:_idLabel];
    CGFloat spaceYStart = 20;
    _avatar = [[AvatarView alloc] initWithFrame:CGRectMake(24, 15 + spaceYStart, 60, 60)];
    [_avatar setBorderWidth:2];
    [_avatar setBorderColor:[UIColor colorWithWhite:0 alpha:0.2]];
    [viewParent addSubview:_avatar];
    
    _modifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_modifyButton setFrame:CGRectMake(24, _avatar.bottom + 2, _avatar.width, 30)];
    [_modifyButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_modifyButton setTitleColor:kCommonParentTintColor forState:UIControlStateNormal];
    [_modifyButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_modifyButton addTarget:self action:@selector(onAvatarModification) forControlEvents:UIControlEventTouchUpInside];
    [viewParent addSubview:_modifyButton];
    
    for (NSInteger i = 0; i < 2; i++)
    {
        UILabel*    hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(118, 20 + spaceYStart, 65, 16)];
        [hintLabel setBackgroundColor:[UIColor clearColor]];
        [hintLabel setFont:[UIFont systemFontOfSize:15]];
        [hintLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        if(i == 0)
            [hintLabel setText:@"姓名:"];
        else
            [hintLabel setText:@"性别:"];
        [viewParent addSubview:hintLabel];
        
        if(i == 0)
        {
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(160, 20 + spaceYStart - (24 - 16) / 2, 140, 24)];
            [textField setDelegate:self];
            [textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
            [textField setFont:[UIFont systemFontOfSize:14]];
            [textField setTextColor:[UIColor colorWithHexString:@"666666"]];
            [textField setBackgroundColor:[UIColor clearColor]];
            _nameField = textField;
            [viewParent addSubview:textField];
        }
        else
        {
            _genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 20 + spaceYStart - (24 - 16) / 2, 140, 24)];
            [_genderLabel setUserInteractionEnabled:YES];
            [_genderLabel setFont:[UIFont systemFontOfSize:14]];
            [_genderLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
            [viewParent addSubview:_genderLabel];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
            [_genderLabel addGestureRecognizer:tap];
        }
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(108, 44 + spaceYStart, viewParent.width - 12 - 108, 1)];
        [sepLine setBackgroundColor:[UIColor colorWithHexString:@"d8d8d8"]];
        [viewParent addSubview:sepLine];
        
        spaceYStart += 45;
    }
}

- (void)setChildInfo:(ChildInfo *)childInfo
{
    _childInfo = childInfo;
    [self setupInfoArray];
    [_tableView reloadData];
}

- (void)setupInfoArray
{
    if(_infoArray)
        [_infoArray removeAllObjects];
    else
        _infoArray = [[NSMutableArray alloc] init];
    PersonalInfoItem *nameItem = [[PersonalInfoItem alloc] initWithKey:@"姓名:" value:self.childInfo.name canEdit:YES];
    [nameItem setRequestKey:@"name"];
    PersonalInfoItem *genderItem = [[PersonalInfoItem alloc] initWithKey:@"性别:" value:kStringFromValue(self.childInfo.gender) canEdit:YES];
    [genderItem setRequestKey:@"sex"];
    PersonalInfoItem *birthDayItem = [[PersonalInfoItem alloc] initWithKey:@"出生日期:" value:self.childInfo.birthday canEdit:NO];
    [birthDayItem setRequestKey:@"birthday"];
    
    PersonalInfoItem *nickItem = [[PersonalInfoItem alloc] initWithKey:@"孩子昵称:" value:self.childInfo.nickName canEdit:YES];
    [nickItem setRequestKey:@"nick"];
    PersonalInfoItem *heightItem = [[PersonalInfoItem alloc] initWithKey:@"身高(cm):" value:(self.childInfo.height) canEdit:YES];
    [heightItem setKeyboardType:UIKeyboardTypeDecimalPad];
    [heightItem setRequestKey:@"height"];
    PersonalInfoItem *weightItem = [[PersonalInfoItem alloc] initWithKey:@"体重(kg):" value:(self.childInfo.weight) canEdit:YES];
    [weightItem setKeyboardType:UIKeyboardTypeDecimalPad];
    [weightItem setRequestKey:@"weight"];
    
    [_infoArray addObjectsFromArray:@[nameItem,genderItem,birthDayItem,nickItem,heightItem,weightItem]];
    [_avatar setImageWithUrl:[NSURL URLWithString:self.childInfo.avatar]];
    [_idLabel setText:[NSString stringWithFormat:@"连枝号:%@",self.childInfo.uid]];
    [_idLabel sizeToFit];
    [_idLabel setOrigin:CGPointMake(self.width - _idLabel.width - 10, 5)];
    [_nameField setText:nameItem.value];
    [_genderLabel setText:genderItem.value.integerValue == GenderFemale ? @"美女" :@"帅哥"];
}

- (void)onAvatarModification
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _infoArray.count - 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseID = [NSString stringWithFormat:@"PersonalInfoCell%ld",(long)indexPath.row];
    PersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[PersonalInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    [cell setInfoItem:[_infoArray objectAtIndex:indexPath.row + 2]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self endEditing:YES];
    if(indexPath.row == 0)//出生日期
    {
        SettingDatePickerView *datePicker = [[SettingDatePickerView alloc] initWithType:SettingDatePickerTypeDate];
        [datePicker setBlk:^(NSString *dateStr){
            PersonalInfoItem *birthdayItem = [_infoArray objectAtIndex:indexPath.row + 2];
            [birthdayItem setValue:dateStr];
            [tableView reloadData];
        }];
        [datePicker show];
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self endEditing:YES];
}

- (void)textFieldEditingChanged:(UITextField *)textField
{
    PersonalInfoItem *nameItem = [_infoArray objectAtIndex:0];
    NSString *key = nameItem.requestKey;
    NSString *text = textField.text;
    if([key isEqualToString:@"nick"] || [key isEqualToString:@"name"])
    {
        if(text.length > 8 && textField.markedTextRange == nil)
        {
            text = [text substringWithRange:NSMakeRange(0, 8)];
            [textField setText:text];
        }
    }
    else if ([key isEqualToString:@"身高(cm)"])
    {
        
    }
    [nameItem setValue:text];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)onTap
{
    [self endEditing:YES];
    TNButtonItem *maleItem = [TNButtonItem itemWithTitle:@"帅哥" action:^{
        _genderLabel.text = @"帅哥";
        PersonalInfoItem *genderItem = _infoArray[1];
        genderItem.value = kStringFromValue(GenderMale);
    }];
    TNButtonItem *femaleItem = [TNButtonItem itemWithTitle:@"美女" action:^{
        _genderLabel.text = @"美女";
        PersonalInfoItem *genderItem = _infoArray[1];
        genderItem.value = kStringFromValue(GenderFemale);
    }];
    TNActionSheet *actionSheet = [[TNActionSheet alloc] initWithTitle:@"选择性别" descriptionView:nil destructiveButton:nil cancelItem:nil otherItems:@[maleItem,femaleItem]];
    [actionSheet show];
}

#pragma mark - UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.avatarImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [_avatar setImage:self.avatarImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end

@implementation ChildrenInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"孩子档案";
}

- (void)setupSubviews
{
    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [_flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [_flowLayout setItemSize:CGSizeMake(self.view.width, self.view.height - 70)];
    [_flowLayout setMinimumInteritemSpacing:0];
    [_flowLayout setMinimumLineSpacing:0];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 70) collectionViewLayout:_flowLayout];
    [_collectionView setShowsHorizontalScrollIndicator:NO];
    [_collectionView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_collectionView setPagingEnabled:YES];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView registerClass:[ChildInfoCell class] forCellWithReuseIdentifier:@"ChildInfoCell"];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [self.view addSubview:_collectionView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, _collectionView.bottom, self.view.width, 15)];
    [label setTextColor:[UIColor lightGrayColor]];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setTextAlignment:NSTextAlignmentCenter];
    if([UserCenter sharedInstance].children.count > 1)
        [label setText:@""];
    [self.view addSubview:label];

    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveButton addTarget:self action:@selector(onSaveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_saveButton setFrame:CGRectMake(15, label.bottom, self.view.width - 10 * 2, self.view.height - 10 - label.bottom)];
    [_saveButton setBackgroundImage:[[UIImage imageNamed:MJRefreshSrcName(@"GreenBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saveButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_saveButton setTitle:@"保存修改" forState:UIControlStateNormal];
    [self.view addSubview:_saveButton];
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.curIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark - UICollectionViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    _curIndex = (offsetX + 1) / scrollView.width;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [UserCenter sharedInstance].children.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChildInfoCell *childInfoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChildInfoCell" forIndexPath:indexPath];
    [childInfoCell setChildInfo:[UserCenter sharedInstance].children[indexPath.row]];
    return childInfoCell;
}

- (void)onSaveButtonClicked
{
    [self.view endEditing:YES];
    ChildInfoCell *infoCell = (ChildInfoCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_curIndex inSection:0]];
    NSArray *infoArray = [infoCell infoArray];
    ChildInfo *childInfo = infoCell.childInfo;
    
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
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在修改孩子信息" toView:self.view];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"setting/set_child_info" withParams:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(infoCell.avatarImage)
            [formData appendPartWithFileData:UIImageJPEGRepresentation(infoCell.avatarImage, 0.8) name:@"head" fileName:@"head" mimeType:@"image/JPEG"];
    } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        TNDataWrapper *childWrapper = [responseObject getDataWrapperForKey:@"child"];
        if([childInfo.uid isEqualToString:[childWrapper getStringForKey:@"id"]])
        {
            [childInfo parseData:childWrapper];
            [[UserCenter sharedInstance] save];
            [[NSNotificationCenter defaultCenter] postNotificationName:kChildInfoChangedNotification object:nil];
        }
        [hud hide:YES];
        [ProgressHUD showHintText:@"修改信息成功"];
    } fail:^(NSString *errMsg) {
        [hud hide:YES];
        [ProgressHUD showHintText:errMsg];
    }];
}

@end
