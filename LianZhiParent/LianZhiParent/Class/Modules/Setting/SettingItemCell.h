//
//  SettingItemCell.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/23.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingItem : NSObject
@property (nonatomic, copy)NSString *title;
@property (nonatomic, assign)BOOL hasNew;
@end

@interface SettingItemCell : BGTableViewCell
{
    UILabel*        _titleLabel;
    UIImageView*    _redDot;
    UIImageView*    _rightArrow;
    UILabel*        _contentLabel;
}
@property (nonatomic, strong)SettingItem *item;
@property (nonatomic, copy)NSString *content;
@end
