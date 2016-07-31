//
//  NotificationDetailPhotoView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationDetailPhotoView.h"

@interface NotificationDetailPhotoView (){
    NSMutableArray*     _photoViewArray;
}
@end

@implementation NotificationDetailPhotoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _photoViewArray = [NSMutableArray array];
    }
    return self;
}

- (void)setPhotoArray:(NSArray *)photoArray{
    _photoArray = photoArray;
    [_photoViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_photoViewArray removeAllObjects];
    
    CGFloat height = 0;
    NSInteger margin = 10;
    NSInteger start = 0;
    if(_photoArray.count % 2 == 1){
        start = 1;
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, 0, self.width - margin * 2, (self.width - margin * 2) * 2 / 3 )];
        [imageView setBackgroundColor:[UIColor colorWithHexString:@"dddddd"]];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setClipsToBounds:YES];
        [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://www.pptbz.com/pptpic/UploadFiles_6909/201110/20111014111307895.jpg"] placeholderImage:nil];
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
        [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://www.pptbz.com/pptpic/UploadFiles_6909/201110/20111014111307895.jpg"] placeholderImage:nil];
        [_photoViewArray addObject:imageView];
        [self addSubview:imageView];
    }
    NSInteger row = (_photoArray.count - start + 1) / 2;
    height += (itemHeight + margin) * row;
    [self setHeight:height];
}

@end
