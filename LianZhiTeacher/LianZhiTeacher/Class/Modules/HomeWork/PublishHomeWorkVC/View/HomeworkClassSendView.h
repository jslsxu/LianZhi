//
//  HomeworkClassSendView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/2.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendClassItemView : UIView
{
    UIButton*   _cancelButton;
    UILabel*    _nameLabel;
}
@property (nonatomic, strong)ClassInfo *classInfo;
@property (nonatomic, copy)void (^deleteCallback)();
- (instancetype)initWithClassInfo:(ClassInfo *)classInfo;
@end

@interface HomeworkClassSendView : UIView
{
    UIScrollView*   _scrollView;
    NSMutableArray* _memberArray;
}
@property (nonatomic, strong)NSArray *sendArray;
@property (nonatomic, copy)void (^deleteCallback)(ClassInfo *classInfo);
@end
