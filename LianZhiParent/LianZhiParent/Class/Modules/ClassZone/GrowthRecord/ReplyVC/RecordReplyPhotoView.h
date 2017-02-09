//
//  RecordReplyPhotoView.h
//  LianZhiParent
//
//  Created by jslsxu on 17/2/9.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordReplyContentBaseView.h"

@interface NotificationPhotoItemView : UIView
@property (nonatomic, strong)PhotoItem *photoItem;
@property (nonatomic, copy)void (^deleteCallback)();
- (UIImageView *)curImageView;
@end

@interface RecordReplyPhotoView : RecordReplyContentBaseView
@property (nonatomic, strong)NSMutableArray*   photoArray;
@property (nonatomic, assign)BOOL               editDisable;
@end
