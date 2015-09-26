//
//  RegisterVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "RegisterVC.h"
#import "RegisterAuthVC.h"
@interface RegisterVC ()
@property (nonatomic, strong)NSMutableArray *feildArray;
@end

@implementation RegisterVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.hideNavigationBar = NO;
        self.feildArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请账号";
    
    NSArray *imageArray = @[@"RegisterName",@"RegisterPhone",@"RegisterSchool",@"RegisterArea"];
    NSArray *placeholderArray = @[@"您的姓名",@"手机号",@"学校名称",@"所在区域"];
    NSInteger itemHeight = 40;
    NSInteger hMargin = 10;
    NSInteger spaceYStart = 15;
    for (NSInteger i = 0; i < 4; i++)
    {
        UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(hMargin, spaceYStart, self.view.width - hMargin * 2, itemHeight)];
        [borderView setBackgroundColor:[UIColor whiteColor]];
        [borderView.layer setCornerRadius:5];
        [borderView.layer setMasksToBounds:YES];
        [self.view addSubview:borderView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageArray[i]]];
        [imageView setOrigin:CGPointMake(8, (borderView.height - imageView.height) / 2)];
        [borderView addSubview:imageView];
        
        UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(imageView.right + 8, 0, borderView.width - 10 - (imageView.right + 8), borderView.height)];
        [textField setPlaceholder:placeholderArray[i]];
        [textField setFont:[UIFont systemFontOfSize:16]];
        [borderView addSubview:textField];
        
        [self.feildArray addObject:textField];
        spaceYStart += hMargin + itemHeight;
    }
    
    spaceYStart += hMargin;
    UIButton *authButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [authButton setFrame:CGRectMake(hMargin, spaceYStart, self.view.width - hMargin * 2, 40)];
    [authButton addTarget:self action:@selector(onAuthClicked) forControlEvents:UIControlEventTouchUpInside];
    [authButton setBackgroundImage:[UIImage imageWithColor:kCommonTeacherTintColor size:authButton.size cornerRadius:5] forState:UIControlStateNormal];
    [authButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [authButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [authButton setTitle:@"短信验证" forState:UIControlStateNormal];
    [self.view addSubview:authButton];
    
    UIButton *contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [contactButton addTarget:self action:@selector(contact) forControlEvents:UIControlEventTouchUpInside];
    [contactButton setFrame:CGRectMake(40, self.view.height - 20 - 30 - 64, self.view.width - 40 * 2, 30)];
    [contactButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [contactButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [contactButton setTitle:@"非天津的学校请直接致电：400-66-10016" forState:UIControlStateNormal];
    [self.view addSubview:contactButton];
}

- (void)onAuthClicked
{
    [self.view endEditing:YES];
    NSString *name = [self.feildArray[0] text];
    NSString *mobile = [self.feildArray[1] text];
    NSString *schoolName = [self.feildArray[2] text];
    NSString *area = [self.feildArray[3] text];
    NSString *errMsg = nil;
    if(name.length == 0)
        errMsg = @"请输入姓名";
    else if(mobile.length == 0)
        errMsg = @"请输入手机号";
    else if(schoolName.length == 0)
        errMsg = @"请输入学校名称";
    else if(area.length == 0)
        errMsg = @"请输入地区";
    if(errMsg)
    {
        [ProgressHUD showHintText:errMsg];
        return;
    }
    RegisterAuthVC *authCodeVC = [[RegisterAuthVC alloc] init];
    [authCodeVC setMobile:mobile];
    [authCodeVC setName:name];
    [authCodeVC setSchool:schoolName];
    [authCodeVC setArea:area];
    [self.navigationController pushViewController:authCodeVC animated:YES];
}

- (void)contact
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
