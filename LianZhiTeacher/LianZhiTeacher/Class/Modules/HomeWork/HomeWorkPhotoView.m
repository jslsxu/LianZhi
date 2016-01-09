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
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [_scrollView setDelegate:self];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:_scrollView];
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
    [_photoViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_photoViewArray removeAllObjects];
    for (NSInteger i = 0; i < MIN(_photoArray.count + 1, 9); i++)
    {
        if(i == _photoArray.count)//加号
        {
            UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [addButton setFrame:CGRectMake((10 + 90) * i, 10, 90, 90)];
            [addButton.layer setBorderWidth:2];
            [addButton.layer setBorderColor:[UIColor colorWithHexString:@"ebebeb"].CGColor];
            [addButton setImage:[UIImage imageNamed:@"AddHomeWorkPhoto"] forState:UIControlStateNormal];
            [addButton addTarget:self action:@selector(onAddButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:addButton];
            [_photoViewArray addObject:addButton];
        }
        else
        {
            UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake( (10 + 90) * i, 10, 90, 90)];
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
    [_scrollView setContentSize:CGSizeMake((90 + 10) * (_photoArray.count + 1) - 10, _scrollView.height)];
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
