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
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, assign)NSInteger timeSpan;
@property (nonatomic, strong)NSData *audioData;
@end
