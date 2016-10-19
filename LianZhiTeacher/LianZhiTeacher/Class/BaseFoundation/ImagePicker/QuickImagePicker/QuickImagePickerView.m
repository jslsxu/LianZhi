//
//  QuickImagePickerView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/7.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "QuickImagePickerView.h"
#import "UIView+Animations.h"
#import "ProgressHUD.h"
#import "DNImagePickerController.h"
#import "DNPhotoBrowser.h"
#define kPhotoCollectionViewHeight              116
#define kPhotoToolBarHeight                     44

@implementation XMNPhotoPickerCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_imageView setBackgroundColor:[UIColor darkGrayColor]];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        [_imageView setClipsToBounds:YES];
        [self addSubview:_imageView];
        
        _stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stateButton setFrame:CGRectMake(self.width - 30, 0, 30, 30)];
        [_stateButton setImage:[UIImage imageNamed:@"photo_check_default"] forState:UIControlStateNormal];
        [_stateButton setImage:[UIImage imageNamed:@"photo_check_selected"] forState:UIControlStateSelected];
        [_stateButton addTarget:self action:@selector(onSelectButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_stateButton];
        
        _typeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_type_white"]];
        [_typeImageView setOrigin:CGPointMake(5, self.height - 5 - _typeImageView.height)];
        [self addSubview:_typeImageView];
        
        _durationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_durationLabel setBackgroundColor:[UIColor clearColor]];
        [_durationLabel setFont:[UIFont systemFontOfSize:13]];
        [_durationLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_durationLabel];
    }
    return self;
}

- (void)setAsset:(XMNAssetModel *)asset{
    _asset = asset;
    __block UIImage *image = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ALAsset *alAsset = asset.asset;
        image = [UIImage imageWithCGImage:[alAsset.defaultRepresentation fullScreenImage] scale:1.f orientation:UIImageOrientationUp];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_imageView setImage:image];
        });
    });
    [_stateButton setSelected:_asset.selected];
    BOOL isVideo = _asset.type == XMNAssetTypeVideo;
    [_typeImageView setHidden:!isVideo];
    [_durationLabel setHidden:!isVideo];
    NSInteger duration = [[[asset asset] valueForProperty:ALAssetPropertyDuration] integerValue];
    [_durationLabel setText:[Utility durationText:duration]];
    [_durationLabel sizeToFit];
    [_durationLabel setOrigin:CGPointMake(self.width - _durationLabel.width - 3, self.height - _durationLabel.height - 5)];
}

- (void)onSelectButtonClicked{
    if(self.selectButtonClickedBlk){
        self.selectButtonClickedBlk();
    }
}

@end

@interface QuickImagePickerView ()<DNPhotoBrowserDelegate>
@property (nonatomic, assign)BOOL videoEnabled;
@property (nonatomic, strong) XMNAlbumModel*    displayAlbum;
@property (nonatomic, copy) NSArray <XMNAssetModel *>* assets;
@property (nonatomic, strong) NSMutableArray <XMNAssetModel *> *selectedAssets;
@property (nonatomic, assign) BOOL  originalSelected;

@property (nonatomic, strong)UICollectionView*  collectionView;
@property (nonatomic, strong)UIView*            toolBar;
@property (nonatomic, strong)UIButton*          albumButton;
@property (nonatomic, strong)UIButton*          originalImageButton;
@property (nonatomic, strong)UIButton*          sendButton;
@end

@implementation QuickImagePickerView

- (instancetype)initWithMaxImageCount:(NSInteger)imageCount videoCount:(NSInteger)videoCount videoEnabled:(BOOL)videoEnabled{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kPhotoCollectionViewHeight + kPhotoToolBarHeight)];
    if(self){
        self.videoEnabled = videoEnabled;
        self.maxPreviewCount = 40;
        self.maxImageCount = MIN(self.maxPreviewCount, imageCount);
        self.maxVideoCount = videoCount;
        [self addSubview:self.collectionView];
        [self addSubview:self.toolBar];
        self.selectedAssets = [NSMutableArray array];
        [self loadData];
    }
    return self;
}

- (UICollectionView *)collectionView{
    if(_collectionView == nil){
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [flowLayout setItemSize:CGSizeMake(kPhotoCollectionViewHeight - 5 * 2, kPhotoCollectionViewHeight - 5 * 2)];
        [flowLayout setMinimumInteritemSpacing:5];
        [flowLayout setMinimumLineSpacing:5];
        [flowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, kPhotoCollectionViewHeight) collectionViewLayout:flowLayout];
        [_collectionView registerClass:[XMNPhotoPickerCell class] forCellWithReuseIdentifier:@"XMNPhotoPickerCell"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
    }
    return _collectionView;
}

- (UIView *)toolBar{
    if(_toolBar == nil){
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kPhotoCollectionViewHeight, self.width, kPhotoToolBarHeight)];
        
        _albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_albumButton setFrame:CGRectMake(0, 0, 60, _toolBar.height)];
        [_albumButton setTitle:@"相册" forState:UIControlStateNormal];
        [_albumButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateNormal];
        [_albumButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_albumButton addTarget:self action:@selector(onAlbumButonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_toolBar addSubview:_albumButton];
        
    
//        _originalImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_originalImageButton setFrame:CGRectMake(_albumButton.right, 0, 80, _toolBar.height)];
//        [_originalImageButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
//        [_originalImageButton setImage:[UIImage imageNamed:@"bottom_origin_normal"] forState:UIControlStateNormal];
//        [_originalImageButton setImage:[UIImage imageNamed:@"bottom_origin_normal"] forState:UIControlStateHighlighted];
//        [_originalImageButton setTitle:@"原图" forState:UIControlStateNormal];
//        [_originalImageButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateNormal];
//        [_originalImageButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
//        [_originalImageButton addTarget:self action:@selector(onOriginalImageButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//        [_toolBar addSubview:_originalImageButton];
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setFrame:CGRectMake(_toolBar.width - 10 - 60, (_toolBar.height - 30) / 2, 60, 30)];
        [_sendButton setBackgroundImage:[UIImage imageWithColor:kCommonTeacherTintColor size:_sendButton.size cornerRadius:3] forState:UIControlStateNormal];
        [_sendButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor] size:_sendButton.size cornerRadius:3] forState:UIControlStateDisabled];
        [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendImages) forControlEvents:UIControlEventTouchUpInside];
        [_toolBar addSubview:_sendButton];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _toolBar.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [_toolBar addSubview:sepLine];
    }
    return _toolBar;
}

- (void)loadData{
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[XMNPhotoManager sharedManager] getAlbumsPickingVideoEnable:YES completionBlock:^(NSArray<XMNAlbumModel *> *albums) {
            
            if (albums && [albums firstObject]) {
                wSelf.displayAlbum = [albums firstObject];
                [[XMNPhotoManager sharedManager] getAssetsFromResult:[[albums firstObject] fetchResult] pickingVideoEnable:self.videoEnabled completionBlock:^(NSArray<XMNAssetModel *> *assets) {
                    NSMutableArray *tempAssets = [NSMutableArray array];
                    [assets enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(XMNAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [tempAssets addObject:obj];
                        *stop = (tempAssets.count > wSelf.maxPreviewCount);
                    }];
                    wSelf.assets = [NSArray arrayWithArray:tempAssets];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [wSelf.collectionView reloadData];
                    });
                }];
            }
        }];
    });
}

#pragma actions
- (void)onAlbumButonClicked{
    if(self.onClickAlbum){
        self.onClickAlbum();
    }
}

- (void)onOriginalImageButtonClicked{
    self.originalSelected = !self.originalSelected;
    UIImage *image = [UIImage imageNamed:self.originalSelected ? @"bottom_origin_selected" : @"bottom_origin_normal"];
    [_originalImageButton setImage:image forState:UIControlStateNormal];
    [_originalImageButton setImage:image forState:UIControlStateHighlighted];
}

- (void)sendImages{
    if(self.sendCallback){
        self.sendCallback(self.selectedAssets, self.originalSelected);
    }
}

- (void)handleStateButtonAction:(XMNPhotoPickerCell *)cell{
    UIButton *button = cell.stateButton;
    XMNAssetModel *assetModel = cell.asset;
    if (!assetModel.selected) {
        if(assetModel.type == XMNAssetTypeVideo){
            NSInteger videoCount = 0;
            for (XMNAssetModel *model in self.selectedAssets) {
                if(model.type == XMNAssetTypeVideo){
                    videoCount ++;
                }
            }
            if(videoCount < self.maxVideoCount){
                if([Utility checkVideo:assetModel.asset]){
                    [UIView animationWithLayer:button.layer type:XMNAnimationTypeBigger];
                    assetModel.selected = YES;
                    [self.selectedAssets addObject:assetModel];
                }
            }
            else{
                [ProgressHUD showHintText:@"一次只能发送1个视频"];
            }
        }
        else{
            NSInteger imageCount = 0;
            for (XMNAssetModel *model in self.selectedAssets) {
                if(model.type == XMNAssetTypePhoto){
                    imageCount ++;
                }
            }

            if(imageCount >= self.maxImageCount){
                [ProgressHUD showHintText:@"不能超过9张图"];
            }
            else{
                [UIView animationWithLayer:button.layer type:XMNAnimationTypeBigger];
                assetModel.selected = YES;
                [self.selectedAssets addObject:assetModel];
            }
        }
    }
    else {
        
        assetModel.selected = NO;
        [self.selectedAssets removeObject:assetModel];
    }
    button.selected = assetModel.selected;
    NSInteger selectCount = self.selectedAssets.count;
    if(selectCount > 0){
        [_sendButton setEnabled:YES];
        [_sendButton setTitle:[NSString stringWithFormat:@"确定(%zd)",selectCount] forState:UIControlStateNormal];
    }
    else{
        [_sendButton setEnabled:NO];
        [_sendButton setTitle:@"确定" forState:UIControlStateNormal];
    }
}

- (void)updateStatus{
    NSInteger selectCount = self.selectedAssets.count;
    if(selectCount > 0){
        [_sendButton setEnabled:YES];
        [_sendButton setTitle:[NSString stringWithFormat:@"确定(%zd)",selectCount] forState:UIControlStateNormal];
    }
    else{
        [_sendButton setEnabled:NO];
        [_sendButton setTitle:@"确定" forState:UIControlStateNormal];
    }
}

- (BOOL)selectAsset:(XMNAssetModel *)asset{
    if(asset.type == XMNAssetTypeVideo){
        NSInteger videoCount = [self selectedVideoNum];
        if(videoCount < self.maxVideoCount){
            if([Utility checkVideo:asset.asset]){
                asset.selected = YES;
                [self.selectedAssets addObject:asset];
            }
            else{
                return NO;
            }
        }
        else{
            [ProgressHUD showHintText:@"一次只能发送1个视频"];
            return NO;
        }
    }
    else{
        NSInteger imageCount = [self selectedImageNum];
        if(imageCount >= self.maxImageCount){
            [ProgressHUD showHintText:@"不能超过9张图"];
            return NO;
        }
        else{
            asset.selected = YES;
            [self.selectedAssets addObject:asset];
        }
    }
    [self updateStatus];
    return YES;
}

- (void)deselectAsset:(XMNAssetModel *)asset{
    asset.selected = NO;
    [self.selectedAssets removeObject:asset];
    [self updateStatus];
}

- (BOOL)assetIsSelected:(XMNAssetModel *)asset{
    for (XMNAssetModel *model in self.selectedAssets) {
        if(model == asset){
            return YES;
        }
    }
    return NO;
}

- (NSInteger)selectedImageNum{
    NSInteger imageCount = 0;
    for (XMNAssetModel *asset in self.selectedAssets) {
        if(asset.type == XMNAssetTypePhoto){
            imageCount ++;
        }
    }
    return imageCount;
}

- (NSInteger)selectedVideoNum{
    NSInteger videoCount = 0;
    for (XMNAssetModel *asset in self.selectedAssets) {
        if(asset.type == XMNAssetTypeVideo){
            videoCount++;
        }
    }
    return videoCount;
}

- (BOOL)canSelectAsset:(XMNAssetModel *)asset{
    if ([self assetIsSelected:asset]) {
        return NO;
    }
    if(asset.type == XMNAssetTypePhoto){
        if([self selectedImageNum] >= self.maxImageCount){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能超过9张图片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            return NO;
        }
    }
    else{
        if([self selectedVideoNum] >= self.maxVideoCount){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多只能选1个视频" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            return NO;
        }
        else{
            return [Utility checkVideo:asset.asset];
        }
        
    }
    return YES;

}

- (XMNAssetModel *)modelForAsset:(ALAsset *)asset{
    NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
    for (XMNAssetModel *model in self.assets) {
        NSURL *targetAssetURL = [model.asset valueForProperty:ALAssetPropertyAssetURL];
        if([targetAssetURL.absoluteString isEqualToString:assetURL.absoluteString]){
            return model;
        }
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XMNAssetModel *assetItem = self.assets[indexPath.row];
    XMNPhotoPickerCell *pickerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XMNPhotoPickerCell" forIndexPath:indexPath];
    [pickerCell setAsset:assetItem];
    __weak typeof(self) wself = self;
    __weak XMNPhotoPickerCell* wCell = pickerCell;
    [pickerCell setSelectButtonClickedBlk:^{
        [wself handleStateButtonAction:wCell];
    }];
    return pickerCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *assetArray = [NSMutableArray array];
    for (XMNAssetModel *assetModel in self.assets) {
        ALAsset *asset = assetModel.asset;
        [assetArray addObject:asset];
    }
    DNPhotoBrowser *photoBrowser = [[DNPhotoBrowser alloc] initWithPhotos:assetArray currentIndex:indexPath.row fullImage:NO];
    [photoBrowser setDelegate:self];
    [CurrentROOTNavigationVC pushViewController:photoBrowser animated:YES];
}

#pragma mark - DNPhotoBrowserDelegate
- (void)sendImagesFromPhotobrowser:(DNPhotoBrowser *)photoBrowser currentAsset:(ALAsset *)asset
{
    if(self.selectedAssets.count > 0){
        [self sendImages];
        [CurrentROOTNavigationVC popViewControllerAnimated:YES];
    }
    else{
        XMNAssetModel *model = [self modelForAsset:asset];
        BOOL selected = [self canSelectAsset:model];
        if(selected){
            [self selectAsset:model];
            [self sendImages];
            [CurrentROOTNavigationVC popViewControllerAnimated:YES];
        }
    }
//    NSInteger maxCount = 0;
//    XMNAssetModel *model = [self modelForAsset:asset];
//    if(model.type == XMNAssetTypePhoto){
//        maxCount = self.maxImageCount;
//    }
//    else if(model.type == XMNAssetTypeVideo){
//        maxCount = self.maxVideoCount;
//    }
//    if (self.selectedAssets.count < maxCount) {
//        [self selectAsset:model];
//        [self.collectionView reloadData];
//    }
//    [self sendImages];
}

- (NSUInteger)seletedPhotosNumberInPhotoBrowser:(DNPhotoBrowser *)photoBrowser
{
    return self.selectedAssets.count;
}

- (BOOL)photoBrowser:(DNPhotoBrowser *)photoBrowser currentPhotoAssetIsSeleted:(ALAsset *)asset{
    return [self assetIsSelected:[self modelForAsset:asset]];
}

- (BOOL)photoBrowser:(DNPhotoBrowser *)photoBrowser seletedAsset:(ALAsset *)asset
{
    BOOL seleted = [self selectAsset:[self modelForAsset:asset]];
    [self.collectionView reloadData];
    return seleted;
}

- (void)photoBrowser:(DNPhotoBrowser *)photoBrowser deseletedAsset:(ALAsset *)asset
{
    [self deselectAsset:[self modelForAsset:asset]];
    [self.collectionView reloadData];
}

- (void)photoBrowser:(DNPhotoBrowser *)photoBrowser seleteFullImage:(BOOL)fullImage
{
    self.originalSelected = fullImage;
}

@end
