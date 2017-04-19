//
//  PhotoItem.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/22.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "PublishImageItem.h"
@interface PhotoItem : TNModelItem
@property (nonatomic, copy)NSString *photoID;
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, copy)NSString *small;//缩略图URL
@property (nonatomic, copy)NSString *middle;
@property (nonatomic, copy)NSString *big;//原图URL
@property (nonatomic, assign)CGFloat width;
@property (nonatomic, assign)CGFloat height;
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, strong)UserInfo *user;
@property (nonatomic, assign)BOOL isMine;
@property (nonatomic, assign)BOOL can_edit;
@property (nonatomic, copy)NSString *words;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *time_str;
@property (nonatomic, copy)NSString *tag;
@property (nonatomic, copy)NSString *author;
@property (nonatomic, strong)PublishImageItem *publishImageItem;
- (id)initWithDataWrapper:(TNDataWrapper *)dataWrapper;
- (BOOL)isLocal;
- (BOOL)isSame:(PhotoItem *)object;
- (NSString *)day;
@end
