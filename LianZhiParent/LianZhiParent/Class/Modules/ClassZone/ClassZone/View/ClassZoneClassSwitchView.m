//
//  ClassZoneClassSwitchView.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/23.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "ClassZoneClassSwitchView.h"

@implementation ClassZoneClassSwitchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"04aa73"]];
        _classNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, frame.size.width - 40, frame.size.height)];
        [_classNameLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [_classNameLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_classNameLabel];
        
        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_switchButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_switchButton setTitle:@"切换班级" forState:UIControlStateNormal];
        [_switchButton setFrame:CGRectMake(self.width - 70 - 10, (self.height - 20) / 2, 70, 20)];
        [_switchButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"fa9c3f"] size:CGSizeMake(70, 20) cornerRadius:10] forState:UIControlStateNormal];
        [_switchButton addTarget:self action:@selector(onSwitchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_switchButton];
    }
    return self;
}

- (void)setCurChild:(ChildInfo *)curChild
{
    _curChild = curChild;
    if(_curChild.classes.count > 0)
    {
        [self setClassInfo:_curChild.classes[0]];
    }
    else
    {
        [self setClassInfo:nil];
    }
    [_switchButton setHidden:_curChild.classes.count == 1];
}

- (void)setClassInfo:(ClassInfo *)classInfo
{
    _classInfo = classInfo;
    [_classNameLabel setText:_classInfo.name];
}

- (void)onSwitchButtonClicked
{
    if([self.delegate respondsToSelector:@selector(classZoneSwitch)])
        [self.delegate classZoneSwitch];
    
}


@end
