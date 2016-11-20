//
//  AuthCodeInputVC.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/9/23.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "AuthCodeInputVC.h"

#define kRemainedSeconds                60
@interface AuthCodeInputVC ()
@property (nonatomic, strong)UITextField*   textField;
@property (nonatomic, strong)UILabel*       statusLabel;
@property (nonatomic, strong)NSTimer*       timer;
@property (nonatomic, assign)NSInteger      defaulRemain;
@end

@implementation AuthCodeInputVC

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


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
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
    
    [self startTimer];
}

- (void)onCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupScrollView:(UIView *)viewParent{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setText:@"请输入验证码"];
    [titleLabel setFont:[UIFont systemFontOfSize:30]];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
    [titleLabel sizeToFit];
    [titleLabel setOrigin:CGPointMake((viewParent.width - titleLabel.width) / 2, 90)];
    [viewParent addSubview:titleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, titleLabel.bottom + 15, viewParent.width - 20 * 2, 0)];
    [subTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [subTitleLabel setNumberOfLines:0];
    [subTitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [subTitleLabel setFont:[UIFont systemFontOfSize:14]];
    [subTitleLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
    [subTitleLabel setText:[NSString stringWithFormat:@"短信验证码已发送至 +86 %@",self.phoneNum]];
    [subTitleLabel sizeToFit];
    [viewParent addSubview:subTitleLabel];
    
    [viewParent addSubview:[self textField]];
    [self.textField setFrame:CGRectMake(10, subTitleLabel.bottom + 60, viewParent.width - 10 * 2, 45)];
    
    UIView *phoneSepLine = [[UIView alloc] initWithFrame:CGRectMake(10, self.textField.bottom, viewParent.width - 10 * 2, kLineHeight)];
    [phoneSepLine setBackgroundColor:kSepLineColor];
    [viewParent addSubview:phoneSepLine];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton addTarget:self action:@selector(checkAuthCode) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setFrame:CGRectMake(10, phoneSepLine.bottom + 20, viewParent.width - 10 * 2, 44)];
    [nextButton setBackgroundImage:[UIImage imageWithColor:kCommonParentTintColor size:nextButton.size cornerRadius:5] forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [viewParent addSubview:nextButton];
    
    [viewParent addSubview:[self statusLabel]];
    [self.statusLabel setFrame:CGRectMake(10, nextButton.bottom + 10, viewParent.width - 10 * 2, 30)];
}

- (UITextField *)textField{
    if(!_textField){
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        [_textField setFont:[UIFont systemFontOfSize:16]];
        [_textField setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_textField setPlaceholder:@"验证码"];
        [_textField setKeyboardType:UIKeyboardTypeNumberPad];
    }
    return _textField;
}

- (UILabel *)statusLabel{
    if(!_statusLabel){
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_statusLabel setTextAlignment:NSTextAlignmentCenter];
        [_statusLabel setFont:[UIFont systemFontOfSize:14]];
        [_statusLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        
        __weak typeof(self) wself = self;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [wself requestAuthCode];
        }];
        [_statusLabel addGestureRecognizer:tapGesture];
    }
    return _statusLabel;
}

- (void)requestAuthCode
{
    [self.view endEditing:YES];
    __weak typeof(self) wself = self;
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:self.view];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"user/get_sms_code" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"mobile":self.phoneNum} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper* responseObject) {
        [hud hide:YES];
        [ProgressHUD showHintText:@"验证码已发送"];
        [wself startTimer];
    } fail:^(NSString *errMsg) {
        [hud hide:YES];
        [ProgressHUD showHintText:errMsg];
    }];
}


- (void)checkAuthCode{
    [self.view endEditing:YES];
    NSString *authCode = [[self textField] text];
    NSString *msg = nil;
    if(authCode.length == 0)
        msg = @"请输入验证码";
    if(msg)
    {
        [ProgressHUD showHintText:msg];
        return;
    }
    __weak typeof(self) wself = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.phoneNum forKey:@"mobile"];
    [params setValue:authCode forKey:@"code"];
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:[UIApplication sharedApplication].keyWindow];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"user/login_mobile" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [hud hide:NO];
        [[UserCenter sharedInstance] parseData:responseObject];
        PasswordModificationVC *passwordConfirmVC = [[PasswordModificationVC alloc] init];
        [passwordConfirmVC setCallback:^{
            [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
        }];
        [wself presentViewController:passwordConfirmVC animated:YES completion:nil];
    } fail:^(NSString *errMsg) {
        [hud hide:NO];
        [ProgressHUD showHintText:errMsg];
    }];

}

- (void)startTimer{
    if(self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
    __weak typeof(self) wself = self;
    self.defaulRemain = kRemainedSeconds;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        [wself onTimer];
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

- (void)onTimer
{
    @synchronized (self)
    {
        if(self.defaulRemain == 0)
        {
            [self.statusLabel setText:@"再次发送验证码"];
            [self.statusLabel setUserInteractionEnabled:YES];
        }
        else
        {
            self.defaulRemain --;
            [self.statusLabel setText:[NSString stringWithFormat:@"接收短信大约需要%zd秒",self.defaulRemain]];
            [self.statusLabel setUserInteractionEnabled:NO];
        }
    }
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
