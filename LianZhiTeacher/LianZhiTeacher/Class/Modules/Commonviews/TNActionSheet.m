//
//  TNActionSheet.m
//  TNFoundation
//
//  Created by jslsxu on 14-10-14.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNActionSheet.h"


#define kActionSheetButtonHeight                40
#define kActionSheetHMargin                     30
#define kActionSheetVMargin                     20
#define kActionSheetInnerMargin                 10
#define kActionSheetMaxDescriptionHeight        120

@implementation TNButtonItem
+ (instancetype)itemWithTitle:(NSString *)title action:(btnBlk)action
{
    TNButtonItem *item = [[TNButtonItem alloc] init];
    [item setTitle:title];
    [item setAction:action];
    return item;
}

@end


@implementation UIButton(ActionItem)
static const char ActionItemKey;
- (void)setActionItem:(TNButtonItem *)item
{
    objc_setAssociatedObject(self, &ActionItemKey, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (TNButtonItem *)actionItem
{
    return objc_getAssociatedObject(self, &ActionItemKey);
}

@end

@implementation TNActionSheet

- (instancetype)initWithTitle:(NSString *)title descriptionView:(UIView *)descriptionView destructiveButton:(TNButtonItem *)destructiveItem cancelItem:(TNButtonItem *)cancelItem otherItems:(NSArray *)otherItems
{
    if(destructiveItem == nil && cancelItem == nil && otherItems.count == 0)
        return nil;
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        _backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backgroundButton setFrame:self.bounds];
        [_backgroundButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        [_backgroundButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backgroundButton];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_contentView];
        
        CGFloat spaceYStart = kActionSheetVMargin;
        if(title.length > 0)//添加标题
        {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kActionSheetHMargin, spaceYStart, _contentView.width - kActionSheetHMargin * 2, 0)];
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            [titleLabel setTextColor:[UIColor colorWithHexString:@"777777"]];
            [titleLabel setTextAlignment:NSTextAlignmentCenter];
            [titleLabel setNumberOfLines:0];
            [titleLabel setFont:[UIFont systemFontOfSize:16]];
            [titleLabel setText:title];
            [titleLabel sizeToFit];
            [titleLabel setWidth:_contentView.width - kActionSheetHMargin * 2];
            [_contentView addSubview:titleLabel];
            
            spaceYStart += titleLabel.height + kActionSheetInnerMargin;
        }
        
        if(descriptionView)
        {
            UIView *descContentView = [[UIView alloc] initWithFrame:CGRectMake(kActionSheetHMargin, spaceYStart, _contentView.width - kActionSheetHMargin * 2, MIN(kActionSheetMaxDescriptionHeight, descriptionView.height))];
            [descContentView setClipsToBounds:YES];
            [descContentView addSubview:descriptionView];
            [_contentView addSubview:descContentView];
            spaceYStart += descContentView.height + kActionSheetInnerMargin;
        }
        
        NSMutableArray *items = [NSMutableArray array];
        [items addObjectsFromArray:otherItems];
        if(destructiveItem)
            [items addObject:destructiveItem];
        if(cancelItem)
            [items addObject:cancelItem];
        
        for (TNButtonItem *item in items) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setActionItem:item];
            [button setFrame:CGRectMake(kActionSheetHMargin, spaceYStart, _contentView.width - kActionSheetHMargin * 2, kActionSheetButtonHeight)];
            if(item == destructiveItem)
            {
                [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"f13e64"] size:button.size cornerRadius:5] forState:UIControlStateNormal];
            }
            else
            {
                [button setBackgroundImage:[UIImage imageWithColor:kCommonTeacherTintColor size:button.size cornerRadius:5] forState:UIControlStateNormal];
            }
            [button.titleLabel setFont:kButtonTextFont];
            [button setTitle:item.title forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_contentView addSubview:button];
            spaceYStart += button.height + kActionSheetInnerMargin;
        }
        spaceYStart += kActionSheetVMargin - kActionSheetInnerMargin;
        _contentView.height = spaceYStart;
    }
    return self;
}

- (void)show
{
    [_backgroundButton setAlpha:0.f];
    [_contentView setY:self.height];
    [[UIApplication sharedApplication].windows[0] addSubview:self];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_contentView setY:self.height - _contentView.height];
        [_backgroundButton setAlpha:1.f];
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

- (void)dismiss
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.3f animations:^{
        [_contentView setY:self.height];
        [_backgroundButton setAlpha:0.f];
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [self removeFromSuperview];
    }];
}

- (void)onButtonClicked:(id)sender
{
    [self dismiss];
    UIButton *targetButton = (UIButton *)sender;
    TNButtonItem *item = targetButton.actionItem;
    if(item.action)
        item.action();
}

@end
