//
//  PhotoPickerVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/2/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "PhotoFlowVC.h"
#import "AlbumGroupView.h"
#import "PhotoPickerCell.h"
#import "PublishImageItem.h"
#import "PhotoPickerModel.h"
@class PhotoPickerVC;

@protocol PhotoPickerVCDelegate <NSObject>
@optional
- (void)photoPickerVC:(PhotoPickerVC *)photoPickerVC didFinished:(NSArray *)selectedArray;
- (void)photoPickerVCDidCancel:(PhotoPickerVC *)photoPickerVC;
@end

@interface PhotoPickerVC : TNBaseCollectionViewController<CHTCollectionViewDelegateWaterfallLayout, AlbumGroupDelegate>
{
    UIView*             _albumSelectedView;
    UIImageView*        _arrow;
    UIButton*           _confirmButton;
    NSMutableArray*     _photoArray;
    NSMutableArray*     _selectedArray;
    UIButton*           _coverButton;
    AlbumGroupView*     _groupView;
}
@property (nonatomic, assign)NSInteger maxToSelected;
@property (nonatomic, weak)id<PhotoPickerVCDelegate> delegate;
@end
