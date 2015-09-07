//
//  ExpActionLabel.h
// MFWIOS
//
//  Created by dong jianbo on 12-5-03.
//  Copyright (c) 2012年 mafengwo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpLabel.h"
@class ExpActionLabel;

@protocol ExpActionLabelDelegate <NSObject>
@optional
// type:类型，title:显示文本，actionStr：内容文本
-(void)expActionLabel:(ExpActionLabel *)actionLabel action:(long long)action type:(long long)type actionStr:(NSString *)actionStr title:(NSString *)title inCell:(int)cellIndex;

@end


@interface ExpActionLabel : ExpLabel {
	NSMutableArray * actionTokens;
}

@property(nonatomic,assign) CGPoint anchor;
@property(nonatomic,assign) id<ExpActionLabelDelegate> delegate;

@end
