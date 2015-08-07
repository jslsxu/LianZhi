//
//  ClassTableCell.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/4.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassTableCell : BGTableViewCell
{
    UIImageView*        _accessView;
}
@property (nonatomic, strong)ClassInfo *classInfo;
@end
