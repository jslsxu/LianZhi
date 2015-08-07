//
//  TGMMddPhotoBrowserNavigationBar.m
//  TravelGuideMdd
//
//  Created by CHANG LIU on 14/10/20.
//  Copyright (c) 2014年 mafengwo.com. All rights reserved.
//

#import "PhotoBrowserNavigationBar.h"
#import "MBProgressHUD+Add.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoBrowserNavigationBar()
{
    UIButton *backButton;
    UIButton *deleteButton;
    UIButton *saveButton;
}
@end

@implementation PhotoBrowserNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(10,20, 44, 44)];
        [backButton setImage:[UIImage imageNamed:MJRefreshSrcName(@"PhotoBrowserBack.png")] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        
        saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveButton setFrame:CGRectMake(self.width - 56, 20, 46, 44)];
        [saveButton setImage:[UIImage imageNamed:MJRefreshSrcName(@"PhotoDownload.png")] forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(clickSavePhoto) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:saveButton];
        
        deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setFrame:CGRectMake(saveButton.left - 44 - 10,20, 44, 44)];
        [deleteButton setImage:[UIImage imageNamed:MJRefreshSrcName(@"Trash.png")] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(clickDeletePhoto) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
    }
    return self;
}

- (void)setPhoto:(PhotoItem *)photo
{
    _photo = photo;
    [deleteButton setHidden:!self.photo.canDelete];
}


- (void)clickBack
{
    if ([_delegate respondsToSelector:@selector(didClickBackButton)]) {
        [_delegate didClickBackButton];
    }
}

- (void)clickDeletePhoto
{
    
    if([self.delegate respondsToSelector:@selector(didClickDeleteButton:)])
        [self.delegate didClickDeleteButton:self.photo];
}


- (void)clickSavePhoto
{
    __block UIImage *aimage;
    __weak typeof(self) wself = self;
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.photo.originalUrl] options:SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished,NSURL *url) {
        __strong typeof(self) sself = wself;
        if( image && finished && sself){
            aimage = image;
            [sself savePhotoWithImage:aimage];
        }else{
            [ProgressHUD showHintText:@"图片保存失败"];
        }
    }];
}

- (void)savePhotoWithImage:(UIImage *)aImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        MJPhoto *photo = _photos[_currentPhotoIndex];
        UIImageWriteToSavedPhotosAlbum(aImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
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
