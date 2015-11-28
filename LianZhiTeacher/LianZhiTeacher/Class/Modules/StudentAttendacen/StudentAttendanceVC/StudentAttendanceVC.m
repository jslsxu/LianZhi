//
//  StudentAttendanceVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/7.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "StudentAttendanceVC.h"
#import "ClassSelectionVC.h"
#import "AttendanceOperationVC.h"
#import "LeaveRegisterVC.h"
@interface StudentAttendanceVC ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong)ClassInfo *curClass;
@end

@implementation StudentAttendanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.classInfo.className;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"切换" style:UIBarButtonItemStylePlain target:self action:@selector(onSwitchClass)];
    
    NSInteger itemWith = (self.view.width + 3) / 4;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(itemWith, itemWith)];
    [layout setMinimumInteritemSpacing:0];
    [layout setMinimumLineSpacing:0];
    [layout setHeaderReferenceSize:CGSizeMake(self.view.width, 140)];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake((self.view.width - itemWith * 4) / 2, 0, itemWith * 4, self.view.height - 64) collectionViewLayout:layout];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView setAlwaysBounceVertical:YES];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [_collectionView registerClass:[StudentAttendanceCell class] forCellWithReuseIdentifier:@"StudentAttendanceCell"];
    [_collectionView registerClass:[StudentAttendanceHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"StudentAttendanceHeaderView"];
    [self.view addSubview:_collectionView];
    
    NSArray *classes = [UserCenter sharedInstance].curSchool.classes;
    if(classes.count > 0)
        [self setCurClass:classes[0]];
}

- (void)onSwitchClass
{
    ClassSelectionVC *classSelectionVC = [[ClassSelectionVC alloc] init];
    [classSelectionVC setOriginalClassID:self.classInfo.classID];
    [classSelectionVC setSelection:^(ClassInfo *classInfo) {
        
    }];
    [self.navigationController pushViewController:classSelectionVC animated:YES];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    StudentAttendanceHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"StudentAttendanceHeaderView" forIndexPath:indexPath];
    return headerView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StudentAttendanceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StudentAttendanceCell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row > 5)
    {
        AttendanceOperationVC *attendanceOperationVC = [[AttendanceOperationVC alloc] init];
        [self.navigationController pushViewController:attendanceOperationVC animated:YES];
    }
    else
    {
        LeaveRegisterVC *leaveRegisterVC = [[LeaveRegisterVC alloc] init];
        [self.navigationController pushViewController:leaveRegisterVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
