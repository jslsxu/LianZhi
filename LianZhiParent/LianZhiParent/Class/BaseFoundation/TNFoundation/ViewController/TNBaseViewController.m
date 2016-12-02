//
//  TNBaseViewController.m
//  TNFoundation
//
//  Created by jslsxu on 14/10/20.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "UIImage+GIF.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

@interface TNBaseViewController ()

@end

@implementation TNBaseViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)setInteractivePopDisabled:(BOOL)interactivePopDisabled{
    _interactivePopDisabled = interactivePopDisabled;
    self.fd_interactivePopDisabled = _interactivePopDisabled;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.hidesBottomBarWhenPushed = YES;
        self.hideNavigationBar = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController setNavigationBarHidden:self.hideNavigationBar animated:animated];
    if(_loadingView.hidden == NO)
    {
        [_loadingView startAnimating];
    }
    
    UINavigationController *nav = self.navigationController;
    if(nav.viewControllers.count > 1){
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(0, 0, 44, 44)];
        [backButton setImage:[UIImage imageNamed:@"NavBack"] forState:UIControlStateNormal];
        [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [_loadingView setUserInteractionEnabled:NO];
    [_loadingView setCenter:CGPointMake(self.view.width / 2, self.view.height / 2 - 30)];
    [self.view addSubview:_loadingView];
    [_loadingView setHidden:YES];
    
    _showError = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ShowError.png"]];
    [_showError setCenter:CGPointMake(self.view.width / 2, self.view.height / 2 - 30)];
    [self.view addSubview:_showError];
    [_showError setAlpha:0.f];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(!_hasSetup)
    {
        [self setupSubviews];
        _hasSetup = YES;
    }
    [self.emptyView setCenter:CGPointMake(self.view.width / 2, self.view.height / 2)];
}

- (void)setupSubviews
{
    
}


- (void)startLoading
{
    [self.view bringSubviewToFront:_loadingView];
    [_loadingView setHidden:NO];
}

- (void)endLoading
{
    [_loadingView setHidden:YES];
}

- (void)showError
{
    [self.view bringSubviewToFront:_showError];
    [_showError setAlpha:1.f];
    [UIView animateWithDuration:0.3 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_showError setAlpha:0];
    } completion:^(BOOL finished) {
    }];
}

- (void)showEmptyLabel:(BOOL)show
{
    if(_emptyLabel == nil)
    {
        _emptyLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
        [_emptyLabel setBackgroundColor:[UIColor clearColor]];
        [_emptyLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_emptyLabel setFont:[UIFont systemFontOfSize:14]];
        [_emptyLabel setText:@"还没有任何内容哦"];
        [_emptyLabel sizeToFit];
        [self.view addSubview:_emptyLabel];
    }
    [self.view bringSubviewToFront:_emptyLabel];
    [_emptyLabel setHidden:!show];
    [_emptyLabel setCenter:CGPointMake(self.view.width / 2, self.view.height / 2)];
}

- (void)showEmptyView:(BOOL)show
{
    if([self.emptyView superview] == nil){
        [self.view addSubview:self.emptyView];
    }
    [self.view bringSubviewToFront:self.emptyView];
    [self.emptyView setHidden:!show];
    [self.emptyView setCenter:CGPointMake(self.view.width / 2, self.view.height / 2)];
}

- (void)addKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)onKeyboardWillShow:(NSNotification *)note
{
    
}

- (void)onKeyboardWillHide:(NSNotification *)note
{
    
}
- (void)resignKeyboard
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma - cache

- (BOOL)supportCache
{
    return NO;
}

- (NSString *)cacheFilePath
{
    NSString *cacheName = [self cacheFileName];
    if(cacheName)
    {
        return [[NHFileManager localCurrentUserRequestCachePath] stringByAppendingPathComponent:cacheName];
    }
    return nil;
}


- (NSString *)cacheFileName
{
    return nil;
}


- (void)dealloc
{
    DLOG(@"%@ dealloc",NSStringFromClass([self class]));
}

@end
