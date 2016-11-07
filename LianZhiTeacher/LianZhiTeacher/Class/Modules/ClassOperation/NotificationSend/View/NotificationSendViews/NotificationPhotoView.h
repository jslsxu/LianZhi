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
@property (nonatomic, strong)PhotoItem *photoItem;
@property (nonatomic, copy)void (^deleteCallback)();
- (UIImageView *)curImageView;
@end

@interface NotificationPhotoView : NotificationContentBaseView
@property (nonatomic, strong)NSMutableArray*   photoArray;
@property (nonatomic, assign)BOOL               editDisable;
@end
