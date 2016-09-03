//
//  MessageSegView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/27.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "MessageSegView.h"
#import "LZTabBarButton.h"

#define kSegItemWidth           70

@implementation MessageSegButton

- (void)setBadgeValue:(NSString *)badgeValue{
    [super setBadgeValue:badgeValue];
    CGRect titleFrame = self.titleLabel.frame;
    [_numIndicator setCenter:CGPointMake(CGRectGetMaxX(titleFrame) + 5, titleFrame.origin.y + 2)];
}

@end

@interface MessageSegView (){
    UIView*         _segmentView;
    NSMutableArray* _buttonArray;
    UIActivityIndicatorView*    _indicator;
    UIImage*                    _selectedImage;
}
@property (nonatomic, strong)NSArray *items;
@property (nonatomic, copy)void (^callback)(NSInteger selectedIndex);
@end

@implementation MessageSegView

- (instancetype)initWithItems:(NSArray *)items valueChanged:(void (^)(NSInteger))callback{
    self = [super initWithFrame:CGRectMake(0, 0, kSegItemWidth * 2, 30)];
    if(self){
        self.items = items;
        self.callback = callback;
        _buttonArray = [NSMutableArray array];
        _segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSegItemWidth * 2, 30)];
        [self setupSegmentView:_segmentView];
        [self addSubview:_segmentView];
        
//        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        [_indicator setCenter:CGPointMake(_segmentView.right + 15, self.height / 2)];
//        [_indicator setHidesWhenStopped:YES];
//        [self addSubview:_indicator];
        [self setSelectedIndex:0];
    
    }
    return self;
}

- (void)setupSegmentView:(UIView *)viewParent{
    [viewParent.layer setCornerRadius:5];
    [viewParent.layer setBorderColor:[UIColor colorWithHexString:@"5d5d5d"].CGColor];
    [viewParent.layer setBorderWidth:1];
    [viewParent.layer setMasksToBounds:YES];
    CGFloat itemWidth = viewParent.width / self.items.count;
    if(!_selectedImage){
        _selectedImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"5d5d5d"] size:CGSizeMake(itemWidth, viewParent.height) cornerRadius:0];
    }
    for (NSInteger i = 0; i < self.items.count; i++) {
        NSString *actionItem = self.items[i];
        MessageSegButton *button = [MessageSegButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTitle:actionItem forState:UIControlStateNormal];
        [button setFrame:CGRectMake(itemWidth * i, 0, itemWidth, viewParent.height)];
        [viewParent addSubview:button];
        [_buttonArray addObject:button];
    }
    for (NSInteger i = 1; i < self.items.count; i++) {
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(itemWidth * i - 0.5, 0, 1, viewParent.height)];
        [sepLine setBackgroundColor:[UIColor colorWithHexString:@"5d5d5d"]];
        [viewParent addSubview:sepLine];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    for (NSInteger i = 0; i < _buttonArray.count; i++) {
        MessageSegButton *button = _buttonArray[i];
        UIImage *image = (i == _selectedIndex) ? _selectedImage : nil;
        UIColor *color = (i == _selectedIndex) ? [UIColor whiteColor] : [UIColor colorWithHexString:@"5d5d5d"];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundImage:image forState:UIControlStateHighlighted];
        [button setTitleColor:color forState:UIControlStateNormal];
        [button setTitleColor:color forState:UIControlStateHighlighted];
    }
    if(self.callback){
        self.callback(_selectedIndex);
    }
}

- (void)setShowBadge:(NSString *)badge atIndex:(NSInteger)index{
    if(index < _buttonArray.count){
        MessageSegButton *button = _buttonArray[index];
        [button setBadgeValue:badge];
    }
}

- (void)onButtonClicked:(UIButton *)button{
    NSInteger selectedIndex = [_buttonArray indexOfObject:button];
    if(_selectedIndex != selectedIndex){
        [self setSelectedIndex:selectedIndex];
    }
    if(self.callback){
        self.callback(selectedIndex);
    }
}

- (void)startLoading{
    [_indicator startAnimating];
}

- (void)endLoading{
    [_indicator stopAnimating];
}

@end
