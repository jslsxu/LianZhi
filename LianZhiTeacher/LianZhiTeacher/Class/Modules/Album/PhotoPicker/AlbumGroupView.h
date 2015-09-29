//
//  AlbumGroupView.h
//  LianZhiParent
//
//  Created by jslsxu on 15/3/11.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumItemCell : UITableViewCell
{
    UIImageView*    _albumCoverImage;
    UILabel*        _titleLabel;
    UILabel*        _numLabel;
    UIImageView*    _checkMark;
    UIView*         _sepLine;
}
@property (nonatomic, assign)NSInteger total;
@property (nonatomic, strong)NSString *iconUrl;
@property (nonatomic, strong)ALAssetsGroup *group;
@property (nonatomic, assign)BOOL albumSelected;
@end

@protocol AlbumGroupDelegate <NSObject>
- (void)albumGroupViewSelectedSystemAlbum:(ALAssetsGroup *)group;   //本地相册                      //云相册

@end

@interface AlbumGroupView : UIView<UITableViewDataSource, UITableViewDelegate>
{
    ALAssetsLibrary*    _assetslibrary;
    NSMutableArray*     _albumGroups;
    UITableView*        _tableView;
}
@property (nonatomic, strong)NSString *iconUrl;
@property (nonatomic, assign)NSInteger total;
@property (nonatomic, assign)NSInteger selectedIndex;
@property (nonatomic, weak)id<AlbumGroupDelegate> delegate;
- (void)reloadData;
@end
