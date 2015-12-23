//
//  UUAVAudioPlayer.m
//  BloodSugarForDoc
//
//  Created by shake on 14-9-1.
//  Copyright (c) 2014年 shake. All rights reserved.
//

#import "UUImageAvatarBrowser.h"

static UIView*  coverBG;
static UIImageView *orginImageView;
static NSString*    imageUrl;
static UIImageView *imageView;
@implementation UUImageAvatarBrowser

+ (void)showImage:(UIImageView *)avatarImageView withOriginalUrl:(NSString *)imageUrl
{
    UIImage *image=avatarImageView.image;
    orginImageView = avatarImageView;
    orginImageView.alpha = 0;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    coverBG = [[UIView alloc] initWithFrame:backgroundView.bounds];
    [coverBG setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
    [coverBG setAlpha:0.f];
    [backgroundView addSubview:coverBG];
    
    CGRect oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [backgroundView addGestureRecognizer:longPressGesture];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        coverBG.alpha = 1;
    } completion:^(BOOL finished) {
        if(imageUrl.length > 0)
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    }];
}

+ (void)onLongPress:(UILongPressGestureRecognizer *)longPress
{
    if(longPress.state == UIGestureRecognizerStateBegan)
    {
        TNButtonItem *item = [TNButtonItem itemWithTitle:@"保存图片" action:^{
            [self savePhotoWithImage:imageView.image];
        }];
        TNButtonItem *cancel = [TNButtonItem itemWithTitle:@"取消" action:^{
            
        }];
        TNActionSheet *actionSheet = [[TNActionSheet alloc] initWithTitle:@"" descriptionView:nil destructiveButton:nil cancelItem:cancel otherItems:@[item]];
        [actionSheet show];
    }
}

+ (void)hideImage:(UITapGestureRecognizer*)tap
{
    UIView *backgroundView=tap.view;
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=[orginImageView convertRect:orginImageView.bounds toView:[UIApplication sharedApplication].keyWindow];
        coverBG.alpha = 0.f;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        coverBG = nil;
        imageView = nil;
        orginImageView.alpha = 1;
    }];
}

+ (void)savePhotoWithImage:(UIImage *)aImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //        MJPhoto *photo = _photos[_currentPhotoIndex];
        UIImageWriteToSavedPhotosAlbum(aImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied)
        {
            [[[UIAlertView alloc] initWithTitle:@"图片保存失败😱" message:@"请检查隐私中的图片访问权限。" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
        }
        else
        {
            [ProgressHUD showHintText:@"图片保存失败"];
        }
        
    } else {
        [ProgressHUD showHintText:@"已保存到本地相册"];
    }
}

@end
