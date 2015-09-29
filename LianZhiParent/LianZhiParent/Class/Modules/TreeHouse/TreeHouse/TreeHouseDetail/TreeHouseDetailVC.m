//
//  TreeHouseDetailVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/9/27.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TreeHouseDetailVC.h"
#import "CollectionImageCell.h"
#define kInnerMargin                5

@implementation TreeHouseDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _avatar = [[AvatarView alloc] initWithFrame:CGRectMake(12, 12, 36, 36)];
        [self addSubview:_avatar];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 20, 0, 15)];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"cacaca"]];
        [_timeLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_timeLabel];
        
        _deleteButon = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButon setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_deleteButon addTarget:self action:@selector(onDeleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButon];
        
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 40, 0, 15)];
        [_addressLabel setTextColor:[UIColor colorWithHexString:@"cacaca"]];
        [_addressLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_addressLabel];
        
        _tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tagButton addTarget:self action:@selector(onTagButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_tagButton];
        
        NSInteger collectionWidth = self.width - 55 - 30;
        NSInteger itemWidth = (collectionWidth - kInnerMargin * 2) / 3;
        NSInteger innerMargin = (collectionWidth - itemWidth * 3) / 2;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake(itemWidth, itemWidth)];
        [layout setMinimumInteritemSpacing:innerMargin];
        [layout setMinimumLineSpacing:innerMargin];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(55, 0, collectionWidth, 0) collectionViewLayout:layout];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setShowsVerticalScrollIndicator:NO];
        [_collectionView registerClass:[CollectionImageCell class] forCellWithReuseIdentifier:@"CollectionImageCell"];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView setScrollsToTop:NO];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [self addSubview:_collectionView];
        
    }
    return self;
}

- (void)onDeleteButtonClicked
{
    
}

- (void)onTagButtonClicked
{
    
}

@end

@interface TreeHouseDetailVC ()

@end

@implementation TreeHouseDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
