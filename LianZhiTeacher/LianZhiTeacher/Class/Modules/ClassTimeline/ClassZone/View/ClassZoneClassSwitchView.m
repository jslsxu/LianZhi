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
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
        _classNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, frame.size.width - 40, frame.size.height)];
        [_classNameLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [_classNameLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_classNameLabel];
        
        if([UserCenter sharedInstance].curSchool.classes.count > 1)
        {
            _arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_arrowButton setImage:[UIImage imageNamed:(@"WhiteRightArrow.png")] forState:UIControlStateNormal];
            [_arrowButton setFrame:CGRectMake(frame.size.width - 40 ,0, 40, frame.size.height)];
            [self addSubview:_arrowButton];
        }
        
        _coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_coverButton addTarget:self action:@selector(onSwitchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_coverButton setFrame:self.bounds];
        [self addSubview:_coverButton];
    }
    return self;
}

- (void)onSwitchButtonClicked
{
    NSArray *classArray = [UserCenter sharedInstance].curSchool.classes;
    if(classArray.count == 1)
        return;
    NSInteger index = [classArray indexOfObject:self.classInfo];
    if(index == [classArray count] - 1)
        index = 0;
    else
        index ++;
    ClassInfo *nextClass = [classArray objectAtIndex:index];
    [self setClassInfo:nextClass];
    
}

- (void)setClassInfo:(ClassInfo *)classInfo
{
    _classInfo = classInfo;
    _classNameLabel.text = _classInfo.name;
    if([self.delegate respondsToSelector:@selector(classZoneSwitch:)])
        [self.delegate classZoneSwitch:_classInfo];
}

@end
