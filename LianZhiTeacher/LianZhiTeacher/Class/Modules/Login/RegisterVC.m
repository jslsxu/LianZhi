//
//  RegisterVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "RegisterVC.h"

@interface RegisterVC ()

@end

@implementation RegisterVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.hideNavigationBar = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请账号";
    [self.view setBackgroundColor:kCommonTeacherTintColor];
    
    NSArray *imageArray = @[@"",@"",@"",@""];
    NSArray *placeholderArray = @[@"您的姓名",@"手机号",@"学校名称",@"所在区域"];
    NSInteger itemHeight = 36;
    NSInteger hMargin = 10;
    NSInteger spaceYStart = 15;
    for (NSInteger i = 0; i < 4; i++)
    {
        UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(hMargin, spaceYStart + (hMargin + itemHeight) * i, self.view.width - hMargin * 2, itemHeight)];
        [borderView setBackgroundColor:[UIColor whiteColor]];
        [borderView.layer setBorderWidth:1];
        [borderView.layer setMasksToBounds:YES];
        [self.view addSubview:borderView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageArray[i]]];
        [imageView setOrigin:CGPointMake(8, (borderView.height - imageView.height) / 2)];
        [borderView addSubview:imageView];
        
        UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(imageView.right + 8, 0, borderView.width - 10 - (imageView.right + 8), borderView.height)];
        [textField setPlaceholder:placeholderArray[i]];
        [textField setFont:[UIFont systemFontOfSize:16]];
        [borderView addSubview:textField];
        
        spaceYStart += hMargin + itemHeight;
    }
    
    spaceYStart += hMargin;
    UIButton *authButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [authButton setFrame:CGRectMake(hMargin, spaceYStart, self.view.width - hMargin * 2, 40)];
    [authButton addTarget:self action:@selector(onAuthClicked) forControlEvents:UIControlEventTouchUpInside];
    [authButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [authButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [authButton setTitle:@"短信验证" forState:UIControlStateNormal];
    [self.view addSubview:authButton];
}

- (void)onAuthClicked
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
