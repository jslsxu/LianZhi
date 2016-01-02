//
//  TNBaseWebViewController.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/18.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseWebViewController.h"

@interface TNBaseWebViewController ()
@end

@implementation TNBaseWebViewController

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    if(_webView)
//    {
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
//        [_webView loadRequest:request];
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"WhiteLeftArrow"] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [backButton addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setSize:CGSizeMake(60, 40)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -10;
    self.navigationItem.leftBarButtonItems = @[space,backItem];
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [_webView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_webView setDelegate:self];
    [self.view addSubview:_webView];
    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_indicator setHidesWhenStopped:YES];
    [self.view addSubview:_indicator];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:10];
    [_webView loadRequest:request];
}

- (void)onBack
{
    if([_webView canGoBack])
        [_webView goBack];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupSubviews
{
    [_indicator setCenter:CGPointMake(self.view.width / 2, self.view.height / 2)];
}

- (void)setUrl:(NSString *)url
{
    _url = url;
    if(_webView)
    {
         NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:10];
        [_webView loadRequest:request];
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_indicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_indicator stopAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
