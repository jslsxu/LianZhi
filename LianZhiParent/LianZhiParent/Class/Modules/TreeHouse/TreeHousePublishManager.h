//
//  TreeHousePublishManager.h
//  LianZhiParent
//
//  Created by qingxu zhou on 16/9/8.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeHousePublishManager : NSObject
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(TreeHousePublishManager)
- (void)addTreehouseItem:(TreehouseItem *)item;
- (void)startUploading:(TreehouseItem *)item;
@end
