
//
//  TestWebVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/11.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TestWebVC.h"

@interface TestWebVC ()<WKNavigationDelegate, WKScriptMessageHandler>

@end

@implementation TestWebVC
#pragma mark - init
-(instancetype)initWithUrl:(NSURL *)url{
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //config navigation item
    //    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    
    // Do any additional setup after loading the view.
}



-(void)customBackItemClicked{
    
}

-(void)closeItemClicked{
    [self.navigationController popViewControllerAnimated:YES];
}


-(WKWebView*)webView{
    if (!_webView) {
        WKUserContentController *userCOntroller = [WKUserContentController new];
        [userCOntroller addScriptMessageHandler:self name:@"appbox"];
        WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
        [configuration setUserContentController:userCOntroller];
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
}

@end
