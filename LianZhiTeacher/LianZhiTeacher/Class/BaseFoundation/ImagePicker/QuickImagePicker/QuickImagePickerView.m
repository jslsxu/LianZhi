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
        [_stateButton setImage:[UIImage imageNamed:@"photo_state_normal"] forState:UIControlStateNormal];
        [_stateButton setImage:[UIImage imageNamed:@"photo_state_selected"] forState:UIControlStateSelected];
        [_stateButton addTarget:self action:@selector(onSelectButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_stateButton];
        
        _typeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_type_white"]];
        [_typeImageView setOrigin:CGPointMake(5, self.height - 5 - _typeImageView.height)];
        [self addSubview:_typeImageView];
    }
    return self;
}

- (void)setAsset:(XMNAssetModel *)asset{
    _asset = asset;
    [_imageView setImage:_asset.previewImage];
    [_stateButton setSelected:_asset.selected];
    [_typeImageView setHidden:_asset.type != XMNAssetTypeVideo];
}

- (void)onSelectButtonClicked{
    if(self.selectButtonClickedBlk){
        self.selectButtonClickedBlk();
    }
}

@end

@interface QuickImagePickerView ()
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

- (instancetype)initWithMaxImageCount:(NSInteger)imageCount videoCount:(NSInteger)videoCount{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kPhotoCollectionViewHeight + kPhotoToolBarHeight)];
    if(self){
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
        [_sendButton addTarget:self action:@selector(onSendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
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
                [[XMNPhotoManager sharedManager] getAssetsFromResult:[[albums firstObject] fetchResult] pickingVideoEnable:YES completionBlock:^(NSArray<XMNAssetModel *> *assets) {
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

- (void)onSendButtonClicked{
    if(self.sendCallback){
        self.sendCallback(self.selectedAssets, self.originalSelected);
    }
}

- (void)handleStateButtonAction:(XMNPhotoPickerCell *)cell{
    UIButton *button = cell.stateButton;
    XMNAssetModel *assetModel = cell.asset;
    if (!assetModel.selected) {
//        for (XMNAssetModel *model in self.selectedAssets) {
//            if(model.type != assetModel.type){
//                [ProgressHUD showHintText:@"不能同时选择照片和视频"];
//                return;
//            }
//            else if(model.type == XMNAssetTypeVideo){
//                [ProgressHUD showHintText:@"一次只能发送1个视频"];
//                return;
//            }
//        }
        
        if(assetModel.type == XMNAssetTypeVideo){
            NSInteger videoCount = 0;
            for (XMNAssetModel *model in self.selectedAssets) {
                if(model.type == XMNAssetTypeVideo){
                    videoCount ++;
                }
            }
            if(videoCount < self.maxVideoCount){
                [UIView animationWithLayer:button.layer type:XMNAnimationTypeBigger];
                assetModel.selected = YES;
                [self.selectedAssets addObject:assetModel];
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

@end
