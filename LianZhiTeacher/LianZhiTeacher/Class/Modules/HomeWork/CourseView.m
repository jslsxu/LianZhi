//
//  CourseView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/12/7.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "CourseView.h"
#define kCourseCacheKey          @"CourseCache"
@implementation CourseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _deleteButtons = [NSMutableArray array];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *courseArray = [userDefaults objectForKey:kCourseCacheKey];
        _courseArray = [NSMutableArray arrayWithArray:courseArray];
        
        [self setupSubviews];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setupSubviews
{
    [_deleteButtons removeAllObjects];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if(_courseArray.count == 0)
    {
        UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 0, 0)];
        [hintLabel setFont:[UIFont systemFontOfSize:14]];
        [hintLabel setTextColor:[UIColor colorWithHexString:@"b1b1b1"]];
        [hintLabel setText:@"添加作业所属科目"];
        [hintLabel sizeToFit];
        [hintLabel setOrigin:CGPointMake(10, 10)];
        [self addSubview:hintLabel];
        
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"EmptyCourse"]];
        [imageView setOrigin:CGPointMake(hintLabel.right + 3, 10)];
        [imageView setCenterY:hintLabel.centerY];
        [self addSubview:imageView];
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton addTarget:self action:@selector(onAddButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [addButton setFrame:CGRectMake(imageView.right + 3, imageView.y + (imageView.height - 30) / 2, 60, 30)];
        [addButton setCenterY:imageView.centerY];
        [addButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"AAAAAA"] size:addButton.size cornerRadius:15] forState:UIControlStateNormal];
        [addButton setImage:[UIImage imageNamed:@"AddCourse"] forState:UIControlStateNormal];
        [self addSubview:addButton];
    }
    else
    {
        NSInteger spaceXStart = 0;
        NSInteger spaceYStart = 0;
        NSInteger innerMargin = 15;
        for (NSInteger i = 0; i < _courseArray.count + 1; i++)
        {
            if(i < _courseArray.count)
            {
                NSString *course = _courseArray[i];
                
                NSInteger buttonWidth = [course sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}].width + 30;
                if(spaceXStart + buttonWidth > self.width)
                {
                    spaceXStart = 0;
                    spaceYStart = spaceYStart + 30 + 10;
                }
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button addTarget:self action:@selector(onCourseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitle:course forState:UIControlStateNormal];
                [button setFrame:CGRectMake(spaceXStart, spaceYStart, buttonWidth, 30)];
                if([self.course isEqualToString:course])
                {
                    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"F53757"] size:button.size cornerRadius:15] forState:UIControlStateNormal];
                }
                else
                {
                    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"AAAAAA"] size:button.size cornerRadius:15] forState:UIControlStateNormal];
                }
                
                [self addSubview:button];
                
                if(_edit)
                {
                    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    [deleteButton setFrame:CGRectMake(button.right - 9, button.y - 9, 18, 18)];
                    [deleteButton setImage:[UIImage imageNamed:@"DeleteCourse"] forState:UIControlStateNormal];
                    [deleteButton addTarget:self action:@selector(onDeleteClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:deleteButton];
                    [_deleteButtons addObject:deleteButton];
                }
                
                UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
                [longPress setMinimumPressDuration:2];
                [button addGestureRecognizer:longPress];
                
                spaceXStart += innerMargin + buttonWidth;
            }
            else
            {
                if(spaceXStart + 60 > self.width)
                {
                    spaceXStart = 0;
                    spaceYStart += 30 + 10;
                }
                UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [addButton addTarget:self action:@selector(onAddButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                [addButton setFrame:CGRectMake(spaceXStart, spaceYStart, 60, 30)];
                [addButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"AAAAAA"] size:addButton.size cornerRadius:15] forState:UIControlStateNormal];
                [addButton setImage:[UIImage imageNamed:@"AddCourse"] forState:UIControlStateNormal];
                [self addSubview:addButton];
                spaceXStart += innerMargin + 60;
            }
        }
        [self setHeight:MAX(self.height, spaceYStart + 30 + innerMargin)];
        if([self.delegate respondsToSelector:@selector(courseViewDidChange)])
            [self.delegate courseViewDidChange];
    }
}

- (void)onTap
{
    if(_edit)
    {
        _edit = NO;
        [self setupSubviews];
    }
}

- (void)onLongPress:(UILongPressGestureRecognizer *)longPress
{
    if(!_edit)
    {
        _edit = YES;
        [self setupSubviews];
    }
}

- (void)onCourseButtonClicked:(UIButton *)button
{
    if(!_edit)
    {
        NSString *course = [button titleForState:UIControlStateNormal];
        [self setCourse:course];
        [self setupSubviews];
    }
}

- (void)onDeleteClicked:(UIButton *)button
{
    NSInteger index = [_deleteButtons indexOfObject:button];
    NSString *course = [_courseArray objectAtIndex:index];
    [_courseArray removeObject:course];
    if(_courseArray.count == 0)
        _edit = NO;
    [self setupSubviews];
}

- (void)onAddButtonClicked
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    _replyBox = [[ReplyBox alloc] initWithFrame:CGRectMake(0, keyWindow.height - REPLY_BOX_HEIGHT, keyWindow.width, REPLY_BOX_HEIGHT)];
    [_replyBox setDelegate:self];
    [keyWindow addSubview:_replyBox];
    [_replyBox assignFocus];
}

- (void)onActionViewCommit:(NSString *)content
{
    if(content.length > 0)
    {
        BOOL contain = NO;
        for (NSString *course in _courseArray)
        {
            if([course isEqualToString:content])
                contain = YES;
        }
        if(!contain)
        {
            [_courseArray insertObject:content atIndex:0];
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            [userdefaults setObject:_courseArray forKey:kCourseCacheKey];
        }
        [self setCourse:content];
        [self setupSubviews];
    }
    [_replyBox resignFocus];
    [_replyBox removeFromSuperview];
    _replyBox = nil;
}

- (void)onActionViewCancel
{
    [_replyBox resignFocus];
    [_replyBox removeFromSuperview];
    _replyBox = nil;
}

@end

