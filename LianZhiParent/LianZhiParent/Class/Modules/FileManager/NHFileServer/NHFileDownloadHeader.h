//
//  NHFileDownloadHeader.h
//  NHFileDownloadManager-demo
//
//  Created by Wilson-Yuan on 15/11/17.
//  Copyright © 2015年 Wilson-Yuan. All rights reserved.
//

#ifndef NHFileDownloadHeader_h
#define NHFileDownloadHeader_h

typedef void (^ProgressBlock) (float progress);
typedef void (^SuccessBlock) (NSURL *fileUrl);
typedef void (^FailureBlock) (NSError *error);

static NSString * const NHFilePath = @"NHFilePath";
static NSString * const NHFileName = @"NHFileName";

#endif /* NHFileDownloadHeader_h */
