//
//  EmptyHintView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/9/12.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyHintView : UIView{
    UIImageView*    _imageView;
    UILabel*        _titleLabel;
}
- (instancetype)initWithImage:(NSString *)image title:(NSString *)title;
@end
