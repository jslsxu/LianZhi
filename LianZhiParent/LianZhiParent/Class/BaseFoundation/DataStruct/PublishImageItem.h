//
//  PublishImageItem.h
//  LianZhiParent
//
//  Created by jslsxu on 15/2/9.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublishImageItem : NSObject
@property (nonatomic, copy)NSString *photoKey;
@property (nonatomic, copy)NSString *photoID;
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, copy)NSString *thumbnailUrl;
@property (nonatomic, copy)NSString *originalUrl;
@end
