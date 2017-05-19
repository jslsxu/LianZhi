//
//  PhotoPickerVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/2/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "PhotoPickerVC.h"

@interface PhotoPickerVC()

@property (nonatomic, assign)BOOL albumShown;
@end

@implementation PhotoPickerVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [self setCellName:@"PhotoPickerCell"];
        [self setModelName:@"PhotoPickerModel"];
    }
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%ld张",(long)_selectedArray.count] style:UIBarButtonItemStylePlain target:nil action:nil];
    _photoArray = [[NSMutableArray alloc] initWithCapacity:0];
    if(_selectedArray == nil)
        _selectedArray = [[NSMutableArray alloc] initWithCapacity:0];
    
//    [self setSupportPullDown:YES];
//    [self setSupportPullUp:YES];
//    [self requestData:REQUEST_REFRESH];
}

- (void)setupSubviews
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 60, self.view.width, 60)];
    [bottomView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
    [self.view addSubview:bottomView];
    
    _albumSelectedView = [[UIView alloc] initWithFrame:CGRectMake(10, (bottomView.height - 40) / 2, 120, 40)];
    [bottomView addSubview:_albumSelectedView];
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmButton setFrame:CGRectMake(bottomView.width - 100 - 15, (bottomView.height - 40) / 2, 100, 40)];
    [_confirmButton setBackgroundImage:[UIImage imageWithColor:kCommonParentTintColor size:_confirmButton.size cornerRadius:5] forState:UIControlStateNormal];
    [_confirmButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"E0E0E0"] size:_confirmButton.size cornerRadius:5] forState:UIControlStateDisabled];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmButton setEnabled:NO];
    [_confirmButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_confirmButton setTitle:@"完成" forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(onConfirm) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_confirmButton];
    
    _coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_coverButton setFrame:CGRectMake(0, 0, self.view.width, self.view.height - bottomView.height)];
    [_coverButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [_coverButton setAlpha:0.f];
    [_coverButton setClipsToBounds:YES];
    [_coverButton addTarget:self action:@selector(onAlbumCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_coverButton];
    
    CGFloat groupHeight = self.view.width;
    _groupView = [[AlbumGroupView alloc] initWithFrame:CGRectMake(0, _coverButton.height, self.view.width, groupHeight)];
    [_groupView setDelegate:self];
    [_coverButton addSubview:_groupView];
}

- (void)setupAlbumButtonWithTitle:(NSString *)title
{
    [_albumSelectedView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _arrow = nil;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setFont:[UIFont systemFontOfSize:16]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:title];
    [titleLabel sizeToFit];
    [_albumSelectedView addSubview:titleLabel];

    _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_albumShown ? @"DownArrow.png" : @"UpArrow.png"]];
    [_albumSelectedView addSubview:_arrow];
    
    CGFloat width = titleLabel.width + _arrow.width + 2;
    [titleLabel setOrigin:CGPointMake((_albumSelectedView.width - width) / 2, (_albumSelectedView.height - titleLabel.height) / 2)];
    [_arrow setOrigin:CGPointMake(titleLabel.right + 2, (_albumSelectedView.height - _arrow.height) / 2)];
    
    UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [coverButton addTarget:self action:@selector(onChangeAlbum) forControlEvents:UIControlEventTouchUpInside];
    [coverButton setFrame:_albumSelectedView.bounds];
    [_albumSelectedView addSubview:coverButton];
}

//- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
//{
//    HttpRequestTask *task = [[HttpRequestTask alloc] init];
//    [task setRequestUrl:@"tree/album"];
//    [task setRequestMethod:REQUEST_GET];
//    [task setRequestType:requestType];
//    [task setObserver:self];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:@(20) forKey:@"num"];
//    [params setValue:@(requestType == REQUEST_REFRESH ? 0 : self.collectionViewModel.modelItemArray.count) forKey:@"start"];
//    [task setParams:params];
//    return task;
//}
//
//- (BOOL)supportCache
//{
//    return YES;
//}
//
//- (NSString *)cacheFileName
//{
//    return [NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),[UserCenter sharedInstance].curChild.uid];
//}

- (void)onCancel
{
    if([self.delegate respondsToSelector:@selector(photoPickerVCDidCancel:)])
        [self.delegate photoPickerVCDidCancel:self];
}

- (void)onChangeAlbum
{
    [self setAlbumShown:!_albumShown];
}

- (void)onAlbumCancel
{
    [self setAlbumShown:NO];
}

- (void)setAlbumShown:(BOOL)albumShown
{
    _albumShown = albumShown;
    [_arrow setImage:[UIImage imageNamed:_albumShown ? @"DownArrow.png" : @"UpArrow.png"]];
    if(_albumShown)
    {
//        [_groupView reloadData];
        [UIView animateWithDuration:0.3 animations:^{
            [_coverButton setAlpha:1.f];
            [_groupView setY:_coverButton.height - _groupView.height];
        } completion:^(BOOL finished) {
            
        }];
    }
    else
        [UIView animateWithDuration:0.3 animations:^{
            [_coverButton setAlpha:0.f];
            [_groupView setY:_coverButton.height];
        } completion:^(BOOL finished) {
            
        }];
}

- (void)onConfirm
{
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在处理" toView:[UIApplication sharedApplication].keyWindow];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (PhotoPickerItem *item in _selectedArray) {
            @autoreleasepool {
                PublishImageItem *publishItem = [[PublishImageItem alloc] init];
                PhotoItem *photoItem = item.photoItem;
                ALAsset *asset = item.asset;
                if(photoItem)
                {
                    [publishItem setThumbnailUrl:photoItem.small];
                    [publishItem setOriginalUrl:photoItem.big];
                    [publishItem setPhotoID:photoItem.photoID];
                }
                else if(asset)
                {
                    [publishItem setImage:[UIImage formatAsset:asset]];
                }
                [resultArray addObject:publishItem];

            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:NO];
            if([self.delegate respondsToSelector:@selector(photoPickerVC:didFinished:)])
                [self.delegate photoPickerVC:self didFinished:resultArray];
        });
    });

}

#pragma mark - TNBaseCollectionViewDelegate
- (void)TNBaseTableViewControllerRequestSuccess
{
    PhotoPickerModel *model = (PhotoPickerModel *)self.collectionViewModel;
    TNModelItem *modelItem = [model.modelItemArray firstObject];
    PhotoPickerItem *pickerItem = (PhotoPickerItem *)modelItem;
    [_groupView setIconUrl:pickerItem.photoItem.small];
    [_groupView setTotal:model.total];
}

#pragma mark - AlbumGroupDelegate
- (void)albumGroupViewSelectedSystemAlbum:(ALAssetsGroup *)group
{
    [self setupAlbumButtonWithTitle:[group valueForProperty:ALAssetsGroupPropertyName]];
    [self cancelRequest];
    [self setSupportPullDown:NO];
    [self setSupportPullUp:NO];
    [self setAlbumShown:NO];
    [self.collectionViewModel.modelItemArray removeAllObjects];
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop)
    {
        if (asset)
        {
            PhotoPickerItem *item = [[PhotoPickerItem alloc] init];
            [item setAsset:asset];
            [self.collectionViewModel.modelItemArray insertObject:item atIndex:0];
        }
        else
        {
            [_collectionView reloadData];
        }
    };
    
    [group enumerateAssetsUsingBlock:resultsBlock];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoPickerItem *item = [self.collectionViewModel.modelItemArray objectAtIndex:indexPath.row];
    if(item.photoItem)
    {
        return CGSizeMake(147, item.photoItem.height * 147 / item.photoItem.width);
    }
    else
    {
        ALAsset *asset = item.asset;
        CGSize assetSize = [asset defaultRepresentation].dimensions;
        return CGSizeMake(147, assetSize.height * 147 / assetSize.width);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger num = [self.collectionViewModel modelItemArray].count;
    [self.navigationItem.rightBarButtonItem setTitle:[NSString stringWithFormat:@"%ld张",(long)_selectedArray.count]];
    return num;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoPickerCell" forIndexPath:indexPath];
    PhotoPickerItem *pickerItem = [self.collectionViewModel.modelItemArray objectAtIndex:indexPath.row];
    [pickerItem setSelected:([self itemSelected:pickerItem] != nil)];
    [cell setItem:pickerItem];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoPickerItem *pickerItem = [self.collectionViewModel.modelItemArray objectAtIndex:indexPath.row];
    if(!pickerItem.selected && _selectedArray.count >= self.maxToSelected)
        [ProgressHUD showHintText:[NSString stringWithFormat:@"最多只能选择%ld张",(long)self.maxToSelected]];
    else
    {
        [pickerItem setSelected:!pickerItem.selected];
        if(pickerItem.selected)
        {
            [_selectedArray addObject:pickerItem];
        }
        else
            [_selectedArray removeObject:[self itemSelected:pickerItem]];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%ld张",(long)_selectedArray.count] style:UIBarButtonItemStylePlain target:nil action:nil];
        [_confirmButton setEnabled:_selectedArray.count > 0];
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

- (PhotoPickerItem *)itemSelected:(PhotoPickerItem *)item
{
    for (PhotoPickerItem *photoItem in _selectedArray) {
        if([photoItem isEqualTo:item])
            return photoItem;
    }
    return nil;
}
@end
