//
//  TNModelItem.h
//  TNFoundation
//
//  Created by jslsxu on 14-8-22.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TNDataWrapper.h"
#import "TNBaseObject.h"
@interface TNModelItem : TNBaseObject
- (void)parseData:(TNDataWrapper *)dataWrapper;
@end
