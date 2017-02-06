//
//  GrowthRecordCell.m
//  LianZhiTeacher
//
//  Created by jslsxu on 17/2/6.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "GrowthRecordCell.h"
#import "GrowthSegmentCtrl.h"

@interface GrowthStudentCell ()
@property (nonatomic, strong)AvatarView* avatarView;
@property (nonatomic, strong)UILabel* nameLabel;
@end

@implementation GrowthStudentCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.avatarView = [[AvatarView alloc] initWithRadius:20];
        [self addSubview:self.avatarView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 25)];
        [self.nameLabel setFont:[UIFont systemFontOfSize:15]];
        [self.nameLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self addSubview:self.nameLabel];
        
        [self.avatarView setOrigin:CGPointMake((self.width - self.avatarView.width) / 2, (self.height - 40 + 25) / 2)];
        [self.nameLabel setY:self.avatarView.bottom];
    }
    return self;
}

- (void)setStudentInfo:(StudentInfo *)studentInfo{
    _studentInfo = studentInfo;
    
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:_studentInfo.avatar] placeholderImage:nil];
    [self.nameLabel setText:_studentInfo.name];
}

@end

@interface GrowthRecordCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong)UIView* headerView;
@property (nonatomic, strong)AvatarView* avatarView;
@property (nonatomic, strong)UILabel* classNameLabel;
@property (nonatomic, strong)UIImageView* rightArrow;
@property (nonatomic, strong)UIView* redDot;

@property (nonatomic, strong)GrowthSegmentCtrl* segmentCtrl;
@property (nonatomic, strong)UICollectionView* collectionView;
@end

@implementation GrowthRecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
        [self addSubview:self.headerView];
        
        self.avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
        [self.headerView addSubview:self.avatarView];
        
        self.classNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.classNameLabel setFont:[UIFont systemFontOfSize:15]];
        [self.classNameLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [self.headerView addSubview:self.classNameLabel];
        
        self.rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        [self.rightArrow setOrigin:CGPointMake(self.headerView.width - 10 - self.rightArrow.width, (self.headerView.height - self.rightArrow.height) / 2)];
        [self.headerView addSubview:self.rightArrow];
        
        self.redDot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        [self.redDot.layer setCornerRadius:3];
        [self.redDot.layer setMasksToBounds:YES];
        [self.redDot setBackgroundColor:kRedColor];
        [self.redDot setOrigin:CGPointMake(self.rightArrow.left - 5 - self.redDot.width, (self.headerView.height - self.redDot.height) / 2)];
        [self.headerView addSubview:self.redDot];
        
        UIView* sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.headerView.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [self.headerView addSubview:sepLine];
        
        self.segmentCtrl = [[GrowthSegmentCtrl alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, self.width, 40)];
        [self.segmentCtrl setIndexChanged:^(NSInteger selectedIndex) {
            
        }];
        [self addSubview:self.segmentCtrl];
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.segmentCtrl.bottom, self.width, 120)];
        [self.collectionView setDelegate:self];
        [self.collectionView setDataSource:self];
        [self addSubview:self.collectionView];
    }
    return self;
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

@end
