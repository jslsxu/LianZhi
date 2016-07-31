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
        [self.removeButton setSize:CGSizeMake(35, 35)];
        [self.removeButton setImage:[UIImage imageNamed:@"delete_target"] forState:UIControlStateNormal];
        [self.removeButton addTarget:self action:@selector(onRemoveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.removeButton];
        @weakify(self);
        [self.removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.mas_offset(self.width);
        }];
    }
    return self;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    [self.imageView setImage:_image];
}

- (void)onRemoveButtonClicked{
    if(self.deleteCallback){
        self.deleteCallback();
    }
}

@end

@interface NotificationPhotoView (){
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
    }
    return self;
}

- (void)layoutSubviews{
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
        UIImage *image = _photoArray[i];
        NSInteger row = i / 3;
        NSInteger column = i % 3;
        NotificationPhotoItemView *itemView = [[NotificationPhotoItemView alloc] initWithFrame:CGRectMake(hMargin + (itemWidth + hInnerMargin) * column, _titleLabel.bottom + hMargin + (itemWidth + hInnerMargin) * row, itemWidth, itemWidth)];
        [itemView setImage:image];
        @weakify(self);
        [itemView setDeleteCallback:^{
            @strongify(self);
            [self deleteImage:image];
        }];
        [_photoViewArray addObject:itemView];
        [self addSubview:itemView];
    }
    NSInteger row = (_photoArray.count + 2) / 3;
    [self setHeight:_titleLabel.bottom + hMargin * 2 + itemWidth * row + hInnerMargin * (row - 1)];
}

- (void)deleteImage:(UIImage *)image{
    [self.photoArray removeObject:image];
    [self setPhotoArray:self.photoArray];
}

@end
