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
        self.width = kScreenWidth;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.textLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [self.textLabel setFont:[UIFont systemFontOfSize:14]];
        [self.detailTextLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [self.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 50 - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
    }
    return self;
}

- (void)setInfoItem:(PersonalInfoItem *)infoItem
{
    _infoItem = infoItem;
    [self.textLabel setText:[NSString stringWithFormat:@"%@:",infoItem.key]];
    [self.detailTextLabel setText:infoItem.value];
}

@end

@interface PersonalInfoVC ()<UIViewControllerTransitioningDelegate>
@property (nonatomic, strong)UIImage *avatarImage;
@end

@implementation PersonalInfoVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init{
    self = [super init];
    if(self){
        self.hidesBottomBarWhenPushed = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadWhenUserChanged) name:kUserInfoChangedNotification object:nil];
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
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 114)];
    [self setupHeaderView:_headerView];
    [self.tableView setTableHeaderView:_headerView];

    [self setupInfoArray];
    [self.tableView reloadData];
}

- (void)reloadWhenUserChanged{
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
    [idLabel setBackgroundColor:[UIColor colorWithHexString:@"0eadc0"]];
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
    [avatarLabel setTextColor:kCommonTeacherTintColor];
    [avatarLabel setFont:[UIFont systemFontOfSize:14]];
    [avatarLabel setText:@"头像"];
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
    
    PersonalInfoItem *nickItem = [[PersonalInfoItem alloc] initWithKey:@"昵称" value:[UserCenter sharedInstance].userInfo.nick canEdit:YES];
    [nickItem setRequestKey:@"nick"];
    PersonalInfoItem *birthDayItem = [[PersonalInfoItem alloc] initWithKey:@"出生日期" value:[UserCenter sharedInstance].userInfo.birthday canEdit:NO];
    [birthDayItem setRequestKey:@"birthday"];
    PersonalInfoItem *emailItem = [[PersonalInfoItem alloc] initWithKey:@"联系邮箱" value:[UserCenter sharedInstance].userInfo.email canEdit:YES];
    [emailItem setRequestKey:@"email"];
    PersonalInfoItem *phoneItem = [[PersonalInfoItem alloc] initWithKey:@"登录手机" value:[UserCenter sharedInstance].userInfo.mobile canEdit:NO];
    PersonalInfoItem *passwordItem = [[PersonalInfoItem alloc] initWithKey:@"登录密码" value:@"******" canEdit:NO];
    
    [_infoArray addObjectsFromArray:@[nameItem,nickItem,birthDayItem,emailItem,phoneItem,passwordItem]];
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
    return  _infoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"PersonalInfoCell";
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
    if(indexPath.row == 2)//出生日期
    {
        SettingDatePickerView *datePicker = [[SettingDatePickerView alloc] initWithType:SettingDatePickerTypeDate];
        [datePicker setBlk:^(NSString *dateStr){
            PersonalInfoItem *birthdayItem = [_infoArray objectAtIndex:indexPath.row];
            [birthdayItem setValue:dateStr];
            [self onSaveButtonClicked];
            [tableView reloadData];
        }];
        [datePicker show];
        
    }
    else if(indexPath.row == 5)
    {
        PasswordModifyVC *passwordModifyVC = [[PasswordModifyVC alloc] init];
        [self.navigationController pushViewController:passwordModifyVC animated:YES];
    }
    else if (indexPath.row == 4)
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
    else
    {
        PersonalInfoCell *cell = (PersonalInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
        PersonalInfoItem *infoItem = cell.infoItem;
        CommonInputVC *commonInputVC = [[CommonInputVC alloc] initWithOriginal:infoItem.value forKey:infoItem.key completion:^(NSString *value) {
            [infoItem setValue:value];
            [self onSaveButtonClicked];
            [self.tableView reloadData];
        }];
        [self.navigationController pushViewController:commonInputVC animated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
