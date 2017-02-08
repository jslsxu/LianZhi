//
//  ChildPhotoView.m
//  LianZhiParent
//
//  Created by jslsxu on 17/2/8.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "ChildPhotoView.h"

@interface ChildPhotoItemView ()
@property (nonatomic, strong)UIImageView* imageView;
@end

@implementation ChildPhotoItemView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, 5, 5)];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)setPhotoItem:(PhotoItem *)photoItem{
    _photoItem = photoItem;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_photoItem.small] placeholderImage:nil];
}

@end

@interface ChildPhotoView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView* collectionView;
@end

@implementation ChildPhotoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.width - 10 * 2, 30)];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [self addSubview:titleLabel];
        
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake(80, 80)];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        UICollectionView* collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom, self.width, 80) collectionViewLayout:layout];
        [collectionView setDelegate:self];
        [collectionView setDataSource:self];
        [collectionView setBackgroundColor:[UIColor whiteColor]];
        [collectionView registerClass:[ChildPhotoItemView class] forCellWithReuseIdentifier:@"ChildPhotoItemView"];
        [self addSubview:collectionView];
        [self setCollectionView:collectionView];
    }
    return self;
}

- (void)setPhotoArray:(NSArray *)photoArray{
    _photoArray = photoArray;
    [self.collectionView reloadData];
    if([_photoArray count] > 0){
        [self setHeight:30 + 80];
    }
    else{
        [self setHeight:0];
    }
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.photoArray count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ChildPhotoItemView* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChildPhotoItemView" forIndexPath:indexPath];
    PhotoItem* item = self.photoArray[indexPath.row];
    [cell setPhotoItem:item];
    return cell;
}

@end
