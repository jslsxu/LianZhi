//
//  QuickImagePickerView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/7.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "QuickImagePickerView.h"
#import "XMNPhotoManager.h"
#import "XMNPhotoStickLayout.h"
#import "UIView+Animations.h"
#import "DNImagePickerController.h"
#define kPhotoCollectionViewHeight              180
#define kPhotoToolBarHeight                     44

@implementation XMNPhotoPickerCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_imageView setBackgroundColor:[UIColor darkGrayColor]];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}

@end

@interface XMNPhotoPickerReusableView : UICollectionReusableView

@property (nonatomic, weak)   UIButton *button;

@end


@implementation XMNPhotoPickerReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"photo_state_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"photo_state_selected"] forState:UIControlStateSelected];
        [button sizeToFit];
        [self addSubview:self.button = button];
    }
    return self;
}

@end

@interface QuickImagePickerView ()
@property (nonatomic, strong) XMNAlbumModel*    displayAlbum;
@property (nonatomic, copy) NSArray <XMNAssetModel *>* assets;
@property (nonatomic, strong) NSMutableArray <XMNAssetModel *> *selectedAssets;
@property (nonatomic, assign) BOOL  originalSelected;

@property (nonatomic, strong)UICollectionView*  collectionView;
@property (nonatomic, strong)UIToolbar*         toolBar;
@property (nonatomic, strong)UIButton*          albumButton;
@property (nonatomic, strong)UIButton*          originalImageButton;
@property (nonatomic, strong)UIButton*          sendButton;
@end

@implementation QuickImagePickerView

- (instancetype)initWithMaxCount:(NSInteger)count{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kPhotoCollectionViewHeight + kPhotoToolBarHeight)];
    if(self){
        self.maxPreviewCount = 20;
        self.maxCount = MIN(self.maxPreviewCount, count);
        [self addSubview:self.collectionView];
        [self addSubview:self.toolBar];
        self.selectedAssets = [NSMutableArray array];
        [self loadData];
    }
    return self;
}

- (UICollectionView *)collectionView{
    if(_collectionView == nil){
        XMNPhotoStickLayout *stickLayout = [[XMNPhotoStickLayout alloc] init];
        stickLayout.headerReferenceSize = CGSizeMake(30, 30);
        stickLayout.minimumLineSpacing = 5.0f;
        stickLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, kPhotoCollectionViewHeight) collectionViewLayout:stickLayout];
        [_collectionView registerClass:[XMNPhotoPickerCell class] forCellWithReuseIdentifier:@"XMNPhotoPickerCell"];
        [_collectionView registerClass:[XMNPhotoPickerReusableView class] forSupplementaryViewOfKind:kXMNStickSupplementaryViewKind withReuseIdentifier:@"XMNPhotoPickerReusableView"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
    }
    return _collectionView;
}

- (UIToolbar *)toolBar{
    if(_toolBar == nil){
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kPhotoCollectionViewHeight, self.width, kPhotoToolBarHeight)];
        
        _albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_albumButton setFrame:CGRectMake(0, 0, 60, _toolBar.height)];
        [_albumButton setTitle:@"相册" forState:UIControlStateNormal];
        [_albumButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateNormal];
        [_albumButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_albumButton addTarget:self action:@selector(onAlbumButonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_toolBar addSubview:_albumButton];
        
    
        _originalImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_originalImageButton setFrame:CGRectMake(_albumButton.right, 0, 80, _toolBar.height)];
        [_originalImageButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        [_originalImageButton setImage:[UIImage imageNamed:@"bottom_origin_normal"] forState:UIControlStateNormal];
        [_originalImageButton setImage:[UIImage imageNamed:@"bottom_origin_normal"] forState:UIControlStateHighlighted];
        [_originalImageButton setTitle:@"原图" forState:UIControlStateNormal];
        [_originalImageButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateNormal];
        [_originalImageButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_originalImageButton addTarget:self action:@selector(onOriginalImageButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_toolBar addSubview:_originalImageButton];
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setFrame:CGRectMake(_toolBar.width - 10 - 60, (_toolBar.height - 30) / 2, 60, 30)];
        [_sendButton setBackgroundImage:[UIImage imageWithColor:kCommonTeacherTintColor size:_sendButton.size cornerRadius:3] forState:UIControlStateNormal];
        [_sendButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor] size:_sendButton.size cornerRadius:3] forState:UIControlStateDisabled];
        [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(onSendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_toolBar addSubview:_sendButton];
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
                        [(XMNPhotoStickLayout *)wSelf.collectionView.collectionViewLayout updateAllAttributes];
                    });
                }];
            }
        }];
    });
}

#pragma actions
- (void)onAlbumButonClicked{
    DNImagePickerController *imagePicker = [[DNImagePickerController alloc] init];
    [CurrentROOTNavigationVC presentViewController:imagePicker animated:YES completion:nil];
}

- (void)onOriginalImageButtonClicked{
    self.originalSelected = !self.originalSelected;
    UIImage *image = [UIImage imageNamed:self.originalSelected ? @"bottom_origin_selected" : @"bottom_origin_normal"];
    [_originalImageButton setImage:image forState:UIControlStateNormal];
    [_originalImageButton setImage:image forState:UIControlStateHighlighted];
}

- (void)onSendButtonClicked{
    
}

- (void)handleStateButtonAction:(UIButton *)button {
    
    XMNAssetModel *assetModel = self.assets[button.tag];
    if (!assetModel.selected) {
        if (assetModel.type == XMNAssetTypeVideo) {
            if ([self.selectedAssets firstObject] && [self.selectedAssets firstObject].type != XMNAssetTypeVideo) {
//                [self.parentController showAlertWithMessage:@"不能同时选择照片和视频"];
            }else if ([self.selectedAssets firstObject]){
//                [self.parentController showAlertWithMessage:@"一次只能发送1个视频"];
            }
            return;
        }else if (self.selectedAssets.count >= self.maxCount) {
//            [self.parentController showAlertWithMessage:[NSString stringWithFormat:@"一次最多只能选择%d张图片",(int)self.maxCount]];
            return;
        }
        [UIView animationWithLayer:button.layer type:XMNAnimationTypeBigger];
        assetModel.selected = YES;
        [self.selectedAssets addObject:assetModel];
    }else {
        
        assetModel.selected = NO;
        [self.selectedAssets removeObject:assetModel];
    }
    button.selected = assetModel.selected;
//    [self updatePhotoLibraryButton];
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:MIN(self.assets.count - 1, button.tag+1) inSection:0];
    if (![self.collectionView.indexPathsForVisibleItems containsObject:nextIndexPath]) {
        [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
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
    
    XMNPhotoPickerCell *pickerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XMNPhotoPickerCell" forIndexPath:indexPath];
    pickerCell.imageView.image = self.assets[indexPath.row].previewImage;
    return pickerCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XMNAssetModel *asset = self.assets[indexPath.row];
    
    /** 感谢QQ上的独兄弟 提出的建议 */
    CGSize size = CGSizeZero;
    if ([asset.asset isKindOfClass:[PHAsset class]]) {
        size = CGSizeMake([asset.asset pixelWidth], [asset.asset pixelHeight]);
    }else if ([asset.asset isKindOfClass:[ALAsset class]]){
        size = [[asset.asset defaultRepresentation] dimensions];
    }
    
    /** 增加默认scale  防止size为CGSizeZero 导致的崩溃问题 */
    CGFloat scale;
    if (CGSizeEqualToSize(CGSizeZero, size)) {
        scale = .5f;
    }else {
        scale = (MAX(0, size.width - 10))/size.height;
    }
    return CGSizeMake(scale * (self.collectionView.frame.size.height),self.collectionView.frame.size.height);
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    XMNAssetModel *assetModel = self.assets[indexPath.row];
//    if (assetModel.type == XMNAssetTypeVideo) {
//        XMNVideoPreviewController *videoPreviewC = [[XMNVideoPreviewController alloc] init];
//        videoPreviewC.selectedVideoEnable = self.selectedAssets.count == 0;
//        videoPreviewC.asset = assetModel;
//        __weak typeof(*&self) wSelf = self;
//        [videoPreviewC setDidFinishPickingVideo:^(UIImage *coverImage, XMNAssetModel *asset) {
//            __weak typeof(*&self) self = wSelf;
//            self.hidden = NO;
//            self.didFinishPickingVideoBlock ? self.didFinishPickingVideoBlock(coverImage,asset) : nil;
//            [self.parentController dismissViewControllerAnimated:YES completion:nil];
//        }];
//        
//        [videoPreviewC setDidFinishPreviewBlock:^{
//            __strong typeof(*&wSelf) self = wSelf;
//            self.hidden = NO;
//        }];
//        self.hidden = YES;
//        [self.parentController presentViewController:videoPreviewC animated:YES completion:nil];
//    }else {
//        
//        XMNPhotoPreviewController *previewC = [[XMNPhotoPreviewController alloc] initWithCollectionViewLayout:[XMNPhotoPreviewController photoPreviewViewLayoutWithSize:[UIScreen mainScreen].bounds.size]];
//        previewC.assets = self.assets;
//        previewC.maxCount = self.maxCount;
//        previewC.selectedAssets = [NSMutableArray arrayWithArray:self.selectedAssets];
//        previewC.currentIndex = indexPath.row;
//        __weak typeof(*&self) wSelf = self;
//        [previewC setDidFinishPreviewBlock:^(NSArray<XMNAssetModel *> *selectedAssets) {
//            
//            __weak typeof(*&self) self = wSelf;
//            self.hidden = NO;
//            self.selectedAssets = [NSMutableArray arrayWithArray:selectedAssets];
//            [self updatePhotoLibraryButton];
//            [self.collectionView reloadData];
//            [self.parentController dismissViewControllerAnimated:YES completion:nil];
//        }];
//        
//        [previewC setDidFinishPickingBlock:^(NSArray<UIImage *> *images, NSArray<XMNAssetModel *> *assets) {
//            
//            __weak typeof(*&self) self = wSelf;
//            self.hidden = NO;
//            [self.selectedAssets removeAllObjects];
//            self.didFinishPickingPhotosBlock ? self.didFinishPickingPhotosBlock(images,assets) : nil;
//            [self hideAnimated:NO];
//            [self.parentController dismissViewControllerAnimated:YES completion:nil];
//        }];
//        
//        self.hidden = YES;
//        [self.parentController presentViewController:previewC animated:YES completion:nil];
//    }
//    
//    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    XMNPhotoPickerReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kXMNStickSupplementaryViewKind withReuseIdentifier:@"XMNPhotoPickerReusableView" forIndexPath:indexPath];
    reusableView.button.selected = self.assets[indexPath.row].selected;
    reusableView.button.tag = indexPath.row;
    [reusableView.button removeTarget:self action:@selector(handleStateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [reusableView.button addTarget:self action:@selector(handleStateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return reusableView;
}


@end
