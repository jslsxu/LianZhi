//
//  NSString+StringSize.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringSize)
- (CGSize)boundingRectWithSize:(CGSize)size andFont:(UIFont *)font;
@end
