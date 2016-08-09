//
//  ContactClassParentView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/3.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactClassHeaderView : UITableViewHeaderFooterView
{
    LogoView*   _logoView;
    UILabel*    _nameLabel;
    UILabel*    _numLabel;
    UIButton*   _chatButton;
}
@property (nonatomic, copy)void (^clickCallback)();
@property (nonatomic, copy)void (^chatCallback)();
@property (nonatomic, strong)ClassInfo* classInfo;
@end

@interface ContactClassStudentView : UIView
@property (nonatomic, strong)NSArray* classArray;
@end
