//
//  ChildPhotoView.h
//  LianZhiParent
//
//  Created by jslsxu on 17/2/8.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChildPhotoItemView : UICollectionViewCell
@property (nonatomic, strong)PhotoItem* photoItem;
@end

@interface ChildPhotoView : UIView
@property (nonatomic, strong)NSArray* photoArray;
@end
