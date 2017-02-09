//
//  RecordReplyContentBaseView.h
//  LianZhiParent
//
//  Created by jslsxu on 17/2/9.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordReplyContentBaseView : UIView
@property (nonatomic, assign)BOOL editDisabled;
@property (nonatomic, copy)void (^deleteDataCallback)(id item);
@end
