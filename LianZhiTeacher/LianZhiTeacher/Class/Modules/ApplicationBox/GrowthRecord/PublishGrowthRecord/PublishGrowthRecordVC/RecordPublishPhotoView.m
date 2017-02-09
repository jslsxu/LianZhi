//
//  RecordPublishPhotoView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 17/2/9.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "RecordPublishPhotoView.h"

@interface RecordPublishPhotoView ()<PBViewControllerDataSource, PBViewControllerDelegate>
{
    UILabel*            _titleLabel;
    NSMutableArray*     _photoViewArray;
    UIView*             _sepLine;
}

@end

@implementation RecordPublishPhotoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        [self setClipsToBounds:YES];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_titleLabel setText:@"图片:"];
        [_titleLabel sizeToFit];
        [_titleLabel setOrigin:CGPointMake(10, 12)];
        [self addSubview:_titleLabel];
        _photoViewArray = [NSMutableArray array];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [_sepLine setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_sepLine setFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
}

- (void)setPhotoArray:(NSMutableArray *)photoArray{
    _photoArray = photoArray;
    [_photoViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_photoViewArray removeAllObjects];
    NSInteger hMargin = 12;
    NSInteger hInnerMargin = 8;
    CGFloat itemWidth = (self.width - hMargin * 2 - hInnerMargin * 2) / 3;
    for (NSInteger i = 0; i < _photoArray.count; i++) {
        PhotoItem *photoItem = _photoArray[i];
        NSInteger row = i / 3;
        NSInteger column = i % 3;
        NotificationPhotoItemView *itemView = [[NotificationPhotoItemView alloc] initWithFrame:CGRectMake(hMargin + (itemWidth + hInnerMargin) * column, _titleLabel.bottom + hMargin + (itemWidth + hInnerMargin) * row, itemWidth, itemWidth)];
        [itemView setPhotoItem:photoItem];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapedImageView:)];
        [itemView addGestureRecognizer:tapGesture];
        if(!self.editDisable){
            @weakify(self);
            [itemView setDeleteCallback:^{
                @strongify(self);
                [self deleteImage:photoItem];
            }];
        }
        [_photoViewArray addObject:itemView];
        [self addSubview:itemView];
    }
    if(_photoArray.count == 0){
        [self setHeight:0];
    }
    else{
        NSInteger row = (_photoArray.count + 2) / 3;
        [self setHeight:_titleLabel.bottom + hMargin * 2 + itemWidth * row + hInnerMargin * (row - 1)];
    }
}

- (void)deleteImage:(PhotoItem *)image{
    if(self.deleteDataCallback){
        self.deleteDataCallback(image);
    }
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
    PhotoItem *item = self.photoArray[index];
    if(item.isLocal){
        NSData *imageData = [NSData dataWithContentsOfFile:item.big];
        [imageView setImage:[UIImage imageWithData:imageData]];
    }
    else{
        NotificationPhotoItemView *itemView = _photoViewArray[index];
        [imageView sd_setImageWithURL:[NSURL URLWithString:item.big]
                     placeholderImage:itemView.curImageView.image
                              options:0
                             progress:progressHandler
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            }];
        
    }
}

- (UIView *)thumbViewForPageAtIndex:(NSInteger)index {
    NotificationPhotoItemView *itemView = _photoViewArray[index];
    return itemView.curImageView;
}

#pragma mark - PBViewControllerDelegate

- (void)viewController:(PBViewController *)viewController didSingleTapedPageAtIndex:(NSInteger)index presentedImage:(UIImage *)presentedImage {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewController:(PBViewController *)viewController didLongPressedPageAtIndex:(NSInteger)index presentedImage:(UIImage *)presentedImage {
    
}

@end
