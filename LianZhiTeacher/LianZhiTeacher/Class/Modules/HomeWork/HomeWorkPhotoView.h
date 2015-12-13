//
//  HomeWorkPhotoView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/12/7.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeWorkPhotoView : UIView<UIScrollViewDelegate>
{
    NSMutableArray* _photoViewArray;
    UIScrollView*   _scrollView;
}
@property (nonatomic, strong)NSMutableArray* photoArray;
@property (nonatomic, copy)void (^completion)(void);
@end
