//
//  RecordPublishPhotoView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 17/2/9.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordPublishBaseView.h"
#import "NotificationPhotoView.h"
@interface RecordPublishPhotoView : RecordPublishBaseView
@property (nonatomic, strong)NSMutableArray*   photoArray;
@property (nonatomic, assign)BOOL               editDisable;
@end
