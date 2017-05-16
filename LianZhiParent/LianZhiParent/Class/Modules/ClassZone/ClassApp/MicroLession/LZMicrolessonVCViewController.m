//
//  LZMicrolessonVCViewController.m
//  LianZhiParent
//
//  Created by Chen Qi on 2016/10/13.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "LZMicrolessonVCViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LZOfficeVCViewController.h"
#import "LZCameraScanView.h"
#import "LianZhiParent-Swift.h"

//#ifdef DEBUG
//#define web365User @"11655" // 连枝web 365 转换用的用户ID  debug
//#else
#define web365User @"11078" // 连枝web 365 转换用的用户ID
//#endif
static const char *kScanQRCodeQueueName = "ScanQRCodeQueue";

@interface LZMicrolessonVCViewController ()<WKScriptMessageHandler,
AVCaptureMetadataOutputObjectsDelegate,WKNavigationDelegate>{
    WKWebViewConfiguration *configuration;
    UIBarButtonItem *cancelButtonItem;
    WKUserContentController *userContentController;
    BOOL  isForceBack;
}
@property (nonatomic,strong) AVCaptureSession *captureSession;
@property (nonatomic,strong) UIView *sanFrameView;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) BOOL isLoadedWebPage;
@property (nonatomic,strong) NSString *resourceId;
@property (nonatomic,strong) NSString *bookId;

@end

@implementation LZMicrolessonVCViewController

- (void)viewDidLoad {
    
    self.isLoadedWebPage = NO;
    
    [self addWebView];
    
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
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = 0;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addWebView{
    
    // js配置
    userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self name:@"appbox"];
    
    // WKWebView的配置
    configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = userContentController;
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.navigationDelegate = self;
    
}

//添加排名右侧导航按钮
-(void)addRightNaviItem
{
    self.navigationItem.rightBarButtonItem = cancelButtonItem;
}

-(UIView *)sanFrameView
{
    if(!_sanFrameView){
        _sanFrameView = [[UIView alloc] init];
        _sanFrameView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight  - 49);
        _sanFrameView.hidden = YES;
        [self.view addSubview:_sanFrameView];
        
    }
    return _sanFrameView;
}

// 添加扫描框  绿色
-(void)addCameraScanView
{
    UIView *cameraScanViewView = [_sanFrameView viewWithTag:1000];
    [cameraScanViewView removeFromSuperview];
    
    //设置扫描界面（包括扫描界面之外的部分置灰，扫描边框等的设置）,后面设置
    LZCameraScanView *clearView = [[LZCameraScanView alloc]initWithFrame:self.sanFrameView.frame];
    clearView.tag = 1000;
    [self.sanFrameView addSubview:clearView];
    
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
                isForceBack = NO;
                NSString *curUrl = body[@"page"];
                
                if(body[@"page"] && [curUrl isEqualToString:@"home"])
                    [CurrentROOTNavigationVC popViewControllerAnimated:YES];
            }
            else if([body[@"action"] isEqualToString:@"play"])
            { // 文档打开的JS回调
                isForceBack = NO;
                if(body[@"filename"] )
                {
                    NSString* filename = body[@"filename"];
                    NSString *decryptedUrl = @"";
                    
                    if(![filename hasPrefix:@"http://"])
                    {// AES 解密处理
                        CryptoHelper *cryptoHelper = [[CryptoHelper alloc] init];
                        
                        decryptedUrl = [cryptoHelper decryptWithEncryptedString:filename];
                    }
                    else
                        decryptedUrl = filename;
                    
                    NSLog(@"filename = %@ \r\n",filename);
                    NSLog(@"decryptedUrl = %@",decryptedUrl);
                    
                    if ([decryptedUrl isEqualToString:@""])
                        return;
                    
                    NSString *filePathStr = [decryptedUrl lastPathComponent];
                    NSString * exestr = [filePathStr pathExtension];
                    NSString * encoded365String = nil;
                    if(exestr && [exestr isEqualToString:@"mp4"])
                    {
                        
                        encoded365String = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)decryptedUrl, NULL, NULL,  kCFStringEncodingUTF8 ));
                        
                        
                    }
                    else
                    {
                        NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)decryptedUrl, NULL, NULL,  kCFStringEncodingUTF8 ));
                        encoded365String =  [NSString stringWithFormat:@"http://ow365.cn/?i=%@&del=1&furl=%@",web365User,encodedString];
                        
                    }
                    TNBaseWebViewController *webVC  = [[LZOfficeVCViewController alloc] initWithUrl:[NSURL URLWithString:encoded365String]];
                    
                    [self.navigationController pushViewController:webVC animated:YES];
                }
            }
            //  投影 回调
            else if([body[@"action"] isEqualToString:@"slideshow"])
            {// 投影打开的JS回调
                isForceBack = NO;
                if(body[@"resourceId"] && body[@"bookId"])
                {
                    self.resourceId = body[@"resourceId"];
                    self.bookId = body[@"bookId"];
                    
                    [self startReading];
                    [self addCameraScanView];
                    
                }
            }
            else if([body[@"action"] isEqualToString:@"timeout"]){
                NSLog(@"reason is %@",body[@"reason"]);
                isForceBack = YES;
                //[self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
            }
            
        }
    }
}

- (void)customBack
{
    NetworkStatus status = [ApplicationDelegate.hostReach currentReachabilityStatus];
    if(status == NotReachable)
    {
        [CurrentROOTNavigationVC popViewControllerAnimated:YES];
    }
    else if (isForceBack)
    {
        isForceBack = NO;
        [CurrentROOTNavigationVC popViewControllerAnimated:YES];
    }
    else if(self.isLoadedWebPage){
        [self.webView evaluateJavaScript:@"backAction();" completionHandler:^(id object, NSError *error) {
            NSLog(@"back pressed:");
        }];
    }
    else
    {
        [CurrentROOTNavigationVC popViewControllerAnimated:YES];
    }
    
    
}

- (void)back{
    
    [self customBack];
}

-(void)customBackItemClicked
{
    [self customBack];
    
}
- (void)dismiss{
    
    [self customBack];
    
}

-(void)closeItemClicked{
    [self customBack];
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


#pragma mark - 扫描二维码相关处理
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
    
    self.sanFrameView.hidden = NO;
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
            [self confirmScan:result];
            
        } else {
            NSLog(@"不是二维码");
            
        }
    }
}



// 网页版连枝课堂验证登录
- (void)confirmScan:(NSString *)linkUrl
{
    if (!linkUrl || linkUrl.length <= 0) {
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:_resourceId forKey:@"resourceId"];
    [params setValue:_bookId forKey:@"bookId"];
    [params setValue:[OpenUDID value] forKey:@"udid"];
    [params setValue:[UserCenter sharedInstance].userData.accessToken forKey:@"token"];
    [params setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"version"];
    //    [params setValue:@"3.1.0.11(F)" forKey:@"version"];
    [params setValue:@"1" forKey:@"platform"];
    
    __block MBProgressHUD *hud = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        hud = [MBProgressHUD showMessag:@"正在验证信息" toView:self.view];
    });
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 2.利用AFN管理者发送请求
    
    [manager POST:linkUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"请求成功---%@", responseObject);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            
            NSDictionary * dic = (NSDictionary *)responseObject;
            if(dic && dic[@"message"])
            {
                NSString *errMsg = dic[@"message"];
                [ProgressHUD showHintText:errMsg];
            }
            else
            {
                [ProgressHUD showHintText:@"网页版连枝课堂登录成功"];
            }
        });
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败---%@", error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            
            [ProgressHUD showHintText:error.description];
        });
        
        
    }];
    
    
    
}

@end
