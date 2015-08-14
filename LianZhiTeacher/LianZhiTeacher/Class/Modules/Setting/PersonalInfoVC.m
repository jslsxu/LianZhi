//
//  PersonalInfoVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/3.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "PersonalInfoVC.h"
#import "ReportProblemVC.h"

@implementation PersonalInfoItem
- (instancetype)initWithKey:(NSString *)key value:(NSString *)value canEdit:(BOOL)canEdit
{
    self = [super init];
    if(self)
    {
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
        _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 65, 16)];
        [_hintLabel setBackgroundColor:[UIColor clearColor]];
        [_hintLabel setFont:[UIFont systemFontOfSize:15]];
        [_hintLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [self addSubview:_hintLabel];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 20 - (24 - 16) / 2, 210, 24)];
        [_textField setFont:[UIFont systemFontOfSize:14]];
        [_textField setDelegate:self];
        [_textField setTextColor:[UIColor colorWithHexString:@"666666"]];
        [_textField setBackgroundColor:[UIColor clearColor]];
        [_textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_textField];
        
        _qrImageIcon = [[UIImageView alloc] initWithFrame:CGRectMake(90, 20, 16, 16)];
        [self addSubview:_qrImageIcon];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(12, 44, self.width - 12 * 2, 1)];
        [_sepLine setBackgroundColor:[UIColor colorWithHexString:@"d8d8d8"]];
        [self addSubview:_sepLine];
    }
    return self;
}

- (void)setInfoItem:(PersonalInfoItem *)infoItem
{
    _infoItem = infoItem;
    [_hintLabel setText:_infoItem.key];
    [_textField setText:_infoItem.value];
    [_textField setEnabled:_infoItem.changeDirectly];
    [_qrImageIcon setImage:infoItem.image];
}

- (void)textFieldEditingChanged:(UITextField *)textField
{
    _infoItem.value = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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

@end

@interface PersonalInfoVC ()<UIViewControllerTransitioningDelegate>
@property (nonatomic, strong)UIImage *avatarImage;
@end

@implementation PersonalInfoVC
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人账号";
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 110)];
    [self setupHeaderView:_headerView];
    [self.tableView setTableHeaderView:_headerView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 80)];
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setFrame:CGRectMake(12, (footerView.height - 45) / 2, footerView.width - 12 * 2, 45)];
    [saveButton addTarget:self action:@selector(onSaveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setBackgroundImage:[[UIImage imageNamed:(@"BlueBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [saveButton setTitle:@"保存个人信息修改" forState:UIControlStateNormal];
    [footerView addSubview:saveButton];
    [self.tableView setTableFooterView:footerView];
    
    [self setupInfoArray];
    [self.tableView reloadData];
}

- (void)setupHeaderView:(UIView *)viewParent
{
    
    _idLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_idLabel setTextColor:kCommonTeacherTintColor];
    [_idLabel setFont:[UIFont systemFontOfSize:14]];
    [_idLabel setText:[NSString stringWithFormat:@"连枝号:%@",[UserCenter sharedInstance].userInfo.uid]];
    [_idLabel sizeToFit];
    [_idLabel setOrigin:CGPointMake(viewParent.width - _idLabel.width - 10, 5)];
    [viewParent addSubview:_idLabel];
    CGFloat spaceYStart = 20;
    _avatar = [[AvatarView alloc] initWithFrame:CGRectMake(24, 15 + spaceYStart, 60, 60)];
    [_avatar setImageWithUrl:[NSURL URLWithString:[UserCenter sharedInstance].userInfo.avatar]];
    [_avatar setBorderWidth:2];
    [_avatar setBorderColor:[UIColor colorWithWhite:0 alpha:0.2]];
    [viewParent addSubview:_avatar];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAvatarTap)];
    [_avatar addGestureRecognizer:tapGesture];
    
    _modifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_modifyButton setFrame:CGRectMake(24, _avatar.bottom + 2, _avatar.width, 30)];
    [_modifyButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_modifyButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateNormal];
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
            [textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
            [textField setDelegate:self];
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
    PersonalInfoItem *nameItem = [[PersonalInfoItem alloc] initWithKey:@"姓名:" value:[UserCenter sharedInstance].userInfo.name canEdit:YES];
    [nameItem setRequestKey:@"name"];
    PersonalInfoItem *genderItem = [[PersonalInfoItem alloc] initWithKey:@"性别:" value:kStringFromValue([UserCenter sharedInstance].userInfo.gender) canEdit:YES];
    [genderItem setRequestKey:@"sex"];
    PersonalInfoItem *birthDayItem = [[PersonalInfoItem alloc] initWithKey:@"出生日期:" value:[UserCenter sharedInstance].userInfo.birthDay canEdit:NO];
    [birthDayItem setRequestKey:@"birthday"];
    PersonalInfoItem *emailItem = [[PersonalInfoItem alloc] initWithKey:@"联系邮箱:" value:[UserCenter sharedInstance].userInfo.email canEdit:YES];
    [emailItem setRequestKey:@"email"];
    PersonalInfoItem *phoneItem = [[PersonalInfoItem alloc] initWithKey:@"登陆手机:" value:[UserCenter sharedInstance].userInfo.mobile canEdit:NO];
    PersonalInfoItem *passwordItem = [[PersonalInfoItem alloc] initWithKey:@"登录密码:" value:@"******" canEdit:NO];
    
    PersonalInfoItem *qrCodeItem = [[PersonalInfoItem alloc] initWithKey:@"二维码:" value:nil canEdit:NO];
    [qrCodeItem setImage:[UIImage imageNamed:(@"setting_myQR.png")]];
    
    [_infoArray addObjectsFromArray:@[nameItem,genderItem,birthDayItem,emailItem,phoneItem,passwordItem,qrCodeItem]];
    
    [_nameField setText:nameItem.value];
    [_genderLabel setText:genderItem.value.integerValue == GenderFemale ? @"美女" :@"帅哥"];
}

- (void)textFieldEditingChanged:(UITextField *)textField
{
    PersonalInfoItem *nameItem = [_infoArray objectAtIndex:0];
    NSString *text = textField.text;
    if(text.length > 8 && textField.markedTextRange == nil)
    {
        text = [text substringToIndex:8];
        [textField setText:text];
    }
    nameItem.value = text;
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
    for (NSInteger i = 0; i< _infoArray.count - 2; i++) {
        PersonalInfoItem *item = [_infoArray objectAtIndex:i];
        if(i == 3 && [item.value length] > 0)//邮箱
            if(![item.value isEmailAddress])
            {
                [ProgressHUD showHintText:@"邮箱格式不正确"];
                return;
            }
        [params setValue:item.value forKey:item.requestKey];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在修改个人信息" toView:self.view];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"setting/set_user_info" withParams:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(self.avatarImage)
            [formData appendPartWithFileData:UIImageJPEGRepresentation(self.avatarImage, 0.8) name:@"head" fileName:@"head" mimeType:@"image/JPEG"];
    } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        TNDataWrapper *userWrapper = [responseObject getDataWrapperForKey:@"user"];
        [[UserCenter sharedInstance] updateUserInfoWithData:userWrapper];
        NSString *avatar = [userWrapper getStringForKey:@"head"];
        if(self.avatarImage && avatar)
        {
            [[SDWebImageManager sharedManager] saveImageToCache:self.avatarImage forURL:[NSURL URLWithString:avatar]];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChangedNotification object:nil];
        [hud hide:NO];
        [MBProgressHUD showSuccess:@"修改成功" toView:self.view];
    } fail:^(NSString *errMsg) {
        [hud hide:NO];
        [ProgressHUD showError:errMsg];
    }];
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
    [self.view endEditing:YES];
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
    else if(indexPath.row == 3)
    {
        PasswordModifyVC *passwordModifyVC = [[PasswordModifyVC alloc] init];
        [self.navigationController pushViewController:passwordModifyVC animated:YES];
    }
    else if (indexPath.row == 2)
    {
        TNButtonItem *mofifyItem = [TNButtonItem itemWithTitle:@"前往客服中心上报" action:^{
            ReportProblemVC *reportVC = [[ReportProblemVC alloc] init];
            [reportVC setType:1];
            [self.navigationController pushViewController:reportVC animated:YES];
        }];
        TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消本次操作" action:^{
            
        }];
        TNActionSheet *actionSheet = [[TNActionSheet alloc] initWithTitle:@"修改登录手机可能造成数据丢失，请联系客服进行号码修改" descriptionView:nil destructiveButton:cancelItem cancelItem:nil otherItems:@[mofifyItem]];
        [actionSheet show];
    }
    else if (indexPath.row == 4)
    {
        QrCodeView *qrCodeView = [[QrCodeView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        [qrCodeView showInView:[UIApplication sharedApplication].keyWindow];
    }
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
    [self.view endEditing:YES];
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

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
