//
//  NewEditionPreview.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/3/1.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewEditionPreview : UIView
{
    UIView*         _bgView;
    UIScrollView*   _scrollView;
}
- (instancetype)initWithVersion:(NSString *)version notes:(NSString *)relaseNotes;
- (void)show;
- (void)dismiss;
@end
