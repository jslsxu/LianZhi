//
//  PhotoFlowVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/22.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PhotoFlowVC.h"
#import "PhotoFlowHeaderView.h"
@implementation PhotoFlowVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [self setCellName:@"PhotoFlowCell"];
        [self setModelName:@"PhotoFlowModel"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_collectionView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"相册";
    [self setSupportPullDown:YES];
    [self setSupportPullUp:YES];
    [self.collectionView registerClass:[PhotoFlowHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PhotoFlowHeaderView"];
    [self requestData:REQUEST_REFRESH];
    
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"tree/album"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    [task setObserver:self];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.classID forKey:@"class_id"];
    [params setValue:@"40" forKey:@"num"];
    if(requestType == REQUEST_REFRESH)
        [params setValue:@"0" forKey:@"start"];
    else
        [params setValue:kStringFromValue(self.collectionViewModel.modelItemArray.count) forKey:@"start"];
    [task setParams:params];
    return task;
}

- (void)TNBaseCollectionViewControllerModifyLayout:(UICollectionViewFlowLayout *)layout
{
    CGFloat innerMargin = 4;
    NSInteger itemWidth = (self.view.width - innerMargin * 3) / 4;
    innerMargin = (self.view.width - itemWidth * 4) / 3;
    layout.minimumLineSpacing = innerMargin;
    layout.minimumInteritemSpacing = innerMargin;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
}

- (void)TNBaseTableViewControllerRequestSuccess
{
    PhotoFlowModel *flowModel = (PhotoFlowModel *)self.collectionViewModel;
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%ld张",(long)flowModel.total] style:UIBarButtonItemStylePlain target:nil action:nil]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    PhotoFlowModel *flowModel = (PhotoFlowModel *)self.collectionViewModel;
    BOOL showYear = [flowModel showYearForSection:section];
    return CGSizeMake(collectionView.width, showYear ? kYearHeight + kDayHeight : kDayHeight);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        PhotoFlowHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PhotoFlowHeaderView" forIndexPath:indexPath];
        NSString* headerTitle = [self.collectionViewModel dataOfHeaderForSection:indexPath.section];
        PhotoFlowModel *flowModel = (PhotoFlowModel *)self.collectionViewModel;
        BOOL showYear = [flowModel showYearForSection:indexPath.section];
        NSString* titleYear = [headerTitle substringToIndex:4];
        NSString* yearStr = [NSString stringWithFormat:@"%@年", titleYear];
        [headerView setYear:showYear ? yearStr : nil];
        NSInteger currentYear = [[NSDate date] year];
        NSString* dateStr = [headerTitle substringWithRange:NSMakeRange(5, 5)];
        NSString* monthStr = [dateStr substringToIndex:2];
        NSString* dayStr = [dateStr substringFromIndex:3];
        NSString* showDayStr = [NSString stringWithFormat:@"%@%zd月%zd日", yearStr, [monthStr integerValue], [dayStr integerValue]];
        if(currentYear == [yearStr integerValue]){
            showDayStr = [NSString stringWithFormat:@"%zd月%zd日", [monthStr integerValue], [dayStr integerValue]];
        }
        [headerView setDay:showDayStr];
        return headerView;
    }
    return nil;
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath
{
    NSInteger index = [self.collectionViewModel.modelItemArray indexOfObject:modelItem];
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    [browser setPhotos:self.collectionViewModel.modelItemArray];
    [browser setCurrentPhotoIndex:index];
    [browser setClassID:self.classID];
    [browser setDeleteCallBack:^(NSInteger num) {
        PhotoFlowModel *flowModel = (PhotoFlowModel *)self.collectionViewModel;
        flowModel.total -= num;
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%ld张",(long)flowModel.total] style:UIBarButtonItemStylePlain target:nil action:nil]];
    }];
    [self.navigationController pushViewController:browser animated:YES];
}

@end
