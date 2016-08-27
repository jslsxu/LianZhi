//
//  ChatBottomNewMessageView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/25.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatBottomNewMessageView : UIView{
    UIImageView*    _imageView;
    UILabel*        _numLabel;
}
@property (nonatomic, assign)NSInteger messageNum;
@property (nonatomic, copy)void (^bottomNewCallback)();
@end
