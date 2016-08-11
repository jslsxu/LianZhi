//
//  BaseInfoModifyVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/4/8.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "BaseInfoModifyVC.h"

@interface BaseInfoModifyVC ()
@property (nonatomic, assign)GenderType genderType;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, weak)ActionSelectView *genderSelectView;
@end

@implementation BaseInfoModifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人账号";
    self.genderType = [UserCenter sharedInstance].userInfo.sex;
    self.name = [UserCenter sharedInstance].userInfo.name;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]];
}

- (void)setupSubviews
{
    CGFloat spaceYStart = 30;
    for (NSInteger i = 0; i < 2; i++) {
        UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, spaceYStart, 50, 40)];
        [hintLabel setTextColor:[UIColor grayColor]];
        [hintLabel setFont:[UIFont systemFontOfSize:14]];
        [hintLabel setText:i == 0 ? @"姓名:" : @"性别:"];
        [self.view addSubview:hintLabel];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(10, hintLabel.bottom, self.view.width - 10 * 2, 0.5)];
        [sepLine setBackgroundColor:[UIColor colorWithHexString:@"D8D8D8"]];
        [self.view addSubview:sepLine];
        
        spaceYStart += 40;
    }
    
    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(65, 30, self.view.width - 10 - 65, 40)];
    [_nameField setDelegate:self];
    [_nameField setReturnKeyType:UIReturnKeyDone];
    [_nameField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [_nameField setFont:[UIFont systemFontOfSize:16]];
    [_nameField setText:self.name];
    [_nameField setTextColor:[UIColor grayColor]];
    [self.view addSubview:_nameField];
    
    _genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameField.left, _nameField.bottom, _nameField.width, _nameField.height)];
    [_genderLabel setUserInteractionEnabled:YES];
    [_genderLabel setTextColor:[UIColor grayColor]];
    [_genderLabel setFont:[UIFont systemFontOfSize:16]];
    [_genderLabel setText:self.genderType == GenderFemale ? @"美女" :@"帅哥"];
    [self.view addSubview:_genderLabel];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [_genderLabel addGestureRecognizer:tapGesture];
    
    UILabel*    hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, spaceYStart + 10, self.view.width - 10 * 2, 40)];
    [hintLabel setNumberOfLines:0];
    [hintLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [hintLabel setFont:[UIFont systemFontOfSize:14]];
    [hintLabel setTextColor:[UIColor colorWithHexString:@"cccccc"]];
    [hintLabel setText:@"温馨提示：个人性别是家长身份选择的唯一凭证，只能设置一次"];
    [self.view addSubview:hintLabel];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton addTarget:self action:@selector(onConfirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setFrame:CGRectMake(16, self.view.height - 40 - 30, self.view.width - 15 * 2, 40)];
    [confirmButton setBackgroundImage:[UIImage imageWithColor:kCommonParentTintColor size:confirmButton.size cornerRadius:5] forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [confirmButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.view addSubview:confirmButton];
}

- (void)onTap
{
    [self.view endEditing:YES];
    ActionSelectView *actionSelectView = [[ActionSelectView alloc] init];
    [actionSelectView setDelegate:self];
    [actionSelectView show];
    self.genderSelectView = actionSelectView;
}

- (void)onConfirmButtonClicked
{
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.name forKey:@"name"];
    [params setValue:kStringFromValue(self.genderType) forKey:@"sex"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"setting/set_user_info" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [[UserCenter sharedInstance] updateUserInfoWithData:[responseObject getDataWrapperForKey:@"user"]];
        [[UserCenter sharedInstance] save];
        [hud hide:NO];
        [ProgressHUD showSuccess:@"修改成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self back];
        });
    } fail:^(NSString *errMsg) {
        [hud hide:NO];
        TNButtonItem *item = [TNButtonItem itemWithTitle:@"重新修改" action:^{
            
        }];
        TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:errMsg buttonItems:@[item]];
        [alertView show];
    }];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldEditingChanged:(UITextField *)textField
{
    [self.genderSelectView dismiss];
    NSString *text = textField.text;
    if(text.length > 10 && textField.markedTextRange == nil)
    {
        text = [text substringWithRange:NSMakeRange(0, 10)];
        [textField setText:text];
    }
    self.name = text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - ActionSelectView
- (NSInteger)pickerView:(ActionSelectView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

- (NSString *)pickerView:(ActionSelectView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(row == 0)
        return @"帅哥";
    else
        return @"美女";
}
- (void)pickerViewFinished:(ActionSelectView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(row == 0)
    {
        self.genderType = GenderMale;
    }
    else
        self.genderType = GenderFemale;
    [_genderLabel setText:self.genderType == GenderFemale ? @"美女" :@"帅哥"];
}

@end
