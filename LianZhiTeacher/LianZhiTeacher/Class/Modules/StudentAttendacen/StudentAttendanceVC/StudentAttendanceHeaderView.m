//
//  StudentAttendanceHeaderView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/8.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "StudentAttendanceHeaderView.h"

#define kAvatarItemWith                 36

@implementation OffStudentCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _avatar = [[AvatarView alloc] initWithFrame:CGRectMake((self.width - kAvatarItemWith) / 2, 10, kAvatarItemWith, kAvatarItemWith)];
        [_avatar.layer setCornerRadius:_avatar.width / 2];
        [_avatar.layer setMasksToBounds:YES];
        [self addSubview:_avatar];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _avatar.height - 13, _avatar.width, 13)];
        [_statusLabel setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
        [_statusLabel setTextAlignment:NSTextAlignmentCenter];
        [_statusLabel setFont:[UIFont systemFontOfSize:9]];
        [_statusLabel setTextColor:[UIColor whiteColor]];
        [_avatar addSubview:_statusLabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _avatar.bottom + 4, self.width, 20)];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [self addSubview:_nameLabel];
    }
    return self;
}

- (void)setStudentInfo:(StudentInfo *)studentInfo
{
    _studentInfo = studentInfo;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:_studentInfo.avatar]];
    [_nameLabel setText:_studentInfo.name];
}

@end

@implementation StudentAttendanceHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _offHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 25)];
        [_offHeader setBackgroundColor:[UIColor colorWithHexString:@"fb5472"]];
        [self addSubview:_offHeader];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake(80, 80)];
        [layout setMinimumInteritemSpacing:0];
        [layout setMinimumLineSpacing:0];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _offHeader.bottom, self.width, self.height - _offHeader.height) collectionViewLayout:layout];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView setBounces:NO];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView registerClass:[OffStudentCell class] forCellWithReuseIdentifier:@"OffStudentCell"];
        [self addSubview:_collectionView];
        
        _attendanceHeader = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 25, self.width, 25)];
        [_attendanceHeader setBackgroundColor:[UIColor colorWithHexString:@"D7D7D7"]];
        [self addSubview:_attendanceHeader];
    }
    return self;
}

- (void)setOffArray:(NSArray *)offArray
{
    _offArray = offArray;
    if(_offArray.count > 0)
    {
        _offHeader.hidden = YES;
        _collectionView.hidden = YES;
        [self setHeight:25 * 2 + 80];
    }
    else
    {
        _offHeader.hidden = NO;
        _collectionView.hidden = NO;
        [self setHeight:25];
    }
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.offArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OffStudentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OffStudentCell" forIndexPath:indexPath];
    return cell;
}
@end
