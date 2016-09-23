//
//  TNBaseWebViewController.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/18.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseWebViewController.h"

#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

#define boundsWidth self.view.bounds.size.width
#define boundsHeight self.view.bounds.size.height
@interface TNBaseWebViewController ()<WKNavigationDelegate>
@property (assign, nonatomic) NSUInteger loadCount;
@property (strong, nonatomic) UIProgressView *progressView;
@property (nonatomic)UIBarButtonItem* customBackBarItem;
@property (nonatomic)UIBarButtonItem* closeButtonItem;

@end

@implementation TNBaseWebViewController

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}

-(UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    //config navigation item
    //    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    
    // Do any additional setup after loading the view.
}



#pragma mark - public funcs
-(void)reloadWebView{
    [self.webView reload];
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView) {
        if([keyPath isEqualToString:@"estimatedProgress"]){
            CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
            if (newprogress == 1) {
                [self.progressView setProgress:1 animated:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.progressView.hidden = YES;
                    [self.progressView setProgress:0.f animated:NO];
                });
            }else {
                if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
                    return;
                }
                self.progressView.hidden = NO;
                [self.progressView setProgress:newprogress animated:YES];
            }
        }
        else if([keyPath isEqualToString:@"title"]){
            [self setTitle:self.webView.title];
        }
    }
}

#pragma mark - update nav items

-(void)updateNavigationItems{
    if (self.webView.canGoBack) {
        [self.navigationItem setLeftBarButtonItems:@[self.customBackBarItem,self.closeButtonItem] animated:NO];
    }else{
        [self.navigationItem setLeftBarButtonItem:self.customBackBarItem];
    }
}


-(void)customBackItemClicked{
    if([self.webView canGoBack]){
        [self.webView goBack];
    }
    else{
        [self closeItemClicked];
    }
}

-(void)closeItemClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - webView delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [self updateNavigationItems];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self updateNavigationItems];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
}

-(WKWebView*)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (UIProgressView *)progressView{
    if(_progressView == nil){
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
        //progressView.tintColor = WebViewNav_TintColor;
        _progressView.tintColor = kCommonParentTintColor;
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}

-(UIBarButtonItem*)customBackBarItem{
    if (!_customBackBarItem) {
        _customBackBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavBack"] style:UIBarButtonItemStylePlain target:self action:@selector(customBackItemClicked)];
    }
    return _customBackBarItem;
}

-(UIBarButtonItem*)closeButtonItem{
    if (!_closeButtonItem) {
        _closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeItemClicked)];
    }
    return _closeButtonItem;
}


@end
