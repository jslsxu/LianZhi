//
//  GiftItem.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNModelItem.h"

@interface GiftItem : TNModelItem
@property (nonatomic, copy)NSString *giftID;
@property (nonatomic, copy)NSString *giftName;
@property (nonatomic, assign)NSInteger coin;
@property (nonatomic, assign)NSInteger ctype;
@property (nonatomic, copy)NSString *url;
@property (nonatomic, copy)NSString *url3x;
@property (nonatomic, assign)CGFloat width;
@property (nonatomic, assign)CGFloat height;
@property (nonatomic, assign)NSInteger num;
@property (nonatomic, assign)BOOL chosen;
@end
