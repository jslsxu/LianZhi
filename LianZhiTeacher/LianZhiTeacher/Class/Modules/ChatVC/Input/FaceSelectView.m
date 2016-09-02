//
//  FaceSelectView.m
// MFWIOS
//
//  Created by dong jianbo on 12-5-25.
//  Copyright 2010 mafengwo. All rights reserved.
//

#import "FaceSelectView.h"


@implementation FaceItemCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - 20)];
        [_imageView setContentMode:UIViewContentModeCenter];
        [self addSubview:_imageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageView.bottom, self.width, 20)];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [_nameLabel setFont:[UIFont systemFontOfSize:13]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [self addSubview:_nameLabel];
    }
    return self;
}

- (void)setFaceIndex:(NSInteger)faceIndex
{
    _faceIndex = faceIndex;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"biaoqing%ld",_faceIndex + 1]];
    [_imageView setImage:image];
    [_nameLabel setText:[MFWFace faceStringForIndex:_faceIndex]];
}

@end

@implementation FaceCollectionView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        [_layout setItemSize:CGSizeMake(kFaceItemSize, kFaceItemSize)];
        NSInteger numPerRow = kScreenWidth / kFaceItemSize;
        NSInteger hMargin = (kScreenWidth - numPerRow * kFaceItemSize ) / 4;
        [_layout setSectionInset:UIEdgeInsetsMake(0, hMargin, 0, hMargin)];
        [_layout setMinimumInteritemSpacing:0];
        [_layout setMinimumLineSpacing:0];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_layout];
        [_collectionView setScrollsToTop:NO];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView registerClass:[FaceItemCell class] forCellWithReuseIdentifier:@"FaceItemCell"];
        [self addSubview:_collectionView];
    }
    return self;
}

- (void)setPage:(NSInteger)page
{
    _page = page;
    [_collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger totalPage = [MFWFace numOfPage];
    NSInteger total = [MFWFace numberOfFace];
    if(totalPage - 1 > self.page)
        return [MFWFace numOfFaceInPage];
    else
        return total - [MFWFace numOfFaceInPage] * self.page;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FaceItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FaceItemCell" forIndexPath:indexPath];
    [cell setFaceIndex:[MFWFace numOfFaceInPage] * self.page + indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(faceCollectionViewDidSelect:)])
        [self.delegate faceCollectionViewDidSelect:[MFWFace numOfFaceInPage] * self.page + indexPath.row];
}

@end

@implementation FaceSelectView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setHeight:FaceSelectHeight];
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - PageControlHeight)];
        [_scrollView setBackgroundColor:[UIColor clearColor]];
        [_scrollView setDelegate:self];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setScrollsToTop:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [self addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _scrollView.bottom, self.width, PageControlHeight)];
        [_pageControl setHidesForSinglePage:YES];
        [_pageControl setPageIndicatorTintColor:[UIColor colorWithHexString:@"999999"]];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithHexString:@"666666"]];
        [self addSubview:_pageControl];
        
        [self setupScrollView];
    }
    return self;
}

- (void)setupScrollView
{
    NSInteger numOfPages = [MFWFace numOfPage];
    for (NSInteger i = 0; i < numOfPages; i++)
    {
        FaceCollectionView *collectionView = [[FaceCollectionView alloc] initWithFrame:CGRectMake(_scrollView.width * i, 0, _scrollView.width, _scrollView.height)];
        [collectionView setDelegate:self];
        [collectionView setPage:i];
        [_scrollView addSubview:collectionView];
    }
    [_scrollView setContentSize:CGSizeMake(_scrollView.width * numOfPages, _scrollView.height)];
    [_pageControl setNumberOfPages:numOfPages];
    [_pageControl setCurrentPage:0];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [_pageControl setCurrentPage:index];
}

#pragma mark - FaceCollectionViewDelegate
- (void)faceCollectionViewDidSelect:(NSInteger)faceIndex
{
    if([self.delegate respondsToSelector:@selector(faceSelectViewDidSelectAtIndex:)])
        [self.delegate faceSelectViewDidSelectAtIndex:faceIndex];
}


@end