//
//  QuickImagePickerView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/7.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMNPhotoManager.h"
#import "XMNPhotoStickLayout.h"
@interface XMNPhotoPickerCell : UICollectionViewCell
{
    UIImageView*    _imageView;
    UIButton*       _stateButton;
    UIImageView*    _typeImageView;
    UILabel*        _durationLabel;
}
@property (nonatomic, nonnull, readonly)UIButton *stateButton;
@property (nonatomic, nonnull, strong)XMNAssetModel *asset;
@property (nonatomic, nonnull, copy)void (^selectButtonClickedBlk)();
@end

@interface QuickImagePickerView : UIView<UICollectionViewDelegate, UICollectionViewDataSource>
/** 最大选择数量 默认0 不限制  使用sharePhotoPicker 则为9*/
@property (nonatomic, assign) NSUInteger maxImageCount;
@property (nonatomic, assign) NSInteger maxVideoCount;
/** 最大预览图数量 默认20 */
@property (nonatomic, assign) NSUInteger maxPreviewCount;
/** 是否可以选择视频 默认YES */
@property (nonatomic, assign) BOOL pickingVideoEnable;

@property (nonatomic, copy, nonnull) void (^onClickAlbum)(void);
@property (nonatomic, copy, nonnull)void (^sendCallback)(NSArray *imageArray, BOOL fullImage);
- (instancetype _Nullable)initWithMaxImageCount:(NSInteger)imageCount videoCount:(NSInteger)videoCount videoEnabled:(BOOL)videoEnabled;
@end
