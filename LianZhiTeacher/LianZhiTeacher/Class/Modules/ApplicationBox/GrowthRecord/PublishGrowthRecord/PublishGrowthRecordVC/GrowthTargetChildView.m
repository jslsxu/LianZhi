//
//  GrowthTargetChildView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 17/2/8.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "GrowthTargetChildView.h"
#import "DDCollectionViewHorizontalLayout.h"
#import "GrowthRecordChildSelectVC.h"
@interface GrowthTargetChildItemView ()
@property (nonatomic, strong)AvatarView* avatarView;
@property (nonatomic, strong)UILabel* nameLabel;
@property (nonatomic, strong)UIButton* removeButton;
@end

@implementation GrowthTargetChildItemView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
    }
    return self;
}

- (void)onDelete{
    if(self.itemRemoved){
        self.itemRemoved();
    }
}

@end

@interface GrowthTargetChildView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong)UILabel* titleLabel;
@property (nonatomic, strong)UICollectionView* collectionView;
@end

@implementation GrowthTargetChildView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        UIButton* addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [addButton setFrame:CGRectMake(self.width - 40, 5, 40, 30)];
        [addButton addTarget:self action:@selector(addTargets) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addButton];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, addButton.left - 10, 30)];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.titleLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [self.titleLabel setText:[NSString stringWithFormat:@"接收学生(%zd人)", [self.studentArray count]]];
        [self addSubview:self.titleLabel];
        
        UIView* hintView = [[UIView alloc] initWithFrame:CGRectMake(10, self.titleLabel.bottom, self.width - 10 * 2, 20)];
        NSArray* colorArray = @[@"27BBCD", @"FFC82C", @"27BBCD", @"F0003A"];
        NSArray* typeArray = @[@"未发送", @"已发送", @"已反馈", @"未出勤"];
        CGFloat spaceXStart = 0;
        for (NSInteger i = 0; i < 4; i++) {
            UIView* dot = [[UIView alloc] initWithFrame:CGRectMake(spaceXStart, (hintView.height - 6) / 2, 6, 6)];
            [dot setBackgroundColor:[UIColor colorWithHexString:colorArray[i]]];
            [dot.layer setCornerRadius:3];
            [dot.layer setMasksToBounds:YES];
            [hintView addSubview:dot];
            
            spaceXStart = dot.right + 3;
            
            UILabel* typeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [typeLabel setText:typeArray[i]];
            [typeLabel setFont:[UIFont systemFontOfSize:13]];
            [typeLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
            [typeLabel sizeToFit];
            [typeLabel setOrigin:CGPointMake(spaceXStart, dot.centerY - typeLabel.height / 2)];
            [hintView addSubview:typeLabel];
            
            spaceXStart = typeLabel.right + 10;
        }
        [self addSubview:hintView];
        
        [self addSubview:[self collectionView]];
        
        UIView* sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [sepLine setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
    }
    return self;
}

- (UICollectionView *)collectionView{
    if(nil == _collectionView){
        DDCollectionViewHorizontalLayout* layout = [[DDCollectionViewHorizontalLayout alloc] init];
        [layout setRowCount:2];
        [layout setItemCountPerRow:5];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, self.width, 160)];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        [_collectionView registerClass:[GrowthTargetChildItemView class] forCellWithReuseIdentifier:@"GrowthTargetChildItemView"];
    }
    return _collectionView;
}

- (void)setStudentArray:(NSArray *)studentArray{
    _studentArray = studentArray;
    [self.collectionView reloadData];
}

- (void)addTargets{
    GrowthRecordChildSelectVC* childSelectVC = [[GrowthRecordChildSelectVC alloc] init];
    [childSelectVC setSelectChanged:^{
        
    }];
    [CurrentROOTNavigationVC pushViewController:childSelectVC animated:YES];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.studentArray count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GrowthTargetChildItemView* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GrowthTargetChildItemView" forIndexPath:indexPath];
    [cell setItemRemoved:^{
        
    }];
    return cell;
}

@end
