//
//  NotificationPhotoView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/29.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationContentBaseView.h"
@interface NotificationPhotoItemView : UIView
@property (nonatomic, strong)UIImage*   image;
@property (nonatomic, copy)void (^deleteCallback)();
@end

@interface NotificationPhotoView : NotificationContentBaseView
@property (nonatomic, strong)NSMutableArray*   photoArray;
@end
