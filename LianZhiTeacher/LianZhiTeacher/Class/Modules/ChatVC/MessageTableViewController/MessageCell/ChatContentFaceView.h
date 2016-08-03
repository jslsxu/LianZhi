//
//  ChatFaceCell.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ChatBubbleContentView.h"

@interface ChatContentFaceView : UIView<IChatContentView>
{
    UIImageView*    _imageView;
}
@property (nonatomic, strong)MessageItem*   messageItem;
@end
