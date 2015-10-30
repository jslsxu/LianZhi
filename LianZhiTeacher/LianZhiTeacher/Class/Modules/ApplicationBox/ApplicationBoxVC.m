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
#import "ClassSelectionVC.h"
#import "GrowthTimelineVC.h"
@implementation ApplicationItem


@end

@implementation ApplicationItemCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        [_bgView setBackgroundColor:[UIColor colorWithHexString:@"dbdbdb"]];
        [_bgView.layer setCornerRadius:10];
        [_bgView.layer setMasksToBounds:YES];
        [self addSubview:_bgView];
        
        _coverButton = [LZTabBarButton buttonWithType:UIButtonTypeCustom];
        [_coverButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_coverButton setSpacing:6];
        [_coverButton setUserInteractionEnabled:NO];
        [_coverButton setFrame:self.bounds];
        [_coverButton setTitleColor:[UIColor colorWithHexString:@"2c2c2c"] forState:UIControlStateNormal];
        [self addSubview:_coverButton];
    }
    return self;
}

- (void)setAppItem:(ApplicationItem *)appItem
{
    _appItem = appItem;
    [_coverButton setImage:[UIImage imageNamed:_appItem.imageStr] forState:UIControlStateNormal];
    [_coverButton setTitle:_appItem.title forState:UIControlStateNormal];
}

@end

@interface ApplicationBoxVC ()
@property (nonatomic, strong)NSArray *titleArray;
@property (nonatomic, strong)NSArray *imageArray;
@property (nonatomic, strong)NSMutableArray *appItems;
@property (nonatomic, strong)NSArray *actionArray;
@property (nonatomic, strong)NotificationToAllVC *notificationVC;
@end

@implementation ApplicationBoxVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    if([UserCenter sharedInstance].curSchool.classes.count + [UserCenter sharedInstance].curSchool.managedClasses.count > 0)
    {
        self.actionArray = @[@"NotificationToAllVC",@"ContactListVC",@"ClassZoneVC",@"PublishGrowthTimelineVC",@"TNBaseWebViewController"];
        self.titleArray = @[@"发布通知",@"聊天空间",@"班博客",@"家园手册",@"校主页"];
        self.imageArray = @[@"AppPublishNote",@"AppChat",@"AppClassZone",@"AppParent",@"AppSchoolHome"];
    }
    else
    {
        self.actionArray = @[@"ContactListVC",@"ClassZoneVC",@"PublishGrowthTimelineVC",@"TNBaseWebViewController"];
        self.titleArray = @[@"聊天空间",@"班博客",@"家园手册",@"校主页"];
        self.imageArray = @[@"AppChat",@"AppClassZone",@"AppParent",@"AppSchoolHome"];
    }
    //        self.actionArray = @[@"NotificationToAllVC",@"ContactListVC",@"ClassZoneVC",@"PublishGrowthTimelineVC",@"StudentAttendanceVC",@"MyAttendanceVC",@"HomeWordkVC",@"TNBaseWebViewController"];
    //        self.titleArray = @[@"发布通知",@"聊天空间",@"班博客",@"家园手册",@"学生考勤",@"我的考勤",@"作业练习",@"校主页"];
    //        self.imageArray = @[@"AppPublishNote",@"AppChat",@"AppClassZone",@"AppParent",@"AppStudentAttendance",@"AppMyAttendance",@"AppHomeWork",@"AppSchoolHome"];
    self.appItems = [NSMutableArray array];
    for (NSInteger i = 0; i < self.titleArray.count; i++)
    {
        ApplicationItem *item = [[ApplicationItem alloc] init];
        [item setImageStr:self.imageArray[i]];
        [item setTitle:self.titleArray[i]];
        [self.appItems addObject:item];
    }
    
    _layout = [[UICollectionViewFlowLayout alloc] init];
    [_layout setSectionInset:UIEdgeInsetsMake(15, 15, 15, 15)];
    NSInteger itemSize = (self.view.width - 15 * 2 - 10 * 2) / 3;
    [_layout setItemSize:CGSizeMake(itemSize, itemSize)];
    [_layout setMinimumLineSpacing:10];
    
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
    if([classStr isEqualToString:@"NotificationToAllVC"])
    {
        if(self.notificationVC == nil)
        {
            self.notificationVC = [[NotificationToAllVC alloc] init];
        }
        [CurrentROOTNavigationVC pushViewController:self.notificationVC animated:YES];
    }
    else if([classStr isEqualToString:@"PublishGrowthTimelineVC"])
    {
        if([UserCenter sharedInstance].curSchool.classes.count == 0)
        {
            ClassSelectionVC *selectionVC = [[ClassSelectionVC alloc] init];
            [selectionVC setSelection:^(ClassInfo *classInfo) {
                GrowthTimelineVC *growthTimelineVC = [[GrowthTimelineVC alloc] init];
                [growthTimelineVC setClassID:classInfo.classID];
                [growthTimelineVC setTitle:classInfo.className];
                [CurrentROOTNavigationVC pushViewController:growthTimelineVC animated:YES];
            }];
            [CurrentROOTNavigationVC pushViewController:selectionVC animated:YES];
        }
        else
        {
            PublishGrowthTimelineVC *publishGrowthTimelineVC = [[PublishGrowthTimelineVC alloc] init];
            [CurrentROOTNavigationVC pushViewController:publishGrowthTimelineVC animated:YES];
        }
    }
    else if([classStr isEqualToString:@"TNBaseWebViewController"])
    {
        TNBaseWebViewController *webVC = [[TNBaseWebViewController alloc] init];
        [webVC setUrl:[UserCenter sharedInstance].curSchool.schoolUrl];
        [CurrentROOTNavigationVC pushViewController:webVC animated:YES];
    }
    else
    {
        TNBaseViewController *vc = [[NSClassFromString(classStr) alloc] init];
        [CurrentROOTNavigationVC pushViewController:vc animated:YES];
    }
        
}
@end
