//
//  RIButtonItem.h
//  Shibui
//
//  Created by Jiva DeVoe on 1/12/11.
//  Copyright 2011 Random Ideas, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RIButtonItem : NSObject
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) void (^action)();
+(id)item;
+(id)itemWithTitle:(NSString *)inTitle;
@end

