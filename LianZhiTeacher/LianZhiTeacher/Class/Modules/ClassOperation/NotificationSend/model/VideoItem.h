//
//  VideoItem.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/8.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"

@interface VideoItem : TNBaseObject
@property (nonatomic, copy)NSString *videoID;
@property (nonatomic, copy)NSString *videoUrl;
@property (nonatomic, copy)NSString *coverUrl;
@property (nonatomic, strong)UIImage* coverImage;
@property (nonatomic, assign)NSInteger videoTime;
@property (nonatomic, assign)CGFloat    coverWidth;
@property (nonatomic, assign)CGFloat    coverHeight;

- (BOOL)isDownloading;
- (BOOL)isLocal;
- (BOOL)isSame:(VideoItem *)object;
@end
