//
//  FunctionView.m
//  LianZhiParent
//
//  Created by jslsxu on 15/9/5.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "FunctionView.h"

@implementation FunctionItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, self.width, 20)];
        [_titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)setImageStr:(NSString *)imageStr
{
    _imageStr = imageStr;
    [_imageView setImage:[UIImage imageNamed:self.imageStr]];
}

//- (void)setHighlighted:(BOOL)highlighted
//{
//    [super setHighlighted:highlighted];
//    if(highlighted)
//        [_imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Highlighted",self.imageStr]]];
//    else
//        [_imageView setImage:[UIImage imageNamed:self.imageStr]];
//}


@end

@interface FunctionView ()
@property (nonatomic, strong)NSArray *imageArray;
@property (nonatomic, strong)NSArray *titleArray;
@end

@implementation FunctionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.titleArray = @[@"发照片",@"拍摄"/*,@"发礼物"*/];
        self.imageArray = @[@"FunctionAlbum",@"FunctionCamera"/*,@"FunctionGift"*/];
        NSInteger itemWIdth = 75;
        UICollectionViewFlowLayout *_layout = [[UICollectionViewFlowLayout alloc] init];
        [_layout setItemSize:CGSizeMake(itemWIdth, itemWIdth + 15)];
        NSInteger numPerRow = kScreenWidth / itemWIdth;
        NSInteger hMargin = (kScreenWidth - numPerRow * itemWIdth) / 4;
        [_layout setSectionInset:UIEdgeInsetsMake(0, hMargin, 0, hMargin)];
        [_layout setMinimumInteritemSpacing:0];
        [_layout setMinimumLineSpacing:0];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_layout];
        [_collectionView setScrollsToTop:NO];
        [_collectionView setAlwaysBounceHorizontal:YES];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView registerClass:[FunctionItemCell class] forCellWithReuseIdentifier:@"FunctionItemCell"];
        [self addSubview:_collectionView];
    }
    return self;
}

- (void)setCanSendGift:(BOOL)canSendGift
{
    _canSendGift = canSendGift;
    if(_canSendGift)
    {
        self.titleArray = @[@"发照片",@"拍摄",@"小视频",@"发礼物"];
        self.imageArray = @[@"FunctionAlbum",@"FunctionCamera",@"FunctionVideo",@"FunctionGift"];
    }
    else
    {
        self.titleArray = @[@"发照片",@"拍摄",@"小视频"];
        self.imageArray = @[@"FunctionAlbum",@"FunctionCamera",@"FunctionVideo"];
    }
    [_collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FunctionItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FunctionItemCell" forIndexPath:indexPath];
    [cell setImageStr:self.imageArray[indexPath.row]];
    [cell.titleLabel setText:self.titleArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(functionViewDidSelectAtIndex:)])
        [self.delegate functionViewDidSelectAtIndex:indexPath.row];
}


@end
