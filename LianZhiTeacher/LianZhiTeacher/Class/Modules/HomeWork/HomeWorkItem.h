//
//  HomeWorkItem.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/31.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeWorkItem : NSObject
@property (nonatomic, copy)NSString *content;
@property (nonatomic, strong)NSArray *photoArray;
@property (nonatomic, strong)AudioItem* audioItem;
@property (nonatomic, copy)NSString *ctime;
@end
