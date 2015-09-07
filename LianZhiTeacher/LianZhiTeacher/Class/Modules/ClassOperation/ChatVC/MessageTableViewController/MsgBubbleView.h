//
//  MsgBubbleView.h
//  MFWIOS
//
//  Created by jslsxu on 9/24/13.
//  Copyright (c) 2013 mafengwo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageItem.h"
#import "ExpActionLabel.h"
#define kAvatarSize                 40
@interface MsgBubbleView : UIImageView
{
    ExpActionLabel*     _contentLabel;
    MessageItem*        _item;
    BOOL                _selectedToShowCopyMenu;
}

@property (nonatomic, retain)MessageItem* item;
@property (nonatomic, assign)BOOL selectedToShowCopyMenu;
- (CGRect)bubbleFrame;
+ (CGSize)sizeForItem:(MessageItem *)messageItem;
@end
