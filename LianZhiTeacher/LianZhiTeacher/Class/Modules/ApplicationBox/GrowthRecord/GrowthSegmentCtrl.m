//
//  GrowthSegmentCtrl.m
//  LianZhiTeacher
//
//  Created by jslsxu on 17/2/6.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "GrowthSegmentCtrl.h"

#define kHMargin 20
@implementation GrowthSegmentItem
+ (GrowthSegmentItem *)itemWithTitle:(NSString* )title hasNew:(BOOL)hasNew{
    GrowthSegmentItem *item = [[GrowthSegmentItem alloc] init];
    [item setTitle:title];
    [item setHasNew:hasNew];
    return item;
}
@end

@interface GrowthSegmentCell ()
@property (nonatomic, strong)UILabel* titleLabel;
@property (nonatomic, strong)UIView* redDot;
@property (nonatomic, strong)UIView* indicator;
@end
@implementation GrowthSegmentCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self addSubview:self.titleLabel];
        
        self.redDot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        [self.redDot.layer setCornerRadius:3];
        [self.redDot.layer setMasksToBounds:YES];
        [self.redDot setBackgroundColor:kRedColor];
        [self addSubview:self.redDot];
        
        self.indicator = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 2, self.width, 2)];
        [self.indicator setBackgroundColor:kCommonTeacherTintColor];
        [self addSubview:self.indicator];
    }
    return self;
}

- (void)setItem:(GrowthSegmentItem *)item{
    _item = item;
    [self.titleLabel setText:_item.title];
    [self.titleLabel sizeToFit];
    [self.titleLabel setCenter:CGPointMake(self.width / 2, self.height / 2)];
    
    [self.redDot setOrigin:CGPointMake(self.titleLabel.right + 2, self.titleLabel.top - self.redDot.height / 2)];
    [self.redDot setHidden:!_item.hasNew];
}

- (void)setItemSelected:(BOOL)itemSelected{
    _itemSelected = itemSelected;
    [self.indicator setHidden:!_itemSelected];
    
    [self.titleLabel setTextColor:_itemSelected ? kCommonTeacherTintColor : [UIColor colorWithHexString:@"333333"]];
}

@end

@interface GrowthSegmentCtrl ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView* collectionView;
@end

@implementation GrowthSegmentCtrl

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [layout setSectionInset:UIEdgeInsetsMake(0, 20, 0, 20)];
        [layout setMinimumInteritemSpacing:0];
        [layout setMinimumLineSpacing:0];
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        [self.collectionView setShowsHorizontalScrollIndicator:NO];
        [self.collectionView setBackgroundColor:[UIColor whiteColor]];
        [self.collectionView setDelegate:self];
        [self.collectionView setDataSource:self];
        [self.collectionView registerClass:[GrowthSegmentCell class] forCellWithReuseIdentifier:@"GrowthSegmentCell"];
        [self addSubview:self.collectionView];
        
        UIView* sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
    }
    return self;
}

- (void)setSegments:(NSArray *)segments{
    _segments = segments;
    UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    [layout setItemSize:CGSizeMake((self.width - 20 * 2) / [_segments count], self.height)];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.segments count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GrowthSegmentCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GrowthSegmentCell" forIndexPath:indexPath];
    GrowthSegmentItem* item = self.segments[indexPath.row];
    [cell setItem:item];
    [cell setItemSelected:self.selectedIndex == indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.selectedIndex != indexPath.row){
        self.selectedIndex = indexPath.row;
        [collectionView reloadData];
        if(self.indexChanged){
            self.indexChanged(self.selectedIndex);
        }
    }
}

@end
