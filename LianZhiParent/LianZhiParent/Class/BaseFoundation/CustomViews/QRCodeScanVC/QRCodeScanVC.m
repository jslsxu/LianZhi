//
//  QRCodeScanVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/5/13.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "QRCodeScanVC.h"

#define kScanLength             200
#define kScanStepLength         2

@interface QRCodeScanVC ()
@property (nonatomic, strong)CADisplayLink *displayLink;
@end

@implementation QRCodeScanVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_readerView flushCache];
    [_readerView start];
    [self startTimer];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.displayLink invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
}

- (void)setupSubviews
{
    CGFloat scanLength = kScanLength;
    CGFloat scanY = (self.view.height - 60 - scanLength) / 2;
    _readerView = [ZBarReaderView new];
    [_readerView setFrame:self.view.bounds];
    [_readerView setReaderDelegate:self];
    [_readerView setScanCrop:CGRectMake(0, (1 - _readerView.width / _readerView.height)  / 2, 1, _readerView.width / _readerView.height)];
    
    CameraMaskView *maskView = [[CameraMaskView alloc] initWithFrame:self.view.bounds];
    [maskView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    CGRect maskRect = CGRectMake((_readerView.width - scanLength) / 2, scanY, scanLength, scanLength);
    [maskView setNoMaskRect:maskRect];
    [_readerView addSubview:maskView];
    [self.view addSubview:_readerView];
    
    maskRect.size.height = 2;
    _scanLine = [[UIImageView alloc] initWithFrame:CGRectMake((_readerView.width - scanLength) / 2, scanY, scanLength, 2)];
    [_scanLine setImage:[UIImage imageNamed:@"ScanLine.png"]];
    [self.view addSubview:_scanLine];
    
    UIButton *scanFromAlbumButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanFromAlbumButton addTarget:self action:@selector(onScanFromAlbumClicked) forControlEvents:UIControlEventTouchUpInside];
    [scanFromAlbumButton setBackgroundImage:[[UIImage imageNamed:@"GreenBG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [scanFromAlbumButton setTitle:@"从相册选取二维码" forState:UIControlStateNormal];
    [scanFromAlbumButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scanFromAlbumButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [scanFromAlbumButton setFrame:CGRectMake(10, self.view.height - 10 - 40, self.view.width - 10 * 2, 40)];
    [self.view addSubview:scanFromAlbumButton];
}

- (void)onCancel
{
    if([self.delegate respondsToSelector:@selector(qrCodeScanVCDidCancel:)])
        [self.delegate qrCodeScanVCDidCancel:self];
}

- (void)startTimer
{
    if(self.displayLink)
    {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onTimer)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)onTimer
{
    count++;
    if(count > kScanLength / kScanStepLength)
        count = 0;
    _scanLine.y = count * kScanStepLength + (self.view.height - kScanLength - 60) / 2;
}

- (void)onScanFromAlbumClicked
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - ZbarReaderViewDelegate
- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    // 得到扫描的条码内容
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    NSString *symbolStr = [NSString stringWithUTF8String:zbar_symbol_get_data(symbol)];
    if (zbar_symbol_get_type(symbol) == ZBAR_QRCODE)
    {
        [readerView stop];
        if([self.delegate respondsToSelector:@selector(qrCodeScanVC:didFinish:)])
            [self.delegate qrCodeScanVC:self didFinish:symbolStr];
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(qrCodeScanVC:didFailWithError:)])
            [self.delegate qrCodeScanVC:self didFailWithError:@"没有扫描到二维码"];
    }
    
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //初始化
        ZBarReaderController * read = [ZBarReaderController new];
        //设置代理
        read.readerDelegate = self;
        CGImageRef cgImageRef = image.CGImage;
        ZBarSymbol * symbol = nil;
        id <NSFastEnumeration> results = [read scanImage:cgImageRef];
        for (symbol in results)
        {
            break;
        }
        NSString * result;
        if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding])
            
        {
            result = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
        else
        {
            result = symbol.data;
        }
        if(result)
        {
            if([self.delegate respondsToSelector:@selector(qrCodeScanVC:didFinish:)])
                [self.delegate qrCodeScanVC:self didFinish:result];
        }
        else
        {
            if([self.delegate respondsToSelector:@selector(qrCodeScanVC:didFailWithError:)])
                [self.delegate qrCodeScanVC:self didFailWithError:@"没有扫描到二维码"];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
