//
//  NotificationDetailPhotoView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationDetailPhotoView.h"

@interface NotificationDetailPhotoView ()<PBViewControllerDataSource, PBViewControllerDelegate>
{
    NSMutableArray*     _photoViewArray;
}
@end

@implementation NotificationDetailPhotoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _photoViewArray = [NSMutableArray array];
        [self setClipsToBounds:YES];
    }
    return self;
}

- (void)setPhotoArray:(NSArray *)photoArray{
    _photoArray = photoArray;
    [_photoViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_photoViewArray removeAllObjects];
    
    CGFloat height = 10;
    NSInteger margin = 10;
    NSInteger start = 0;
    if(_photoArray.count % 2 == 1){
        start = 1;
        PhotoItem *photoItem = _photoArray[0];
        CGFloat firstWidth = self.width - margin * 2;
        CGFloat firstHeight;
        if(photoItem.width > 0 && photoItem.height > 0){
            firstHeight = firstWidth * photoItem.height / photoItem.width;
        }
        else{
            firstHeight = firstWidth * 2 / 3;
        }
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, height, firstWidth, firstHeight)];
        [imageView setBackgroundColor:[UIColor colorWithHexString:@"dddddd"]];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setClipsToBounds:YES];
        [imageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapedImageView:)];
        [imageView addGestureRecognizer:tap];
        [imageView sd_setImageWithURL:[NSURL URLWithString:photoItem.small] placeholderImage:nil];

        [_photoViewArray addObject:imageView];
        [self addSubview:imageView];
        height += imageView.height + margin;
    }
    CGFloat itemWidth = (self.width - margin * 3) / 2;
    CGFloat itemHeight = itemWidth * 2 / 3;
    for (NSInteger i = start; i < _photoArray.count; i++) {
        NSInteger row = (i - start) / 2;
        NSInteger column = (i - start) % 2;
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin + (itemWidth + margin) * column, height + (itemHeight + margin) * row, itemWidth, itemHeight)];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setClipsToBounds:YES];
        [imageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapedImageView:)];
        [imageView addGestureRecognizer:tap];
        PhotoItem *photoItem = _photoArray[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:photoItem.small] placeholderImage:nil];
        [_photoViewArray addObject:imageView];
        [self addSubview:imageView];
    }
    NSInteger row = (_photoArray.count - start + 1) / 2;
    height += (itemHeight + margin) * row;
    [self setHeight:height];
}

- (void)handleTapedImageView:(UITapGestureRecognizer *)sender {
    [self _showPhotoBrowser:sender.view];
}

- (void)_showPhotoBrowser:(UIView *)sender {
    PBViewController *pbViewController = [PBViewController new];
    pbViewController.pb_dataSource = self;
    pbViewController.pb_delegate = self;
    pbViewController.pb_startPage = [_photoViewArray indexOfObject:sender];
    [CurrentROOTNavigationVC presentViewController:pbViewController animated:YES completion:nil];
}

- (NSInteger)numberOfPagesInViewController:(PBViewController *)viewController {
    return self.photoArray.count;
}

- (void)viewController:(PBViewController *)viewController presentImageView:(UIImageView *)imageView forPageAtIndex:(NSInteger)index progressHandler:(void (^)(NSInteger, NSInteger))progressHandler {
    id item = self.photoArray[index];
    if([item isKindOfClass:[PhotoItem class]]){
        PhotoItem *photoItem = (PhotoItem *)item;
        NSString *url = photoItem.big;
        UIImageView *curImageView = _photoViewArray[index];
        UIImage *placeholder = curImageView.image;
        [imageView sd_setImageWithURL:[NSURL URLWithString:url]
                     placeholderImage:placeholder
                              options:0
                             progress:progressHandler
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            }];
    }
    else if([item isKindOfClass:[UIImage class]]){
        [imageView setImage:item];
    }
}

- (UIView *)thumbViewForPageAtIndex:(NSInteger)index {
    return _photoViewArray[index];
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
