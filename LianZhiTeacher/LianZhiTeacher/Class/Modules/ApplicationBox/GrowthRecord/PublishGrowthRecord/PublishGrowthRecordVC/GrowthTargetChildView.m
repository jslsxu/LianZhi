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
        self.avatarView = [[AvatarView alloc] initWithRadius:20];
        [self.avatarView setOrigin:CGPointMake((self.width - self.avatarView.width) / 2, 10)];
        [self addSubview:self.avatarView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.avatarView.bottom, self.width, 20)];
        [self.nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self.nameLabel setFont:[UIFont systemFontOfSize:13]];
        [self.nameLabel setTextColor:kColor_66];
        [self addSubview:self.nameLabel];
        
        self.removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.removeButton setImage:[UIImage imageNamed:@"media_delete"] forState:UIControlStateNormal];
        [self.removeButton setFrame:CGRectMake(self.avatarView.right - 15, self.avatarView.top - 15, 30, 30)];
        [self.removeButton addTarget:self action:@selector(onDelete) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.removeButton];
    }
    return self;
}

- (void)setStudentInfo:(GrowthStudentInfo *)studentInfo{
    _studentInfo = studentInfo;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:_studentInfo.avatar] placeholderImage:nil];
    [self.nameLabel setText:_studentInfo.name];
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
        [layout setMinimumLineSpacing:0];
        [layout setMinimumInteritemSpacing:0];
        [layout setItemSize:CGSizeMake(self.width / 5, 80)];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, self.width, 160) collectionViewLayout:layout];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setPagingEnabled:YES];
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
    GrowthStudentInfo* studentInfo = self.studentArray[indexPath.row];
    [cell setStudentInfo:studentInfo];
    [cell setItemRemoved:^{
        
    }];
    return cell;
}

@end
