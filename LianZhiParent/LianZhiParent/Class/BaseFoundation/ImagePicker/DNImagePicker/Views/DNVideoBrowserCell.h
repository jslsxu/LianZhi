//
//  DNVideoBrowserCell.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/31.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DNPhotoBrowser;
@interface DNVideoBrowserCell : UICollectionViewCell
@property (nonatomic, weak) DNPhotoBrowser *photoBrowser;
@property (nonatomic, strong) ALAsset *asset;

- (void)stopPlay;
@end
