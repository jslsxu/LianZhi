//
//  ClassAppCell.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNCollectionViewCell.h"
#import "ClassAppModel.h"
@interface ClassAppCell : TNCollectionViewCell
{
    UIImageView*    _appImageView;
    UILabel*        _nameLabel;
    NumIndicator*         _indicator;
}
@property (nonatomic, copy)NSString *badge;
+ (CGFloat)cellHeight;
@end
