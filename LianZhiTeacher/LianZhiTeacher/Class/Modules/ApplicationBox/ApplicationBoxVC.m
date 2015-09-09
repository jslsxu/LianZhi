//
//  ApplicationBoxVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/8/12.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ApplicationBoxVC.h"
#import "NotificationToAllVC.h"
#import "PublishGrowthTimelineVC.h"
#import "ContactListVC.h"
@implementation ApplicationItem


@end

@implementation ApplicationItemCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        [_bgView setBackgroundColor:[UIColor colorWithHexString:@"D4D4D4"]];
        [_bgView.layer setCornerRadius:10];
        [_bgView.layer setMasksToBounds:YES];
        [self addSubview:_bgView];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 70)];
        [_imageView setContentMode:UIViewContentModeCenter];
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, self.width, 15)];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)setAppItem:(ApplicationItem *)appItem
{
    _appItem = appItem;
    [_imageView setImage:[UIImage imageNamed:_appItem.imageStr]];
    [_titleLabel setText:_appItem.title];
}

@end

@interface ApplicationBoxVC ()
@property (nonatomic, strong)NSArray *titleArray;
@property (nonatomic, strong)NSArray *imageArray;
@property (nonatomic, strong)NSMutableArray *appItems;
@property (nonatomic, strong)NSArray *actionArray;
@end

@implementation ApplicationBoxVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.actionArray = @[@"NotificationToAllVC",@"ContactListVC",@"ClassZoneVC",@"PublishGrowthTimelineVC",@"TNBaseWebViewController"];
        self.titleArray = @[@"发布通知",@"聊天空间",@"班空间",@"家园手册",@"校主页"];
        self.imageArray = @[@"AppPublishNote",@"AppChat",@"AppClassZone",@"AppParent",@"AppSchoolHome"];
        self.appItems = [NSMutableArray array];
        for (NSInteger i = 0; i < self.titleArray.count; i++)
        {
            ApplicationItem *item = [[ApplicationItem alloc] init];
            [item setImageStr:self.imageArray[i]];
            [item setTitle:self.titleArray[i]];
            [self.appItems addObject:item];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _layout = [[UICollectionViewFlowLayout alloc] init];
    [_layout setSectionInset:UIEdgeInsetsMake(15, 15, 15, 15)];
    [_layout setItemSize:CGSizeMake(90, 90)];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_layout];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView setAlwaysBounceVertical:YES];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [_collectionView registerClass:[ApplicationItemCell class] forCellWithReuseIdentifier:@"ApplicationItemCell"];
    [self.view addSubview:_collectionView];
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.appItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ApplicationItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ApplicationItemCell" forIndexPath:indexPath];
    [cell setAppItem:self.appItems[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString *classStr = self.actionArray[row];
    TNBaseViewController *vc = [[NSClassFromString(classStr) alloc] init];
    if(vc)
        [CurrentROOTNavigationVC pushViewController:vc animated:YES];
        
}
@end
