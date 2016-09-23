//
//  PhoneInputVC.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/9/23.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "PhoneInputVC.h"
#import "AuthCodeInputVC.h"

@interface PhoneInputVC ()
@property (nonatomic, strong)UITextField*   textField;
@end

@implementation PhoneInputVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCancel) name:kPaswordModificationNotification object:nil];
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
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:kCommonParentTintColor forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [cancelButton setTitle:@"返回" forState:UIControlStateNormal];
    [cancelButton sizeToFit];
    [cancelButton setOrigin:CGPointMake(10, 20 + (44 - cancelButton.height) / 2)];
    [navView addSubview:cancelButton];
    
}

- (void)onCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupScrollView:(UIView *)viewParent{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setText:@"请输入手机号"];
    [titleLabel setFont:[UIFont systemFontOfSize:30]];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
    [titleLabel sizeToFit];
    [titleLabel setOrigin:CGPointMake((viewParent.width - titleLabel.width) / 2, 90)];
    [viewParent addSubview:titleLabel];
    
    
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [stateLabel setFont:[UIFont systemFontOfSize:16]];
    [stateLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
    [stateLabel setText:@"中国  +86"];
    [stateLabel sizeToFit];
    [stateLabel setOrigin:CGPointMake(10, titleLabel.bottom + 40)];
    [viewParent addSubview:stateLabel];
    
    UIView *stateSepLine = [[UIView alloc] initWithFrame:CGRectMake(10, stateLabel.bottom + 10, viewParent.width - 10 * 2, kLineHeight)];
    [stateSepLine setBackgroundColor:kSepLineColor];
    [viewParent addSubview:stateSepLine];
    
    [viewParent addSubview:[self textField]];
    [self.textField setFrame:CGRectMake(10, stateSepLine.bottom, viewParent.width - 10 * 2, 45)];
    
    UIView *phoneSepLine = [[UIView alloc] initWithFrame:CGRectMake(10, self.textField.bottom, viewParent.width - 10 * 2, kLineHeight)];
    [phoneSepLine setBackgroundColor:kSepLineColor];
    [viewParent addSubview:phoneSepLine];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton addTarget:self action:@selector(requestAuthCode) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setFrame:CGRectMake(10, phoneSepLine.bottom + 20, viewParent.width - 10 * 2, 44)];
    [nextButton setBackgroundImage:[UIImage imageWithColor:kCommonParentTintColor size:nextButton.size cornerRadius:5] forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [viewParent addSubview:nextButton];
}

- (UITextField *)textField{
    if(!_textField){
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        [_textField setFont:[UIFont systemFontOfSize:16]];
        [_textField setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_textField setPlaceholder:@"手机号"];
        [_textField setKeyboardType:UIKeyboardTypeNumberPad];
    }
    return _textField;
}

- (void)requestAuthCode
{
    [self.view endEditing:YES];
    NSString *mobile = self.textField.text;
    if([mobile isPhoneNumberValidate])
    {
        __weak typeof(self) wself = self;
        MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:self.view];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"user/get_sms_code" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"mobile":mobile} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper* responseObject) {
            [hud hide:YES];
            AuthCodeInputVC *authCodeInputVC = [[AuthCodeInputVC alloc] init];
            [authCodeInputVC setPhoneNum:mobile];
            [wself presentViewController:authCodeInputVC animated:YES completion:nil];
        } fail:^(NSString *errMsg) {
            [hud hide:YES];
            [ProgressHUD showHintText:errMsg];
        }];
    }
}


- (BOOL)checkPhoneNumber:(NSString *)phoneNumber
{
    NSString *mobile = @"^1\\d{10}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
    return  [regextestmobile evaluateWithObject:phoneNumber];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
