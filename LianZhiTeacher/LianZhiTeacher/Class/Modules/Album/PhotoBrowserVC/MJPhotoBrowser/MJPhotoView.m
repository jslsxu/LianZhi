//
//  MJZoomingScrollView.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoView.h"
#import "MJPhotoLoadingView.h"
#import "UIImageView+URLWithAnimation.h"
#import <QuartzCore/QuartzCore.h>

#define CONSTRAINT_VALUE(value, min, max) MIN(MAX((value), (min)), (max))

@interface MJPhotoView ()
{
    BOOL                    _doubleTap;
    UIImageView *           _imageView;
    MJPhotoLoadingView*     _photoLoadingView;
}
@end

@implementation MJPhotoView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
		// 图片
		_imageView = [[UIImageView alloc] init];
		_imageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:_imageView];
        
        // 进度条
        _photoLoadingView = [[MJPhotoLoadingView alloc] init];
		
		// 属性
		self.backgroundColor = [UIColor clearColor];
		self.delegate = self;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.decelerationRate = UIScrollViewDecelerationRateFast;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // 监听点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
    }
    return self;
}

#pragma mark - photoSetter
- (void)setPhoto:(PhotoItem *)photo {
    _photo = photo;
    [_photoLoadingView removeFromSuperview];
    if(_photo.image == nil)
        [self showImage];
    else
    {
        [_imageView setImage:_photo.image];
    }
}

#pragma mark 显示图片
- (void)showImage
{
    [self photoStartLoad];
    [self adjustFrame];
}

#pragma mark 开始加载图片
- (void)photoStartLoad
{
    self.scrollEnabled = NO;
    // 直接显示进度条
    [_photoLoadingView showLoading];
    [self addSubview:_photoLoadingView];
    
    __weak MJPhotoView *wPhotoView = self;
    __weak MJPhotoLoadingView *wLoading = _photoLoadingView;
    NSString *targetUrl = _photo.big;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:targetUrl]
                  placeholderImage:nil
                           options:SDWebImageRetryFailed|SDWebImageLowPriority
                          progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                  
                                __strong MJPhotoView *sPhoneView = wPhotoView;
                                __strong MJPhotoLoadingView *sLoading = wLoading;
                                  if (sPhoneView && sLoading)
                                  {
                                      if (receivedSize > kMinProgress) {
                                          sLoading.progress = (float)receivedSize/expectedSize;
                                      }
                                  }
                                  
                          } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL *url) {
                              __strong MJPhotoView *sPhoneView = wPhotoView;
            
                              if (sPhoneView)
                              {
                                  if ([targetUrl isEqualToString:[url absoluteString]]) {
                                      [sPhoneView photoDidFinishLoadWithImage:image withURL:url];
                                  }
                              }
                          }];
}

#pragma mark 加载完毕
- (void)photoDidFinishLoadWithImage:(UIImage *)image withURL:(NSURL *)url
{
    if (![self.photo.big isEqualToString:[url absoluteString]]) {
        return;
    }
    if (image) {
        self.scrollEnabled = YES;
        _imageView.image = image;
//        _photo.image = image;
        [_photoLoadingView removeFromSuperview];
        
    } else {
        [self addSubview:_photoLoadingView];
        [_photoLoadingView showFailure];
    }
    
    // 设置缩放比例
    [self adjustFrame];
}
#pragma mark 调整frame
- (void)adjustFrame
{
	if (_imageView.image == nil) return;
    
    // 基本尺寸参数
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize imageSize = _imageView.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
	
	// 设置伸缩比例
    CGFloat minScale = boundsWidth / imageWidth;
	if (minScale > 1) {
		minScale = 1.0;
	}
    CGFloat maxScale = 2.0;
    self.maximumZoomScale = maxScale;
	self.minimumZoomScale = minScale;
	self.zoomScale = minScale;
    
    CGRect imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
    // 内容尺寸
    self.contentSize = CGSizeMake(0, imageFrame.size.height);
    
    // y值
    if (imageFrame.size.height < boundsHeight) {
        imageFrame.origin.y = floorf((boundsHeight - imageFrame.size.height) / 2.0);
	} else {
        imageFrame.origin.y = 0;
	}
    _imageView.frame = imageFrame;
}

- (void)centerScrollViewCenter
{
    CGSize boundsSize = self.bounds.size;
    CGRect contentsFrame = _imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width)
    {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0;
    } else {
        contentsFrame.origin.x = 0.0;
    }
    
    if (contentsFrame.size.height < boundsSize.height)
    {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0;
    } else {
        contentsFrame.origin.y = 0.0;
    }
    
    _imageView.frame = contentsFrame;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _imageView;
}


-(void) scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerScrollViewCenter];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap
{
    _doubleTap = NO;
    [self performSelector:@selector(hide) withObject:nil afterDelay:0.2];
}


- (void)hide
{
    if (_doubleTap)
    {
        return;
    }
    
    if ([self.photoViewDelegate respondsToSelector:@selector(photoViewSingleTap:)])
    {
        [self.photoViewDelegate photoViewSingleTap:self];
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = YES;
    
	if (self.zoomScale == self.maximumZoomScale) {
		[self setZoomScale:self.minimumZoomScale animated:YES];
//        [self resetFrame];
	} else {
        CGPoint pointInView = [tap locationInView:_imageView];
        
        CGFloat newZoomScale = self.maximumZoomScale;
        
        CGSize scrollViewSize = self.bounds.size;
        CGFloat width = scrollViewSize.width / newZoomScale;
        CGFloat height = scrollViewSize.height / newZoomScale;
        CGFloat x = pointInView.x - (width / 2.0);
        CGFloat y = pointInView.y - (width / 2.0);
        
        [self zoomToRect:CGRectMake(x, y, width, height) animated:YES];

	}
}

- (void)resetFrame
{
    CGRect imageFrame = _imageView.frame;
    if (imageFrame.size.height < self.bounds.size.height) {
        imageFrame.origin.y = floorf((self.bounds.size.height - imageFrame.size.height) / 2.0);
    } else {
        imageFrame.origin.y = 0;
    }
    _imageView.frame = imageFrame;
}

@end


@implementation PhotoBrowseCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _photoView = [[MJPhotoView alloc] initWithFrame:self.bounds];
        [self addSubview:_photoView];
    }
    return self;
}

- (void)setPhotoItem:(PhotoItem *)photoItem
{
    _photoItem = photoItem;
    [_photoView setPhoto:_photoItem];
}

@end