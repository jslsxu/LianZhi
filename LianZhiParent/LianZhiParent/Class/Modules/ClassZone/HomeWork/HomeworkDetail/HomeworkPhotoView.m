//
//  HomeworkPhotoView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/20.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkPhotoView.h"

@interface HomeworkPhotoView ()<PBViewControllerDelegate, PBViewControllerDataSource>
@property (nonatomic, strong)NSMutableArray*   imageViewArray;
@end

@implementation HomeworkPhotoView

- (void)setPhotoArray:(NSArray *)photoArray{
    _photoArray = photoArray;
    self.imageViewArray = [NSMutableArray array];
    NSInteger margin = 10;
    CGFloat spaceYStart = 0;
    for (NSInteger i = 0; i < [_photoArray count]; i++) {
        PhotoItem *photoItem = _photoArray[i];
        CGFloat width = self.width - margin * 2;
        CGFloat height;
        if(photoItem.height > 0 && photoItem.width){
            height = photoItem.height * width / photoItem.width;
        }
        else{
            height = width;
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, spaceYStart, width, height)];
        [imageView.layer setBorderColor:[UIColor colorWithHexString:@"f4f4f4"].CGColor];
        [imageView.layer setBorderWidth:kLineHeight];
        [imageView setBackgroundColor:[UIColor colorWithHexString:@"eeeeee"]];
        [imageView setUserInteractionEnabled:YES];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setClipsToBounds:YES];
        [imageView sd_setImageWithURL:[NSURL URLWithString:photoItem.big] placeholderImage:nil];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPhotoBrowser:)];
        [imageView addGestureRecognizer:tapGesture];
        [self.imageViewArray addObject:imageView];
        [self addSubview:imageView];
        spaceYStart = imageView.bottom + margin;
    }

    [self setHeight:spaceYStart];
}

- (void)showPhotoBrowser:(UITapGestureRecognizer *)sender {
    PBViewController *pbViewController = [PBViewController new];
    pbViewController.pb_dataSource = self;
    pbViewController.pb_delegate = self;
    pbViewController.pb_startPage = [self.imageViewArray indexOfObject:sender.view];
    [CurrentROOTNavigationVC presentViewController:pbViewController animated:YES completion:nil];
}

- (NSInteger)numberOfPagesInViewController:(PBViewController *)viewController {
    return self.imageViewArray.count;
}

- (void)viewController:(PBViewController *)viewController presentImageView:(UIImageView *)imageView forPageAtIndex:(NSInteger)index progressHandler:(void (^)(NSInteger, NSInteger))progressHandler {
    PhotoItem *item = self.photoArray[index];
    if(item.isLocal){
        NSData *imageData = [NSData dataWithContentsOfFile:item.big];
        [imageView setImage:[UIImage imageWithData:imageData]];
    }
    else{
        UIImageView *curImageView = self.imageViewArray[index];
        [imageView sd_setImageWithURL:[NSURL URLWithString:item.big]
                     placeholderImage:curImageView.image
                              options:0
                             progress:progressHandler
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            }];
        
    }
    
}

- (UIView *)thumbViewForPageAtIndex:(NSInteger)index {
    return self.imageViewArray[index];
}

#pragma mark - PBViewControllerDelegate

- (void)viewController:(PBViewController *)viewController didSingleTapedPageAtIndex:(NSInteger)index presentedImage:(UIImage *)presentedImage {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewController:(PBViewController *)viewController didLongPressedPageAtIndex:(NSInteger)index presentedImage:(UIImage *)presentedImage {
    if(presentedImage){
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:nil message:nil style:LGAlertViewStyleActionSheet buttonTitles:@[@"保存到相册"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
        [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
        [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
        [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
        [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
            [Utility saveImageToAlbum:presentedImage];
        }];
        [alertView showAnimated:YES completionHandler:nil];
    }
}



@end
