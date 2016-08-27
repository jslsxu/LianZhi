//
//  ChatTopNewMessageView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/25.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTopNewMessageView : UIView{
    UIView*         _contentView;
    UIImageView*    _imageView;
    UILabel*        _titleLabel;
    
}
@property (nonatomic, strong)MessageItem *targetItem;
@property (nonatomic, assign)NSInteger messageNum;
@property (nonatomic, copy)void (^topNewMessageCallback)();
@end
