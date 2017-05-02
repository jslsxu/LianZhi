//
//  PublishVideoVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 2017/4/19.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "PublishVideoVC.h"
#import "DNImagePickerController.h"
#import "NotificationVideoView.h"
@interface PublishVideoVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, DNImagePickerControllerDelegate>
@property (nonatomic, strong)UTPlaceholderTextView *textView;
@property (nonatomic, strong)UIButton* addButton;
@property (nonatomic, strong)VideoItem *videoItem;
@property (nonatomic, strong)VideoItemView* videoView;
@end

@implementation PublishVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发视频";
    
    UIView* inputBG = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.width - 10 * 2, 100)];
    [inputBG setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    [inputBG.layer setCornerRadius:15];
    [inputBG.layer setMasksToBounds:YES];
    [self.view addSubview:inputBG];
    
    self.textView = [[UTPlaceholderTextView alloc] initWithFrame:CGRectInset(inputBG.bounds, 5, 5)];
    [self.textView setBackgroundColor:[UIColor clearColor]];
    [self.textView setFont:[UIFont systemFontOfSize:15]];
    [self.textView setPlaceholder:@"记录下与学生美好的回忆"];
    [inputBG addSubview:self.textView];
    
    _poiInfoView = [[PoiInfoView alloc] initWithFrame:CGRectMake(10, inputBG.bottom + 10, self.view.width - 10 * 2, 40)];
    [_poiInfoView setParentVC:self];
    [self.view addSubview:_poiInfoView];
    
    __weak typeof(self) wself = self;
    self.videoView = [[VideoItemView alloc] initWithFrame:CGRectMake(10, _poiInfoView.bottom + 20, 100, 100)];
    [self.videoView setDeleteCallback:^{
        [wself removeVideo];
    }];
    [self.videoView setHidden:YES];
    [self.view addSubview:self.videoView];
    
    self.addButton = [[UIButton alloc] initWithFrame:self.videoView.frame];
    [self.addButton addTarget:self action:@selector(onAddVideoClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.addButton.layer setCornerRadius:10];
    [self.addButton.layer setBorderWidth:1];
    [self.addButton.layer setBorderColor:kColor_99.CGColor];
    [self.addButton.layer setMasksToBounds:YES];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AddHomeWorkPhoto"]];
    [self.addButton addSubview:imageView];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setTextColor:kColor_66];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setNumberOfLines:0];
    [titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [titleLabel setText:@"上传视频\n(最长10秒)"];
    [titleLabel sizeToFit];
    [self.addButton addSubview:titleLabel];
    
    NSInteger height = titleLabel.height + 5 + imageView.height;
    [imageView setOrigin:CGPointMake((self.addButton.width - imageView.width) / 2, (self.addButton.height - height) / 2)];
    [titleLabel setOrigin:CGPointMake((self.addButton.width - titleLabel.width) / 2, imageView.bottom + 5)];
    [self.view addSubview:self.addButton];
}

- (void)addVideo:(VideoItem *)video{
    [self setVideoItem:video];
    [self.videoView setVideoItem:video];
    [self.addButton setHidden:YES];
    [self.videoView setHidden:NO];
}

- (void)removeVideo{
    [self setVideoItem:nil];
    [self.videoView setHidden:YES];
    [self.addButton setHidden:NO];
}

- (void)onSendClicked{
    if(self.videoItem){
        
    }
    else{
        [ProgressHUD showHintText:@"您还没有选择视频"];
    }
}

- (void)onAddVideoClicked{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择视频来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍摄视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setDelegate:self];
        [imagePicker setMediaTypes:@[(NSString *)kUTTypeMovie]];
        [imagePicker setVideoMaximumDuration:10];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DNImagePickerController *imagePicker = [[DNImagePickerController alloc] init];
        [imagePicker setFilterType:DNImagePickerFilterTypeVideos];
        [imagePicker setImagePickerDelegate:self];
        [imagePicker setMaxVideoCount:1];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    __weak typeof(self) wself = self;
    NSURL *url = info[UIImagePickerControllerMediaURL];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UISaveVideoAtPathToSavedPhotosAlbum(url.path, nil, nil, nil);
    });

    NSString *extasion = url.pathExtension;
    NSString *finalPath = [[NHFileManager getTmpVideoPath] stringByAppendingPathExtension:extasion];
    [FCFileManager moveItemAtPath:url.path toPath:finalPath overwrite:YES];
    url = [NSURL fileURLWithPath:finalPath];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if(data.length > 1024 * 1024 * 10){
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提示" message:@"视频文件过大" style:LGAlertViewStyleAlert buttonTitles:@[@"确定"] cancelButtonTitle:nil destructiveButtonTitle:nil];
        [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
        [alertView showAnimated:YES completionHandler:nil];
        return;
    }
    NSString *sizeStr = [Utility sizeStrForSize:data.length];
    NSInteger duration = [self getVideoDuration:url];
    LGAlertView*    alertView = [[LGAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"视频压缩后文件大小为%@",sizeStr] style:LGAlertViewStyleAlert buttonTitles:@[@"确定"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
    [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
    [alertView setButtonsFont:[UIFont boldSystemFontOfSize:18]];
    [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
        VideoItem *videoItem = [[VideoItem alloc] init];
        [videoItem setVideoUrl:finalPath];
        [videoItem setCoverImage:[UIImage coverImageForVideo:url]];
        [videoItem setVideoTime:duration];
        [wself addVideo:videoItem];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertView setCancelHandler:^(LGAlertView *alertView) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertView showAnimated:YES completionHandler:nil];
        
}

- (CGFloat) getVideoDuration:(NSURL*) URL
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    float second = 0;
    second = urlAsset.duration.value/urlAsset.duration.timescale;
    return second;
}

#pragma mark - DNImagePickerDelegate
- (void)dnImagePickerControllerDidCancel:(DNImagePickerController *)imagePicker{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)dnImagePickerController:(DNImagePickerController *)imagePicker sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage{
    if(imageAssets.count > 0){
        __weak typeof(self) wself = self;
        ALAsset *asset = imageAssets[0];
        ALAssetRepresentation *representation = asset.defaultRepresentation;
        UIImage *coverImage = [UIImage imageWithCGImage:[representation fullScreenImage] scale:1.f orientation:UIImageOrientationUp];
        BOOL shouldSend = [Utility checkVideo:asset];
        if(!shouldSend){
            return;
        }
       
        NSString *filePath = [[representation url] absoluteString];
        NSString *tmpPath = [NHFileManager tmpVideoPathForPath:filePath];
        NSInteger duration = [[asset valueForProperty:ALAssetPropertyDuration] integerValue];
        [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];
        MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在压缩" toView:[UIApplication sharedApplication].keyWindow];
        AVAsset *avAsset = [AVAsset assetWithURL:[NSURL URLWithString:filePath]];
        AVAssetExportSession * exportSession = [AVAssetExportSession exportSessionWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputURL = [NSURL fileURLWithPath:tmpPath];
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                if(AVAssetExportSessionStatusCompleted == exportSession.status){
                    VideoItem *videoItem = [[VideoItem alloc] init];
                    [videoItem setVideoUrl:tmpPath];
                    [videoItem setCoverImage:coverImage];
                    [videoItem setVideoTime:duration];
                    [videoItem setCoverWidth:coverImage.size.width];
                    [videoItem setCoverHeight:coverImage.size.height];
                    [wself addVideo:videoItem];
                }
                else{
                    
                    [ProgressHUD showHintText:@"压缩失败"];
                }
            });
            
        }];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
