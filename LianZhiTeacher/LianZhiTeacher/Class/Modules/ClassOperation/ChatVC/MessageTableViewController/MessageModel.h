//
//  MessageModel.h
//  MFWIOS
//
//  Created by jslsxu on 9/25/13.
//  Copyright (c) 2013 mafengwo. All rights reserved.
//

#import "MessageItem.h"
@interface MessageModel : TNListModel
{
    NSString*   _name;
    BOOL        _hasMore;
    NSInteger   _start;
}

@property (nonatomic, copy)NSString* name;
@end
