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
    UILabel*        _extraLabel;
    UIImageView*    _imageView;
    NSMutableArray* _avatarArray;
}
@property (nonatomic, strong)NSArray *praiseArray;
@property (nonatomic, assign)BOOL isSingle;
@end