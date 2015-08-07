//
//  TNActionSheet.h
//  TNFoundation
//
//  Created by jslsxu on 14-10-14.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^btnBlk)(void);

@interface TNButtonItem : NSObject
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)btnBlk action;
+ (instancetype)itemWithTitle:(NSString *)title action:(btnBlk)action;
@end

@interface  UIButton(ActionItem)
@property (nonatomic, strong)TNButtonItem *actionItem;
@end

@interface TNActionSheet : UIView
{
    UIButton *_backgroundButton;
    UIView *_contentView;
}
- (instancetype)initWithTitle:(NSString *)title descriptionView:(UIView *)descriptionView destructiveButton:(TNButtonItem *)destructiveItem cancelItem:(TNButtonItem *)cancelItem otherItems:(NSArray *)otherItems;
- (void)show;
@end
