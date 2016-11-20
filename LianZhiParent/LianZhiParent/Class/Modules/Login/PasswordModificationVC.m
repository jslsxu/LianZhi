//
//  PasswordModificationVC.m
//  LianZhiParent
//  登陆成功，修改密码界面
//  Created by jslsxu on 14/12/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PasswordModificationVC.h"
NSString *const kPaswordModificationNotification = @"PaswordModificationNotification";
@interface PasswordModificationVC ()
@property (nonatomic, strong)UITextField*   passwordField;
@property (nonatomic, strong)UITextField*   confirmField;
@property (nonatomic, strong)UIButton*      confirmButton;
@end

@implementation PasswordModificationVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancel) name:kPaswordModificationNotification object:nil];
        self.hideNavigationBar = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITouchScrollView*  scrollView = [[UITouchScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setAlwaysBounceVertical:YES];
    [self.view addSubview:scrollView];
    
    [self setupScrollView:scrollView];
    
    UIView* navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    [navView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.8]];
    [self.view addSubview:navView];
    
    if(!self.hideCancel){
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitleColor:kCommonParentTintColor forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [cancelButton setTitle:@"返回" forState:UIControlStateNormal];
        [cancelButton sizeToFit];
        [cancelButton setOrigin:CGPointMake(10, 20 + (44 - cancelButton.height) / 2)];
        [navView addSubview:cancelButton];
    }
}

- (void)onCancel{
    if(self.callback){
        self.callback();
    }
    else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setupScrollView:(UIView *)viewParent{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setText:@"请输入新的密码"];
    [titleLabel setFont:[UIFont systemFontOfSize:30]];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
    [titleLabel sizeToFit];
    [titleLabel setOrigin:CGPointMake((viewParent.width - titleLabel.width) / 2, 90)];
    [viewParent addSubview:titleLabel];
    
    [viewParent addSubview:[self passwordField]];
    [self.passwordField setFrame:CGRectMake(10, titleLabel.bottom + 90, viewParent.width - 10 * 2, 44)];
    
    UIView *passwordSep = [[UIView alloc] initWithFrame:CGRectMake(10, self.passwordField.bottom, viewParent.width - 10 * 2, kLineHeight)];
    [passwordSep setBackgroundColor:kSepLineColor];
    [viewParent addSubview:passwordSep];
    
    [viewParent addSubview:[self confirmField]];
    [self.confirmField setFrame:CGRectMake(10, passwordSep.bottom, viewParent.width - 10 * 2, 44)];
    
    UIView *confirmSep = [[UIView alloc] initWithFrame:CGRectMake(10, self.confirmField.bottom, viewParent.width - 10 * 2, kLineHeight)];
    [confirmSep setBackgroundColor:kSepLineColor];
    [viewParent addSubview:confirmSep];
    
    [viewParent addSubview:[self confirmButton]];
    [self.confirmButton setFrame:CGRectMake(10, confirmSep.bottom + 20, viewParent.width - 10 * 2, 45)];
    [self.confirmButton setEnabled:YES];
}

- (UITextField *)passwordField{
    if(!_passwordField){
        _passwordField = [[UITextField alloc] initWithFrame:CGRectZero];
        [_passwordField setFont:[UIFont systemFontOfSize:16]];
        [_passwordField setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_passwordField setPlaceholder:@"新密码"];
        [_passwordField setSecureTextEntry:YES];
    }
    return _passwordField;
}

- (UITextField *)confirmField{
    if(!_confirmField){
        _confirmField = [[UITextField alloc] initWithFrame:CGRectZero];
        [_confirmField setFont:[UIFont systemFontOfSize:16]];
        [_confirmField setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_confirmField setPlaceholder:@"确认密码"];
        [_confirmField setSecureTextEntry:YES];
    }
    return _confirmField;
}

- (UIButton *)confirmButton{
    if(!_confirmButton){
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setBackgroundImage:[[UIImage imageWithColor:kCommonParentTintColor size:CGSizeMake(40, 40) cornerRadius:5] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_confirmButton setTitle:@"完成" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(onConfirmClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (void)onConfirmClicked
{
    [self.view endEditing:YES];
    NSString *first = [[self passwordField] text];
    NSString *second = [[self confirmField] text];
    if(![first isEqualToString:second])
    {
        [ProgressHUD showHintText:@"两次密码输入不一致"];
        return;
    }
    else if(first.length < 6 || first.length > 15)
    {
        [ProgressHUD showHintText:@"密码位数在6-15位"];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在设置密码" toView:self.view];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"setting/set_password" method:REQUEST_POST type:REQUEST_REFRESH withParams:@{@"password":first} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        NSString *token =[responseObject getStringForKey:@"verify"];
        [[UserCenter sharedInstance].userData setAccessToken:token];
        [[UserCenter sharedInstance] save];
        [hud hide:NO];
        [ProgressHUD showSuccess:@"密码设置成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kPaswordModificationNotification object:nil];
        });
    } fail:^(NSString *errMsg) {
        [hud hide:NO];
        [ProgressHUD showHintText:errMsg];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
