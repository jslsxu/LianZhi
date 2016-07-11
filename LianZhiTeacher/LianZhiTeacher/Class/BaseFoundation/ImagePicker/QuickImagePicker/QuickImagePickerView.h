//
//  QuickImagePickerView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/7.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMNPhotoPickerCell : UICollectionViewCell
@property (nonatomic, strong, nullable)UIImageView *imageView;

@end

@interface QuickImagePickerView : UIView<UICollectionViewDelegate, UICollectionViewDataSource>
/** 最大选择数量 默认0 不限制  使用sharePhotoPicker 则为9*/
@property (nonatomic, assign) NSUInteger maxCount;
/** 最大预览图数量 默认20 */
@property (nonatomic, assign) NSUInteger maxPreviewCount;
/** 是否可以选择视频 默认YES */
@property (nonatomic, assign) BOOL pickingVideoEnable;
- (instancetype _Nullable)initWithMaxCount:(NSInteger)count;
@end
