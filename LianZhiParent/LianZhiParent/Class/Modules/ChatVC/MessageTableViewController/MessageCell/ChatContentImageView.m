//
//  ChatImageCell.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ChatContentImageView.h"
#import "UUImageAvatarBrowser.h"
#define kImageMaxSize           140
@interface ChatContentImageView ()<PBViewControllerDataSource, PBViewControllerDelegate>

@end

@implementation ChatContentImageView

- (instancetype)initWithModel:(MessageItem *)messageItem maxWidth:(CGFloat)maxWidth{
    self = [super initWithModel:messageItem maxWidth:maxWidth];
    if(self){
        _contentImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_contentImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_bubbleBackgroundView addSubview:_contentImageView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapedImageView)];
        [_bubbleBackgroundView addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setMessageItem:(MessageItem *)messageItem{
    [super setMessageItem:messageItem];
    PhotoItem *photoItem = messageItem.content.exinfo.imgs;
    if(photoItem.width > photoItem.height)
        [_bubbleBackgroundView setSize:CGSizeMake(kImageMaxSize, kImageMaxSize * photoItem.height / photoItem.width)];
    else
        [_bubbleBackgroundView setSize:CGSizeMake(kImageMaxSize * photoItem.width / photoItem.height, kImageMaxSize)];
    [_contentImageView setFrame:_bubbleBackgroundView.bounds];
    if(messageItem.isLocalMessage){
        NSData *imageData = [NSData dataWithContentsOfFile:photoItem.big];
        UIImage *image = [UIImage imageWithData:imageData];
        [_contentImageView setImage:image];
    }
    else{
        [_contentImageView sd_setImageWithURL:[NSURL URLWithString:photoItem.small] placeholderImage:nil];
    }

    [self makeMaskView:_contentImageView withImage:[_bubbleBackgroundView image]];
    [self setSize:_bubbleBackgroundView.size];
}
- (void)makeMaskView:(UIView *)view withImage:(UIImage *)image
{
    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
    imageViewMask.frame = CGRectInset(view.frame, 0.0f, 0.0f);
    view.layer.mask = imageViewMask.layer;
}

- (void)onImageClicked{
    UIImageView *backImageView = _contentImageView;
    UIImage *defaultImage = backImageView.image;
    if(defaultImage)
    {
        PhotoItem *photoItem = self.messageItem.content.exinfo.imgs;
        [UUImageAvatarBrowser showImage:backImageView withOriginalUrl:photoItem.big size:CGSizeMake(photoItem.width, photoItem.height)];
    }

}

+ (CGFloat)contentHeightForModel:(MessageItem *)messageItem maxWidth:(CGFloat)maxWidth{
    PhotoItem *photoItem = messageItem.content.exinfo.imgs;
    if(photoItem.width > photoItem.height)
        return kImageMaxSize * photoItem.height / photoItem.width;
    else
        return kImageMaxSize;
}

- (void)handleTapedImageView{
    [self _showPhotoBrowser:_contentImageView];
}

- (void)_showPhotoBrowser:(UIView *)sender {
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
    if([self.messageItem isLocalMessage]){
        [imageView setImage:_contentImageView.image];
    }
    else{
        PhotoItem *photoItem = self.messageItem.content.exinfo.imgs;
        UIImage *placeholder = _contentImageView.image;
        [imageView sd_setImageWithURL:[NSURL URLWithString:photoItem.big]
                     placeholderImage:placeholder
                              options:0
                             progress:progressHandler
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            }];
    }
}

- (UIView *)thumbViewForPageAtIndex:(NSInteger)index {
    return _contentImageView;
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
