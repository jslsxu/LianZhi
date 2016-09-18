//
//  PBImageController.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/9/16.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "PBImageController.h"

@interface PBImageController ()<PBViewControllerDataSource, PBViewControllerDelegate>
@property (nonatomic, weak)UIView* targetView;
@property (nonatomic, weak)UIImage *placeHolder;
@property (nonatomic, copy)NSString *imageUrl;
@end

@implementation PBImageController
SYNTHESIZE_SINGLETON_FOR_CLASS(PBImageController)
- (void)showForView:(UIView *)targetView placeHolder:(UIImage *)image url:(NSString *)imageUrl{
    [self setTargetView:targetView];
    [self setPlaceHolder:image];
    [self setImageUrl:imageUrl];
    [self showPhotoBrowser];
}

- (void)showPhotoBrowser {
    PBViewController *pbViewController = [PBViewController new];
    pbViewController.pb_dataSource = self;
    pbViewController.pb_delegate = self;
    pbViewController.pb_startPage = 0;
    [CurrentROOTNavigationVC presentViewController:pbViewController animated:YES completion:nil];
}

- (NSInteger)numberOfPagesInViewController:(PBViewController *)viewController {
    return 1;
}

- (void)viewController:(PBViewController *)viewController presentImageView:(UIImageView *)imageView forPageAtIndex:(NSInteger)index progressHandler:(void (^)(NSInteger, NSInteger))progressHandler {
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]
                 placeholderImage:self.placeHolder
                          options:0
                         progress:progressHandler
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        }];
}

- (UIView *)thumbViewForPageAtIndex:(NSInteger)index {
    return self.targetView;
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
