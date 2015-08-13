//
//  PublishImageItem.m
//  LianZhiParent
//
//  Created by jslsxu on 15/2/9.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "PublishImageItem.h"

@implementation PublishImageItem

- (void)setThumbnailUrl:(NSString *)thumbnailUrl
{
    _thumbnailUrl = thumbnailUrl;
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:_thumbnailUrl] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
    }];
}

- (void)setOriginalUrl:(NSString *)originalUrl
{
    _originalUrl = originalUrl;
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:_originalUrl] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
    }];
}
@end
