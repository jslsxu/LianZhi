//
//  AccountInfoView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 16/1/13.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountData : TNModelItem

@end

@interface AccountInfoView : UIView
{
    UIView* _bgView;
    UIView* _contentView;
}
- (instancetype)initWithAccountData:(AccountData *)data;
- (void)show;
@end
