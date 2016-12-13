//
//  LZMicrolessonVCViewController.m
//  LianZhiParent
//
//  Created by Chen Qi on 2016/10/13.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "LZMicrolessonVCViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ResourceDefine.h"
#import "LZOfficeVCViewController.h"

#define web365User @"11078" // 连枝web 365 转换用的用户ID

static const char *kScanQRCodeQueueName = "ScanQRCodeQueue";

@interface LZMicrolessonVCViewController ()<WKScriptMessageHandler,AVCaptureMetadataOutputObjectsDelegate>{
    WKWebViewConfiguration *configuration;
    NSString *curUrl;
    NSString *preUrl;
    UIBarButtonItem *cancelButtonItem;
    WKUserContentController *userContentController;
}
@property (nonatomic,strong) AVCaptureSession *captureSession;
@property (nonatomic,strong) UIView *sanFrameView;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) BOOL lastResult;
@property (nonatomic) BOOL isLoadedWebPage;
@property (nonatomic,strong) NSString *resourceId;
@property (nonatomic,strong) NSString *bookId;

@end

@implementation LZMicrolessonVCViewController

- (void)viewDidLoad {
    
    self.isLoadedWebPage = NO;
    // js配置
    userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self name:@"appbox"];
    
    // WKWebView的配置
    configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = userContentController;
    
    self.webView = nil;
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.navigationDelegate = self;

    self.sanFrameView = [[UIView alloc] init];
    self.sanFrameView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    self.sanFrameView.hidden = YES;
    [self.view addSubview:self.sanFrameView];
    [super viewDidLoad];
    
    cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain
                                                       target:self action:@selector(cancelButtonPressed)];

}

- (void)dealloc{
    //这里需要注意，前面增加过的方法一定要remove掉。
    [userContentController removeScriptMessageHandlerForName:@"appbox"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//添加排名右侧导航按钮
-(void)addRightNaviItem
{
    
    self.navigationItem.rightBarButtonItem = cancelButtonItem;
}

// 从web界面中接收到一个脚本时调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSDictionary * body = (NSDictionary *)message.body;
 
    if(body){
        if([body.allKeys containsObject:@"action"])
        {
            
                if([body[@"action"] isEqualToString:@"goto"])
                { // 返回的JS回调
                    preUrl = curUrl;
                    curUrl = body[@"page"];
                    
                    if(body[@"page"] && [curUrl isEqualToString:@"home"]
                       && [preUrl isEqualToString:@"home"])
                        [CurrentROOTNavigationVC popViewControllerAnimated:YES];
                }
                else if([body[@"action"] isEqualToString:@"play"])
                { // 文档打开的JS回调
                    if(body[@"filename"] )
                    {
                        NSString *filePathStr = [body[@"filename"] lastPathComponent];
                        NSString * exestr = [filePathStr pathExtension];
                        NSString * encoded365String = nil;
                        if(exestr && [exestr isEqualToString:@"mp4"])
                        {
                        
                            encoded365String = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)body[@"filename"], NULL, NULL,  kCFStringEncodingUTF8 ));
                            
                            
                        }
                        else
                        {
                            NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)body[@"filename"], NULL, NULL,  kCFStringEncodingUTF8 ));
                            encoded365String =  [NSString stringWithFormat:@"http://ow365.cn/?i=%@&del=1&furl=%@",web365User,encodedString];
                            
                        }
                        TNBaseWebViewController *webVC  = [[LZOfficeVCViewController alloc] initWithUrl:[NSURL URLWithString:encoded365String]];
        
                        [self.navigationController pushViewController:webVC animated:YES];
                    }
                }
             /*  暂时屏蔽
                else if([body[@"action"] isEqualToString:@"slideshow"])
                {// 投影打开的JS回调
                    if(body[@"resourceId"] && body[@"bookId"])
                    {
                        self.resourceId = body[@"resourceId"];
                        self.bookId = body[@"bookId"];
                        [self startReading];
                    }
                }
             */
            
            }
     
        }
}

- (void)back{
    
    if(self.isLoadedWebPage){
        [self.webView evaluateJavaScript:@"backAction();" completionHandler:^(id object, NSError *error) {
            NSLog(@"back pressed:");
        }];
    }
    else
    {
         [CurrentROOTNavigationVC popViewControllerAnimated:YES];
    }
}

-(void)customBackItemClicked
{
    if(self.isLoadedWebPage){
        [self.webView evaluateJavaScript:@"backAction();" completionHandler:^(id object, NSError *error) {
            NSLog(@"back pressed:");
        }];
    }
    else
    {
        [CurrentROOTNavigationVC popViewControllerAnimated:YES];
    }

}
- (void)dismiss{
    
    if(self.isLoadedWebPage){
        [self.webView evaluateJavaScript:@"backAction();" completionHandler:^(id object, NSError *error) {
            NSLog(@"back pressed:");
        }];
    }
    else
    {
        [CurrentROOTNavigationVC popViewControllerAnimated:YES];
    }


}
-(void)closeItemClicked{
    if(self.isLoadedWebPage){
        [self.webView evaluateJavaScript:@"backAction();" completionHandler:^(id object, NSError *error) {
            NSLog(@"back pressed:");
        }];
    }
    else
    {
        [CurrentROOTNavigationVC popViewControllerAnimated:YES];
    }

}


-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"WKWebView加载完成时调用");
    self.isLoadedWebPage = YES;
}



- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    self.isLoadedWebPage = NO;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    self.isLoadedWebPage = NO;
}
// JS端调用confirm函数时，会触发此方法
// 通过message可以拿到JS端所传的数据
// 在iOS端显示原生alert得到YES/NO后
// 通过completionHandler回调给JS端
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"confirm" message:@"JS调用confirm" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
    
    NSLog(@"%@", message);
}

// JS端调用prompt函数时，会触发此方法
// 要求输入一段文本
// 在原生输入得到文本内容后，通过completionHandler回调给JS
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    
    NSLog(@"%@", prompt);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"JS调用" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

#pragma mark - WKNavigationDelegate

/**
 *  在收到响应后，决定是否跳转
 *
 *  @param webView            实现该代理的webview
 *  @param navigationResponse 当前navigation
 *  @param decisionHandler    是否跳转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}



- (BOOL)startReading
{
    // 获取 AVCaptureDevice 实例
  
    
    NSError * error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 初始化输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _sanFrameView.hidden = NO;
    self.webView.hidden = YES;
    [self addRightNaviItem];
    
    // 创建会话
    _captureSession = [[AVCaptureSession alloc] init];
    // 添加输入流
    [_captureSession addInput:input];
    // 初始化输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    // 添加输出流
    [_captureSession addOutput:captureMetadataOutput];
    
    // 创建dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create(kScanQRCodeQueueName, NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    // 设置元数据类型 AVMetadataObjectTypeQRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // 创建输出对象
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_sanFrameView.layer.bounds];
    
   
    [_sanFrameView.layer addSublayer:_videoPreviewLayer];
    // 开始会话
    [_captureSession startRunning];
    
    return YES;
}

- (void)stopReading
{
    // 停止会话
    [_captureSession stopRunning];
    _captureSession = nil;
}

- (void)cancelButtonPressed{
    if(_captureSession) {
        if (_captureSession.isRunning) {
            [self stopReading];
            _sanFrameView.hidden = YES;
            self.webView.hidden = NO;
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSString *result;
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            result = metadataObj.stringValue;
            [self performSelectorOnMainThread:@selector(cancelButtonPressed) withObject:nil waitUntilDone:NO];
//            [self cancelButtonPressed];
            [self confirmScan:result];
           
        } else {
            NSLog(@"不是二维码");
            
            
        }
        
        
    }
}

- (void)reportScanResult:(NSString *)result
{
    [self stopReading];
    if (!_lastResult) {
        return;
    }
    self.lastResult = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"二维码扫描"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles: nil];
    [alert show];
    // 以下处理了结果，继续下次扫描
    _lastResult = YES;
}

// 获取学力相关数据
- (void)confirmScan:(NSString *)linkUrl
{
    if (!linkUrl || linkUrl.length <= 0) {
        return;
    }
//    NSString *childId = [UserCenter sharedInstance].curChild.uid;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:@"18649130140" forKey:@"username"];
    [params setValue:@"123456" forKey:@"password"];
    [params setValue:_resourceId forKey:@"resourceId"];
    [params setValue:_bookId forKey:@"bookId"];
    [params setValue:[OpenUDID value] forKey:@"udid"];
    [params setValue:[UserCenter sharedInstance].curChild.uid forKey:@"child_id"];
    [params setValue:[UserCenter sharedInstance].userData.accessToken forKey:@"verify"];
    [params setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"version"];
    [params setValue:@"1" forKey:@"platform"];
    
//    __weak typeof(self) wself = self;
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在获取信息" toView:self.view];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 2.利用AFN管理者发送请求
  
    [manager POST:linkUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功---%@", responseObject);
        [hud hide:YES];
        if(responseObject)
        {
//            NSLog(@"%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败---%@", error);
       
         [hud hide:YES];
        
         [ProgressHUD showHintText:error.description];
    }];
    
   
    
}

@end
