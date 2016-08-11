//
//  ChatRevokeCell.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ChatBubbleContentView.h"

@interface ChatContentRevokeView : UIView<IChatContentView>{
    UILabel*    _revokeMessageLabel;
}
@property (nonatomic, strong)MessageItem*   messageItem;
@end
