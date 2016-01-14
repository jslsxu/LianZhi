//
//  HomeWorkPhotoView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/12/7.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "HomeWorkPhotoView.h"

@implementation HomeWorkPhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _photoViewArray = [NSMutableArray array];
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - 20)];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setDelegate:self];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _scrollView.height, self.width, 20)];
        [_pageControl setHidesForSinglePage:YES];
        [_pageControl setUserInteractionEnabled:NO];
        [_pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor darkGrayColor]];
        [self addSubview:_pageControl];
    }
    return self;
}

- (void)setPhotoArray:(NSMutableArray *)photoArray
{
    _photoArray = photoArray;
    [self setupSubviews];
}

- (void)setupSubviews
{
    NSInteger innerMargin = 10;
    NSInteger itemWidth = (self.width - innerMargin * 2) / 3;
    [_photoViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_photoViewArray removeAllObjects];
    for (NSInteger i = 0; i < MIN(_photoArray.count + 1, 9); i++)
    {
        if(i == _photoArray.count)//加号
        {
            UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [addButton setFrame:CGRectMake((innerMargin + itemWidth) * i, 0, itemWidth, itemWidth)];
            [addButton.layer setBorderWidth:2];
            [addButton.layer setBorderColor:[UIColor colorWithHexString:@"ebebeb"].CGColor];
            [addButton setImage:[UIImage imageNamed:@"AddHomeWorkPhoto"] forState:UIControlStateNormal];
            [addButton addTarget:self action:@selector(onAddButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:addButton];
            [_photoViewArray addObject:addButton];
        }
        else
        {
            UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake( (innerMargin + itemWidth) * i, 0, itemWidth, itemWidth)];
            [photoView setUserInteractionEnabled:YES];
            [photoView setImage:_photoArray[i]];
            
            UIButton*   deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [deleteButton setImage:[UIImage imageNamed:@"HomeWorkPhotoDelete"] forState:UIControlStateNormal];
            [deleteButton addTarget:self action:@selector(onDeleteClicked:) forControlEvents:UIControlEventTouchUpInside];
            [deleteButton setFrame:CGRectMake(photoView.width - 20, 0, 20, 20)];
            [photoView addSubview:deleteButton];
            [_scrollView addSubview:photoView];
            [_photoViewArray addObject:photoView];
        }
    }
    NSInteger numPage = (_photoArray.count + 3) / 3;
    [_pageControl setNumberOfPages:numPage];
    [_pageControl setCurrentPage:numPage - 1];
    [_scrollView setContentSize:CGSizeMake(_scrollView.width * numPage, _scrollView.height)];
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentSize.width - _scrollView.width, 0)];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / scrollView.width;
    [_pageControl setCurrentPage:page];
}

- (void)onAddButtonClicked
{
    if(self.addCompletion)
        self.addCompletion();
}

- (void)onDeleteClicked:(UIButton *)button
{
    NSInteger index = [_photoViewArray indexOfObject:button.superview];
    [_photoArray removeObjectAtIndex:index];
    [self setupSubviews];
    if(self.completion)
        self.completion();
}

@end
