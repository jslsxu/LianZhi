//
//  AddRelationVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/2/6.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "AddRelationVC.h"
#import "ChildrenInfoVC.h"
#import "CommonInputVC.h"
@interface AddRelationVC()
@property (nonatomic, strong)UIImage *avatarImage;
@property (nonatomic, strong)PersonalInfoItem *targetItem;
@end

@implementation AddRelationVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    [backItem setTitle:@"返回"];
    self.navigationItem.backBarButtonItem = backItem;
    _relationArray = @[@{@"name":@"爸爸",@"id":@"0"},@{@"name":@"妈妈",@"id":@"1"},@{@"name":@"爷爷",@"id":@"2"},@{@"name":@"奶奶",@"id":@"3"},@{@"name":@"外公",@"id":@"4"},@{@"name":@"外婆",@"id":@"5"},@{@"name":@"其他监护人",@"id":@"6"}];
    self.title = @"添加成员";
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
//    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 110)];
//    [self setupHeaderView:_headerView];
//    [self.tableView setTableHeaderView:_headerView];

    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 80)];
    [self setupFooterView:footerView];
    [self.tableView setTableFooterView:footerView];
    
    [self setupInfoArray];
    [self.tableView reloadData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAddRelation) name:kAddRelationNotification object:nil];
}

- (void)setupFooterView:(UIView *)viewParent
{
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setFrame:CGRectMake(12, (viewParent.height - 36) / 2, viewParent.width - 12 * 2, 36)];
    [saveButton addTarget:self action:@selector(onSaveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setBackgroundImage:[[UIImage imageWithColor:[UIColor colorWithHexString:@"E82551"] size:saveButton.size cornerRadius:18] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 0, 18)] forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [saveButton setTitle:@"申请添加家庭成员" forState:UIControlStateNormal];
    [viewParent addSubview:saveButton];
}


- (void)setupInfoArray
{
    if(_infoArray)
        [_infoArray removeAllObjects];
    else
        _infoArray = [[NSMutableArray alloc] init];
    PersonalInfoItem *nameItem = [[PersonalInfoItem alloc] initWithKey:@"姓名" value:nil canEdit:YES];
    [nameItem setRequestKey:@"name"];
    PersonalInfoItem *nickItem = [[PersonalInfoItem alloc] initWithKey:@"昵称" value:nil canEdit:YES];
    [nickItem setRequestKey:@"nick"];
    PersonalInfoItem *birthdayItem = [[PersonalInfoItem alloc] initWithKey:@"出生日期" value:nil canEdit:YES];
    [birthdayItem setRequestKey:@"birthday"];
    PersonalInfoItem *mailItem = [[PersonalInfoItem alloc] initWithKey:@"联系邮箱" value:nil canEdit:YES];
    [mailItem setRequestKey:@"email"];
    PersonalInfoItem *phoneItem = [[PersonalInfoItem alloc] initWithKey:@"登录手机" value:nil canEdit:YES];
    [phoneItem setKeyboardType:UIKeyboardTypePhonePad];
    [phoneItem setRequestKey:@"mobile"];
    PersonalInfoItem *accountItem = [[PersonalInfoItem alloc] initWithKey:@"连枝账号" value:nil canEdit:YES];
    [accountItem setKeyboardType:UIKeyboardTypeNumberPad];
    [accountItem setRequestKey:@"uid"];
    PersonalInfoItem *relationShipItem = [[PersonalInfoItem alloc] initWithKey:@"家长身份" value:nil canEdit:NO];
    [relationShipItem setRequestKey:@"relations"];
    [_infoArray addObjectsFromArray:@[nameItem,nickItem,birthdayItem,mailItem,phoneItem,accountItem,relationShipItem]];
}

//- (void)onAvatarModification
//{
//    TNButtonItem *destructiveItem = [TNButtonItem itemWithTitle:@"取消本次操作" action:^{
//        
//    }];
//    TNButtonItem *takePhotoItem = [TNButtonItem itemWithTitle:@"拍摄一张清晰头像" action:^{
//        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
//        [imagePicker setAllowsEditing:YES];
//        [imagePicker setDelegate:self];
//        [CurrentROOTNavigationVC presentViewController:imagePicker animated:YES completion:nil];
//    }];
//    TNButtonItem *albumItem = [TNButtonItem itemWithTitle:@"从手机相册选择" action:^{
//        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
//        [imagePicker setAllowsEditing:YES];
//        [imagePicker setDelegate:self];
//        [CurrentROOTNavigationVC presentViewController:imagePicker animated:YES completion:nil];
//    }];
//    TNActionSheet *actionSheet = [[TNActionSheet alloc] initWithTitle:@"头像是快捷身份识别标志\n请您无比上传真实照片" descriptionView:nil destructiveButton:destructiveItem cancelItem:nil otherItems:@[takePhotoItem,albumItem]];
//    [actionSheet show];
//}

- (void)onAddRelation
{
    NSInteger relationNum = 0;
    for (PersonalInfoItem *item in _infoArray) {
        if([item.key isEqualToString:@"家长身份"])
            relationNum++;
    }
    if(relationNum < [UserCenter sharedInstance].children.count)
    {
        PersonalInfoItem *addRelationItem = [[PersonalInfoItem alloc] initWithKey:@"家长身份" value:nil canEdit:NO];
        [_infoArray addObject:addRelationItem];
        [self.tableView reloadData];
    }
    else
    {
        TNButtonItem *confirmItem = [TNButtonItem itemWithTitle:@"确定" action:nil];
        TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"添加身份已达上限，不能超过孩子个数" buttonItems:@[confirmItem]];
        [alertView show];
    }
}

- (void)onSaveButtonClicked
{
    [self.view endEditing:YES];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSMutableArray *relationArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i< _infoArray.count; i++) {
        PersonalInfoItem *infoItem = [_infoArray objectAtIndex:i];
        if(i >= 6)
        {
            if(infoItem.relation)
            [relationArray addObject:@{@"child_id":infoItem.relation[@"child_id"],@"relation":infoItem.relation[@"relationID"]}];
        }
        else
        {
            PersonalInfoItem *item = [_infoArray objectAtIndex:i];
            [params setValue:item.value forKey:item.requestKey];
        }
    }
    
    if(relationArray.count == 0)
    {
        [ProgressHUD showHintText:@"请添加家长身份"];
        return;
    }
    NSString *relations = [NSString stringWithJSONObject:relationArray];
    [params setValue:relations forKey:@"relations"];
    
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在添加" toView:self.view];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"setting/add_member" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [hud hide:NO];
        [ProgressHUD showHintText:@"系统正在进行人工审核，将在\n两个工作日内完成"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
    } fail:^(NSString *errMsg) {
        [hud hide:NO];
        [MBProgressHUD showError:errMsg toView:self.view];
    }];
}

- (void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.avatarImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.tableView reloadData];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _infoArray.count + 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row > 7)
        return YES;
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_infoArray removeObjectAtIndex:indexPath.row - 1];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if(row == 0)
    {
        NSString *reuseID = @"AvatarCell";
        AvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if(cell == nil)
        {
            cell = [[AvatarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        }
        if(self.avatarImage)
            [cell.avatarView setImage:self.avatarImage];
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
        [cell setInfoItem:_infoArray[row - 1]];
        
        if(indexPath.row == _infoArray.count)
        {
            NSInteger relationNum = 0;
            for (PersonalInfoItem *item in _infoArray) {
                if([item.key isEqualToString:@"家长身份"])
                    relationNum++;
            }
            if(relationNum < [UserCenter sharedInstance].children.count)
                [cell setShowAdd:YES];
            else
                [cell setShowAdd:NO];
        }
        else
            [cell setShowAdd:NO];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return 64;
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    NSInteger row = indexPath.row;
    PersonalInfoItem *item = nil;
    if(row > 0)
        item = _infoArray[row - 1];
    if(row == 0)
    {
        [self modifyAvatar];
    }
    else if(row == 1 || row == 2 || row == 4 || row == 5 || row == 6)
    {
        CommonInputVC *inputVC = [[CommonInputVC alloc] initWithOriginal:item.value forKey:item.key completion:^(NSString *value) {
            BOOL validate = YES;
            if(row == 4)
            {
                validate = [value isEmailAddress];
                if(!validate)
                {
                    [ProgressHUD showHintText:@"邮箱格式不正确"];
                }
            }
            if(validate)
            {
                item.value = value;
                [self.tableView reloadData];
            }
        }];
        [self.navigationController pushViewController:inputVC animated:YES];
    }
    else if(row == 3)
    {
        [self.view endEditing:YES];
        SettingDatePickerView*  datePicker = [[SettingDatePickerView alloc] initWithType:SettingDatePickerTypeDate];
        [datePicker setBlk:^(NSString *dateStr){
            [item setValue:dateStr];
            [self.tableView reloadData];
        }];
        [datePicker show];
    }
    else if(row >= 7)
    {
        [self.view endEditing:YES];
        //家长身份
        [self setTargetItem:item];
        ActionSelectView *selectView = [[ActionSelectView alloc] init];
        [selectView setDelegate:self];
        [selectView show];
    }
}


#pragma mark - ActionSelectDelegate

- (NSInteger)numberOfComponentsInPickerView:(ActionSelectView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(ActionSelectView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
        return [UserCenter sharedInstance].children.count;
    else
        return _relationArray.count;
}

- (NSString *)pickerView:(ActionSelectView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
    {
        ChildInfo *child = [UserCenter sharedInstance].children[row];
        return child.name;
    }
    else
    {
        NSDictionary *relationDic = [_relationArray objectAtIndex:row];
        return relationDic[@"name"];
    }
}


- (void)pickerViewFinished:(ActionSelectView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger firstRow = [pickerView.pickerView selectedRowInComponent:0];
    NSInteger secondRow = [pickerView.pickerView selectedRowInComponent:1];
    ChildInfo *child = [UserCenter sharedInstance].children[firstRow];
    NSDictionary *relation = _relationArray[secondRow];
    
    if([self checkRelation:[relation[@"id"] integerValue] childID:child.uid])
    {
        [self.targetItem setRelation:@{@"name":child.name, @"child_id":child.uid,@"relationName":relation[@"name"],@"relationID":relation[@"id"]}];
        [self.targetItem setValue:[NSString stringWithFormat:@"%@的%@",child.name,relation[@"name"]]];
        [self.tableView reloadData];
    }
}

- (BOOL)checkRelation:(NSInteger)relationID childID:(NSString *)childID
{
    BOOL canAdd = YES;
    NSString *errMsg = nil;
    for (PersonalInfoItem *item in _infoArray) {
        if(item.relation && item != self.targetItem)
        {
            NSString *child_id = item.relation[@"child_id"];
            if([child_id isEqualToString:childID])
            {
                errMsg = @"添加的成员不能和同一个孩子有多个关系";
                canAdd = NO;
                break;
            }
        }
    }
    //暂时去掉性别判断
//    if(canAdd)
//    {
//        if(relationID != 6)
//        {
//            for (PersonalInfoItem *item in _infoArray) {
//                if(item.relation && item != self.targetItem)
//                {
//                    NSInteger relation = [item.relation[@"relationID"] integerValue];
//                    if(relation == 6)
//                        continue;
//                    else if ((relationID + relation) % 2 == 1)
//                    {
//                        errMsg = @"根据您选择的家长身份，我们猜不出您的性别哦";
//                        canAdd = NO;
//                        break;
//                    }
//                }
//            }
//        }
//    }
    
    if(errMsg)
    {
        TNButtonItem *confirmItem = [TNButtonItem itemWithTitle:@"返回修改" action:nil];
        TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:errMsg buttonItems:@[confirmItem]];
        [alertView show];
    }
    
    return canAdd;
}

@end
