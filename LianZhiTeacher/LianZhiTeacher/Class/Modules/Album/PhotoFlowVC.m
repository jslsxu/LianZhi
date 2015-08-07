//
//  PhotoFlowVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/22.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PhotoFlowVC.h"

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
    
    [self requestData:REQUEST_REFRESH];
    
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"class/album"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    [task setObserver:self];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setValue:@"20" forKey:@"num"];
    if(requestType == REQUEST_REFRESH)
        [params setValue:@"0" forKey:@"start"];
    else
        [params setValue:kStringFromValue(self.collectionViewModel.modelItemArray.count) forKey:@"start"];
    [params setValue:self.classID forKey:@"class_id"];
    [task setParams:params];
    return task;
}

- (BOOL)supportCache
{
    return YES;
}

- (NSString *)cacheFileName
{
    return [NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),self.classID];
}

- (void)TNBaseCollectionViewControllerModifyLayout:(UICollectionViewFlowLayout *)layout
{
    CHTCollectionViewWaterfallLayout *waterfallLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
    waterfallLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    waterfallLayout.columnCount = 2;
    waterfallLayout.headerHeight = 5;
    waterfallLayout.footerHeight = 5;
    waterfallLayout.minimumColumnSpacing = 6;
    waterfallLayout.minimumInteritemSpacing = 6;
    _layout = waterfallLayout;
}

- (void)TNBaseTableViewControllerRequestSuccess
{
    PhotoFlowModel *flowModel = (PhotoFlowModel *)self.collectionViewModel;
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%ld张",(long)flowModel.total] style:UIBarButtonItemStylePlain target:nil action:nil]];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoItem *item = [[self.collectionViewModel modelItemArray] objectAtIndex:indexPath.row];
    
    return CGSizeMake(147, item.height * 147 / item.width);
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
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
