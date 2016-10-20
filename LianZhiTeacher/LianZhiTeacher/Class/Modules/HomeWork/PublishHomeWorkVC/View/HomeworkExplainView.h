//
//  HomeworkExplainView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface HomeworkExplainView : UIView
@property (nonatomic, assign)BOOL   hasExplain;
@property (nonatomic, copy)void (^explainClick)();
@end
