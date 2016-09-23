//
//  RegisterVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "RegisterVC.h"
#import "RegisterAuthVC.h"
#import "CityManager.h"
@interface RegisterVC ()<ActionSelectViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong)NSMutableArray *feildArray;
@property (nonatomic, strong)CityManager *cityManager;
@end

@implementation RegisterVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.hideNavigationBar = NO;
        self.feildArray = [NSMutableArray array];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.cityManager = [[CityManager alloc] init];
        });
    
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请账号";
    
    NSArray *placeholderArray = @[@"您的姓名",@"手机号",@"学校名称",@"所在区域"];
    NSInteger itemHeight = 40;
    NSInteger hMargin = 10;
    NSInteger spaceYStart = 15;
    for (NSInteger i = 0; i < 4; i++)
    {
        UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(hMargin, spaceYStart, self.view.width - hMargin * 2, itemHeight)];
        [self.view addSubview:borderView];
        
        UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, borderView.width - 10 * 2, borderView.height - kLineHeight)];
        [textField setDelegate:self];
        [textField setReturnKeyType:UIReturnKeyDone];
        [textField setPlaceholder:placeholderArray[i]];
        [textField setFont:[UIFont systemFontOfSize:16]];
        [borderView addSubview:textField];
        
        UIView* sepLine = [[UIView alloc] initWithFrame:CGRectMake(10, borderView.height - kLineHeight, borderView.width - 10 * 2, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [borderView addSubview:sepLine];
        
        if(i == 3)
        {
            [textField setUserInteractionEnabled:NO];
            _area = textField;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:textField.frame];
            [button addTarget:self action:@selector(onAreaSelect) forControlEvents:UIControlEventTouchUpInside];
            [borderView addSubview:button];
        }
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

- (void)onAreaSelect
{
    [self.view endEditing:YES];
    ActionSelectView *selectView = [[ActionSelectView alloc] init];
    [selectView setDelegate:self];
    [selectView show];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - ActionSelect
- (NSInteger)numberOfComponentsInPickerView:(ActionSelectView *)pickerView
{
    return 3;
}
- (NSInteger)pickerView:(ActionSelectView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
        return self.cityManager.provinceList.count;
    else if(component == 1)
    {
        NSInteger row = [pickerView.pickerView selectedRowInComponent:0];
        Province *province = self.cityManager.provinceList[row];
        return province.cityList.count;
    }
    else
    {
        NSInteger firstRow = [pickerView.pickerView selectedRowInComponent:0];
        Province *province = self.cityManager.provinceList[firstRow];
        NSInteger secondRow = [pickerView.pickerView selectedRowInComponent:1];
        City *city = province.cityList[secondRow];
        return city.districtList.count;
    }
}
- (NSString *)pickerView:(ActionSelectView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
    {
        Province *province = self.cityManager.provinceList[row];
        return province.provinceName;
    }
    else if(component == 1)
    {
        NSInteger firstRow = [pickerView.pickerView selectedRowInComponent:0];
        Province *province = self.cityManager.provinceList[firstRow];
        City *city = province.cityList[row];
        return city.cityName;
    }
    else
    {
        NSInteger firstRow = [pickerView.pickerView selectedRowInComponent:0];
        Province *province = self.cityManager.provinceList[firstRow];
        NSInteger secondRow = [pickerView.pickerView selectedRowInComponent:1];
        City *city = province.cityList[secondRow];
        
        District *district = city.districtList[row];
        return district.districtName;
    }
}

- (void)pickerView:(ActionSelectView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [pickerView.pickerView reloadAllComponents];
}

- (void)pickerViewFinished:(ActionSelectView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger firstRow = [pickerView.pickerView selectedRowInComponent:0];
    NSInteger secondRow = [pickerView.pickerView selectedRowInComponent:1];
    NSInteger thirdRow = [pickerView.pickerView selectedRowInComponent:2];
    Province *province = self.cityManager.provinceList[firstRow];
    City *city = province.cityList[secondRow];
    District *distric = city.districtList[thirdRow];
    [_area setText:[NSString stringWithFormat:@"%@ %@ %@",province.provinceName, city.cityName,distric.districtName]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
