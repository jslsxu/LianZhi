//
//  NotificationDetailActionView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/29.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationActionItem : TNBaseObject
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)void (^action)();
@property (nonatomic, assign)BOOL destroyItem;
+ (NotificationActionItem *)actionItemWithTitle:(NSString *)title action:(void (^)())action destroyItem:(BOOL)destroy;
@end

@interface NotificationDetailActionView : UIView

+ (void)showWithActions:(NSArray *)actionArray completion:(void (^)())completion;
@end
