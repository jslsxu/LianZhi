//
//  PersonalInfoVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/3.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "PersonalInfoVC.h"
#import "ReportProblemVC.h"
#import "CommonInputVC.h"
NSString *const kAddRelationNotification = @"AddRelationNotification";

@implementation PersonalInfoItem
- (instancetype)initWithKey:(NSString *)key value:(NSString *)value canEdit:(BOOL)canEdit
{
    self = [super init];
    if(self)
    {
        self.keyboardType = UIKeyboardAppearanceDefault;
        self.key = key;
        self.value = value;
        self.changeDirectly = canEdit;
    }
    return self;
}
@end

@implementation PersonalInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.textLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [self.textLabel setFont:[UIFont systemFontOfSize:14]];
        [self.detailTextLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [self.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:[UIImage imageNamed:(@"Add.png")] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(onAddButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_addButton setFrame:CGRectMake(self.width - 30, (self.height - 40) / 2, 30, 40)];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 50 - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
    }
    return self;
}

- (void)setShowAdd:(BOOL)showAdd
{
    _showAdd = showAdd;
    [self setAccessoryView:_showAdd ? _addButton : nil];
}

- (void)onAddButtonClicked
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddRelationNotification object:nil userInfo:nil];
}

- (void)setInfoItem:(PersonalInfoItem *)infoItem
{
    _infoItem = infoItem;
    [self.textLabel setText:[NSString stringWithFormat:@"%@:",infoItem.key]];
    [self.detailTextLabel setText:infoItem.value];
}

@end

@interface PersonalInfoVC ()
@property (nonatomic, strong)UIImage *avatarImage;
@property (nonatomic, strong)PersonalInfoItem *targetItem;
@end

@implementation PersonalInfoVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init{
    self = [super init];
    if(self){
         self.hidesBottomBarWhenPushed = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataWhenUserChanged) name:kUserInfoChangedNotification object:nil];
    }
    return self;
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
    
    UINavigationController *nav = self.navigationController;
    if(nav.viewControllers.count > 1){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavBack"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    }
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人账号";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    [backItem setTitle:@"返回"];
    self.navigationItem.backBarButtonItem = backItem;
    _relationArray = @[@{@"name":@"爸爸",@"id":@"0"},@{@"name":@"妈妈",@"id":@"1"},@{@"name":@"爷爷",@"id":@"2"},@{@"name":@"奶奶",@"id":@"3"},@{@"name":@"外公",@"id":@"4"},@{@"name":@"外婆",@"id":@"5"},@{@"name":@"其他监护人",@"id":@"6"}];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 110)];
    [self setupHeaderView:_headerView];
    [self.tableView setTableHeaderView:_headerView];
    
    [self setupInfoArray];
    [self.tableView reloadData];
}

- (void)reloadDataWhenUserChanged{
    [self.tableView reloadData];
}

- (void)setupHeaderView:(UIView *)viewParent
{

    [viewParent.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [coverButton setFrame:viewParent.bounds];
    [coverButton addTarget:self action:@selector(onAvatarModification) forControlEvents:UIControlEventTouchUpInside];
    [viewParent addSubview:coverButton];
    
    UILabel* idLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewParent.width, 30)];
    [idLabel setBackgroundColor:[UIColor colorWithHexString:@"04aa73"]];
    [idLabel setTextColor:[UIColor whiteColor]];
    [idLabel setTextAlignment:NSTextAlignmentCenter];
    [idLabel setFont:[UIFont systemFontOfSize:12]];
    [idLabel setText:[NSString stringWithFormat:@"连枝号:%@",[UserCenter sharedInstance].userInfo.uid]];
    [viewParent addSubview:idLabel];
    
    _avatar = [[AvatarView alloc] initWithFrame:CGRectMake(12, 40, 60, 60)];
    [_avatar sd_setImageWithURL:[NSURL URLWithString:[UserCenter sharedInstance].userInfo.avatar]];
    [viewParent addSubview:_avatar];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAvatarTap)];
    [_avatar addGestureRecognizer:tapGesture];
    
    UILabel *avatarLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [avatarLabel setTextColor:kCommonParentTintColor];
    [avatarLabel setFont:[UIFont systemFontOfSize:14]];
    [avatarLabel setText:@"编辑"];
    [avatarLabel sizeToFit];
    [avatarLabel setOrigin:CGPointMake(viewParent.width - 12 - avatarLabel.width, 30 + (88 - avatarLabel.height) / 2)];
    [viewParent addSubview:avatarLabel];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, viewParent.height - kLineHeight, viewParent.width, kLineHeight)];
    [bottomLine setBackgroundColor:kSepLineColor];
    [viewParent addSubview:bottomLine];
}

//放大头像
#pragma mark - UIViewControllerTransitioningDelegate methods

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if ([presented isKindOfClass:TGRImageViewController.class]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImage:_avatar.image fromRect:[self.navigationController.view convertRect:_avatar.bounds fromView:_avatar]];
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if ([dismissed isKindOfClass:TGRImageViewController.class]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImage:_avatar.image fromRect:[self.navigationController.view convertRect:_avatar.bounds fromView:_avatar]];
    }
    return nil;
}
- (void)onAvatarTap
{
    if(_avatar.image)
    {
        TGRImageViewController *viewController = [[TGRImageViewController alloc] initWithImage:_avatar.image];
        viewController.transitioningDelegate = self;
        [self presentViewController:viewController animated:YES completion:nil];
    }
}


- (void)setupInfoArray
{
    if(_infoArray)
        [_infoArray removeAllObjects];
    else
        _infoArray = [[NSMutableArray alloc] init];
    PersonalInfoItem *nameItem = [[PersonalInfoItem alloc] initWithKey:@"姓名" value:[UserCenter sharedInstance].userInfo.name canEdit:YES];
    [nameItem setRequestKey:@"name"];
    PersonalInfoItem *nickNameItem = [[PersonalInfoItem alloc] initWithKey:@"昵称" value:[UserCenter sharedInstance].userInfo.nick canEdit:YES];
    [nickNameItem setRequestKey:@"nick"];
    PersonalInfoItem *birthDayItem = [[PersonalInfoItem alloc] initWithKey:@"出生日期" value:[UserCenter sharedInstance].userInfo.birthday canEdit:NO];
    [birthDayItem setRequestKey:@"birthday"];
    PersonalInfoItem *emailItem = [[PersonalInfoItem alloc] initWithKey:@"联系邮箱" value:[UserCenter sharedInstance].userInfo.email canEdit:YES];
    [emailItem setRequestKey:@"email"];
    [emailItem setKeyboardType:UIKeyboardTypeEmailAddress];
    PersonalInfoItem *phoneItem = [[PersonalInfoItem alloc] initWithKey:@"登录手机" value:[UserCenter sharedInstance].userInfo.mobile canEdit:NO];
    PersonalInfoItem *passwordItem = [[PersonalInfoItem alloc] initWithKey:@"登录密码" value:@"******" canEdit:NO];
    [_infoArray addObjectsFromArray:@[nameItem,nickNameItem,birthDayItem,emailItem,phoneItem,passwordItem]];
    for (ChildInfo *child in [UserCenter sharedInstance].children) {
        NSArray *family = child.family;
        for (FamilyInfo *familyInfo in family) {
            if([familyInfo.uid isEqualToString:[UserCenter sharedInstance].userInfo.uid])
            {
                PersonalInfoItem *relationItem = [[PersonalInfoItem alloc] initWithKey:@"家长身份" value:nil canEdit:NO];
                NSString *curRelationID = nil;
                for (NSDictionary *relationDic in _relationArray) {
                    NSString *relationID = relationDic[@"id"];
                    NSString *relationName = relationDic[@"name"];
                    if([relationName isEqualToString:familyInfo.relation])
                        curRelationID = relationID;
                }
                
                NSDictionary *relation = @{@"name":child.name, @"child_id":child.uid,@"relationName":familyInfo.relation,@"relationID":curRelationID};
                [relationItem setRelation:relation];
                [relationItem setValue:[NSString stringWithFormat:@"%@的%@",child.name,familyInfo.relation]];
                [_infoArray addObject:relationItem];
            }
        }
    }
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


- (void)onSaveButtonClicked
{
    [self.view endEditing:YES];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSInteger i = 0; i< 4; i++) {
        PersonalInfoItem *item = [_infoArray objectAtIndex:i];
        if(i == 3 && [item.value length] > 0)//邮箱
        {
            if(![item.value isEmailAddress])
            {
                [ProgressHUD showHintText:@"邮箱格式不正确"];
                return;
            }
        }
        [params setValue:item.value forKey:item.requestKey];
    }
    NSMutableArray *relationArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 6; i< _infoArray.count; i++) {
        PersonalInfoItem *infoItem = [_infoArray objectAtIndex:i];
        if(infoItem.relation)
        {
            [relationArray addObject:@{@"child_id":infoItem.relation[@"child_id"],@"relation":infoItem.relation[@"relationID"]}];
        }
    }
    NSString *relations = [NSString stringWithJSONObject:relationArray];
    [params setValue:relations forKey:@"relations"];
     MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在修改个人信息" toView:self.view];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"setting/set_user_info" withParams:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(self.avatarImage)
            [formData appendPartWithFileData:UIImageJPEGRepresentation(self.avatarImage, 0.8) name:@"head" fileName:@"head" mimeType:@"image/JPEG"];
    } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [[UserCenter sharedInstance] updateUserInfoWithData:[responseObject getDataWrapperForKey:@"user"]];
        for (NSInteger i = 5; i < _infoArray.count; i++) {
            PersonalInfoItem *infoItem = _infoArray[i];
            NSString *childID = infoItem.relation[@"child_id"];
            NSString *relationName = infoItem.relation[@"relationName"];
            
            NSArray *children = [UserCenter sharedInstance].children;
            for (ChildInfo *child in children) {
                if([child.uid isEqualToString:childID])
                {
                    NSArray *familyArray = child.family;
                    for (FamilyInfo *familyInfo in familyArray) {
                        if([familyInfo.uid isEqualToString:[UserCenter sharedInstance].userInfo.uid])
                        {
                            familyInfo.relation = relationName;
                            break;
                        }
                    }
                    break;
                }
            }
        }
        [[UserCenter sharedInstance] save];
        [self.tableView reloadData];
        [hud hide:NO];
        [MBProgressHUD showSuccess:@"修改成功" toView:self.view];
    } fail:^(NSString *errMsg) {
        [hud hide:NO];
        [ProgressHUD showError:errMsg];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _infoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseID = [NSString stringWithFormat:@"PersonalInfoCell%ld",(long)indexPath.row];
    PersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[PersonalInfoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
    }
    [cell setInfoItem:[_infoArray objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    NSInteger row = indexPath.row;
    if(row == 2)//生日
    {
        SettingDatePickerView *datePicker = [[SettingDatePickerView alloc] initWithType:SettingDatePickerTypeDate];
        [datePicker setBlk:^(NSString *dateStr){
            PersonalInfoItem *birthdayItem = [_infoArray objectAtIndex:2];
            [birthdayItem setValue:dateStr];
            [self onSaveButtonClicked];
            [self.tableView reloadData];
        }];
        [datePicker show];
    }
    else if(row == 4)
    {
        TNButtonItem *mofifyItem = [TNButtonItem itemWithTitle:@"前往客服中心上报" action:^{
            
            ReportProblemVC *reportVC = [[ReportProblemVC alloc] init];
            [reportVC setType:4];
            [self.navigationController pushViewController:reportVC animated:YES];
        }];
        TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消本次操作" action:^{
            
        }];
        TNActionSheet *actionSheet = [[TNActionSheet alloc] initWithTitle:@"修改登录手机可能造成数据丢失，请联系客服进行号码修改" descriptionView:nil destructiveButton:cancelItem cancelItem:nil otherItems:@[mofifyItem]];
        [actionSheet show];
    }
    else if(row == 5)//密码
    {
        PasswordModifyVC *passwordModifyVC = [[PasswordModifyVC alloc] init];
        [self.navigationController pushViewController:passwordModifyVC animated:YES];
    }
    else if(row > 5)
    {
        self.targetItem = [_infoArray objectAtIndex:row];
        ActionSelectView *selectView = [[ActionSelectView alloc] init];
        [selectView setDelegate:self];
        [selectView show];
    }
    else
    {
        PersonalInfoItem *infoItem = _infoArray[row];
        CommonInputVC *commonInputVC = [[CommonInputVC alloc] initWithOriginal:infoItem.value forKey:infoItem.key completion:^(NSString *value) {
            BOOL validate = YES;
            if(row == 3)
            {
                validate = [value isEmailAddress];
                
            }
            if(validate)
            {
                infoItem.value = value;
                [self onSaveButtonClicked];
                [self.tableView reloadData];
            }
            else
                [ProgressHUD showHintText:@"邮箱格式不正确"];
        }];
        [CurrentROOTNavigationVC pushViewController:commonInputVC animated:YES];
    }

}

#pragma mark - UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.avatarImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [_avatar setImage:self.avatarImage];
        [self onSaveButtonClicked];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ActionSelectView
- (NSInteger)pickerView:(ActionSelectView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _relationArray.count;
}

- (NSString *)pickerView:(ActionSelectView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *relationDic = [_relationArray objectAtIndex:row];
    return relationDic[@"name"];
}


- (void)pickerViewFinished:(ActionSelectView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary *relation = _relationArray[row];
//    NSString *originalID = self.targetItem.relation[@"relationID"];
//    NSString *curID = relation[@"id"];
//    if([originalID integerValue] == 6 || [curID integerValue] == 6 || (originalID.integerValue + curID.integerValue) % 2 == 0)
//    {
        NSDictionary *originalRelation = self.targetItem.relation;
        NSMutableDictionary *curRelation = [NSMutableDictionary dictionaryWithDictionary:originalRelation];
        [curRelation setObject:relation[@"name"] forKey:@"relationName"];
        [curRelation setObject:relation[@"id"] forKey:@"relationID"];
        [self.targetItem setRelation:curRelation];
        [self.targetItem setValue:[NSString stringWithFormat:@"%@的%@",curRelation[@"name"],curRelation[@"relationName"]]];
        NSInteger index = [_infoArray indexOfObject:self.targetItem];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index - 2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//    }
//    else
//    {
//        [ProgressHUD showHintText:@"您不能选择和之前不同的性别"];
//    }
    [self onSaveButtonClicked];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
