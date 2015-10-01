//
//  PraiseListView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface  PraiseListView: UIView
{
    UIImageView*    _imageView;
    NSMutableArray* _avatarArray;
}
@property (nonatomic, strong)NSArray *praiseArray;
@end