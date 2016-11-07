//
//  NotificationPhotoView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/29.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationPhotoView.h"

@interface  NotificationPhotoItemView()
@property (nonatomic, strong)UIImageView*   imageView;
@property (nonatomic, strong)UIButton*      removeButton;
@end

@implementation NotificationPhotoItemView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.imageView setClipsToBounds:YES];
        [self addSubview:self.imageView];
        
        self.removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.removeButton setFrame:CGRectMake(self.width - 30, 0, 30, 30)];
        [self.removeButton setImage:[UIImage imageNamed:@"media_delete"] forState:UIControlStateNormal];
        [self.removeButton addTarget:self action:@selector(onRemoveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.removeButton setHidden:YES];
        [self addSubview:self.removeButton];
    }
    return self;
}

- (UIImageView *)curImageView{
    return self.imageView;
}

- (void)setDeleteCallback:(void (^)())deleteCallback
{
    _deleteCallback = [deleteCallback copy];
    [self.removeButton setHidden:!_deleteCallback];
}

- (void)setPhotoItem:(PhotoItem *)photoItem
{
    _photoItem = photoItem;
    if(_photoItem.isLocal){
        NSData *data = [NSData dataWithContentsOfFile:_photoItem.big];
        [self.imageView setImage:[UIImage imageWithData:data]];
    }
    else{
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:_photoItem.big]];
    }
}

- (void)onRemoveButtonClicked{
    if(self.deleteCallback){
        self.deleteCallback();
    }
}

@end

@interface NotificationPhotoView ()<PBViewControllerDataSource, PBViewControllerDelegate>
{
    UILabel*            _titleLabel;
    NSMutableArray*     _photoViewArray;
    UIView*             _sepLine;
}

@end

@implementation NotificationPhotoView

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
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
        
        [_sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(0);
        }];
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
