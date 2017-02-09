//
//  GrowthRecordChildSwitchView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 17/2/8.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "GrowthRecordChildSwitchView.h"

@interface  GrowthRecordChildCell()

@end

@implementation GrowthRecordChildCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
    }
    return self;
}

@end

@interface GrowthRecordChildSwitchView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong)UIButton* preButton;
@property (nonatomic, strong)UIButton* nextButton;
@property (nonatomic, strong)UICollectionView* collectionView;
@end

@implementation GrowthRecordChildSwitchView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.preButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.preButton setFrame:CGRectMake(0, 0, 50, self.height)];
        [self.preButton addTarget:self action:@selector(onPre) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.preButton];
        
        self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.nextButton setFrame:CGRectMake(self.width - 50, 0, 50, self.height)];
        [self.nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.nextButton];
        
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake(self.width - 50 * 2, self.height)];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.preButton.right, 0, self.nextButton.left - self.preButton.right, self.height) collectionViewLayout:layout];
        [self.collectionView setDelegate:self];
        [self.collectionView setDataSource:self];
        [self.collectionView setBackgroundColor:[UIColor whiteColor]];
        [self.collectionView registerClass:[GrowthRecordChildCell class] forCellWithReuseIdentifier:@"GrowthRecordChildCell"];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)setGrowthRecordArray:(NSArray *)growthRecordArray{
    _growthRecordArray = growthRecordArray;
    [self.collectionView reloadData];
}

- (void)onPre{
    if(self.selectedIndex > 0){
        self.selectedIndex = self.selectedIndex - 1;
        if(self.indexChanged){
            self.indexChanged(self.selectedIndex);
        }
    }
}

- (void)onNext{
    if(self.selectedIndex < [self.growthRecordArray count] - 1){
        self.selectedIndex = self.selectedIndex + 1;
        if(self.indexChanged){
            self.indexChanged(self.selectedIndex);
        }
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.growthRecordArray count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GrowthRecordChildCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GrowthRecordChildCell" forIndexPath:indexPath];
    return cell;
}
@end
