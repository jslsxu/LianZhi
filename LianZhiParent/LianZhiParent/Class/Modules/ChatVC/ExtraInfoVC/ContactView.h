//
//  ContactView.h
//  LianZhiParent
//
//  Created by qingxu zhou on 16/8/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactView : UIView
@property (nonatomic, copy)void (^chatCallback)();
- (instancetype)initWithUserInfo:(UserInfo *)userInfo;
@end
