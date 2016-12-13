//
//  HeadLineView.h
//  LianzhiParent
//
//  Created by Chen qi on 15/11/12.
//  Copyright © 2016年 com.sjwy. All rights reserved.

#import <UIKit/UIKit.h>



@protocol headLineDelegate <NSObject>

@optional
- (void)refreshHeadLine:(NSInteger)currentIndex;

@end
@interface LZHeadLineView : UIView
@property(nonatomic,assign)NSInteger CurrentIndex;
@property(nonatomic,strong)NSArray * titleArray;
@property(nonatomic,assign)id<headLineDelegate>delegate;
-(void)shuaxinJiemian:(NSInteger)index;
@end
