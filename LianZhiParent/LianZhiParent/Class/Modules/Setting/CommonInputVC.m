//
//  CommonInputVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/8/18.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "CommonInputVC.h"

@interface CommonInputVC ()
@property (nonatomic, copy)NSString *originalValue;
@property (nonatomic, copy)void (^completion)(NSString *value);
@end

@implementation CommonInputVC

- (instancetype)initWithOriginal:(NSString *)originalValue forKey:(NSString *)key completion:(void (^)(NSString *))completion
{
    self = [super init];
    if(self)
    {
        self.title = key;
        self.originalValue = originalValue;
        self.completion = completion;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onSave)];
    
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 45)];
//    [bgView setBackgroundColor:[UIColor clea]];
//    [self.view addSubview:bgView];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, self.view.width - 10 * 2, 40)];
    [_textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_textField setBackgroundColor:[UIColor whiteColor]];
    [_textField setReturnKeyType:UIReturnKeyDone];
    [_textField setFont:[UIFont systemFontOfSize:14]];
    [_textField setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
    [_textField addTarget:self action:@selector(onTextFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [_textField setText:self.originalValue];
    [self.view addSubview:_textField];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(10, _textField.bottom , _textField.width, 1)];
    [bottomLine setBackgroundColor:kCommonParentTintColor];
    [self.view addSubview:bottomLine];
    
    [_textField becomeFirstResponder];
}

- (void)onSave
{
    if(self.completion)
        self.completion(_textField.text);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onTextFieldValueChanged:(UITextField *)textField
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
