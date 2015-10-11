//
//  ShareActionView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/11.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareActionView : UIView
{
    UIButton*   _bgButton;
    UIView*     _contentView;
    NSMutableArray* _shareArray;
}

+ (void)shareWithTitle:(NSString *)title
              content:(NSString *)content
                image:(UIImage *)image
             imageUrl:(NSString *)imageUrl
                  url:(NSString *)url;
@end
