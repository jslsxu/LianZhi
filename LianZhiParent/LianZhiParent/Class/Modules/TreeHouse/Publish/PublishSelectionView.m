//
//  PublishSelectionView.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/20.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PublishSelectionView.h"

@implementation PublishSelectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        
        _textButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_textButton setFrame:CGRectMake(0, 0, 48, 48)];
        [_textButton setImage:[UIImage imageNamed:@"PostText.png"] forState:UIControlStateNormal];
        [_textButton addTarget:self action:@selector(onPostButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_textButton];
        
        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoButton setFrame:CGRectMake(0, 0, 48, 48)];
        [_photoButton setImage:[UIImage imageNamed:@"PostPhoto.png"] forState:UIControlStateNormal];
        [_photoButton addTarget:self action:@selector(onPostButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_photoButton];

        
        _audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_audioButton setFrame:CGRectMake(0, 0, 48, 48)];
        [_audioButton setImage:[UIImage imageNamed:@"PostAudio.png"] forState:UIControlStateNormal];
        [_audioButton addTarget:self action:@selector(onPostButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_audioButton];
        
        

    }
    return self;
}

- (void)onPostButtonClicked:(id)sender
{
    [self dismiss];
    NSInteger index = 0;
    if(sender == _textButton)
        index = 0;
    else if(sender == _photoButton)
        index = 1;
    else
        index = 2;
    if([self.delegate respondsToSelector:@selector(publishContentDidSelectAtIndex:)])
    {
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [self.delegate publishContentDidSelectAtIndex:index];
        });
    }
}

- (void)show
{
    [_textButton setCenter:CGPointMake(self.width / 4, self.height + 30)];
    [_photoButton setCenter:CGPointMake(self.width / 2, self.height + 30)];
    [_audioButton setCenter:CGPointMake(self.width * 3 / 4, self.height + 30)];
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];

    CGFloat upDuration = 0.3, downDuration = 0.15,timeOffSet = 0.1;
    [UIView animateWithDuration:upDuration + downDuration + 0.1 * 2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    } completion:^(BOOL finished) {
        
    }];
    for (NSInteger i = 0; i < 3; i++)
    {
        UIButton *target;
        if(i == 0)
            target = _textButton;
        else if(i == 1)
            target = _photoButton;
        else
            target = _audioButton;
        [UIView animateWithDuration:upDuration delay:timeOffSet * i options:UIViewAnimationOptionCurveEaseInOut animations:^{
            target.centerY = self.height - 120;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:downDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                target.centerY = self.height - 100;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
}

- (void)dismiss
{
    CGFloat upDuration = 0.3, downDuration = 0.15,timeOffSet = 0.1;
    for (NSInteger i = 0; i < 3; i++)
    {
        UIButton *target;
        if(i == 0)
            target = _audioButton;
        else if(i == 1)
            target = _photoButton;
        else
            target = _textButton;
        [UIView animateWithDuration:downDuration delay:timeOffSet * i options:UIViewAnimationOptionCurveEaseInOut animations:^{
            target.centerY = self.height - 120;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:upDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                target.centerY = self.height + 30;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
    [UIView animateWithDuration:upDuration + downDuration + 0.1 * 2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([self.delegate respondsToSelector:@selector(publishContentDidCancel)])
        [self.delegate publishContentDidCancel];
    [self dismiss];
}
@end
