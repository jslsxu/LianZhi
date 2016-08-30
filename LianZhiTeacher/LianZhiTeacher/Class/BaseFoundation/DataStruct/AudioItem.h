//
//  AudioItem.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/24.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioItem : TNModelItem
@property (nonatomic, copy)NSString *audioID;
@property (nonatomic, copy)NSString *audioUrl;
@property (nonatomic, assign)NSInteger timeSpan;
- (BOOL)isLocal;
- (BOOL)isSame:(AudioItem *)object;
@end
