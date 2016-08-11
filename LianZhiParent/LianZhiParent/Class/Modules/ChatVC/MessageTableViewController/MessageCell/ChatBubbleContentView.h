//
//  ChatBubbleContentView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

@protocol IChatContentView <NSObject>
@property (nonatomic, strong)MessageItem*   messageItem;
- (instancetype)initWithModel:(MessageItem *)messageItem maxWidth:(CGFloat)maxWidth;
+ (CGFloat)contentHeightForModel:(MessageItem *)messageItem maxWidth:(CGFloat)maxWidth;
@optional
- (BOOL)shouldBeginGestureTouch:(UIGestureRecognizer *)gesture;
@end

@interface ChatBubbleContentView : UIView<IChatContentView>{
    UIImageView*    _bubbleBackgroundView;
    CGFloat         _maxWidth;
}
@property (nonatomic, strong)MessageItem*   messageItem;
@end
