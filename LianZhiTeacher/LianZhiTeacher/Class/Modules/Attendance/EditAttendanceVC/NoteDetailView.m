//
//  NoteDetailView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/24.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NoteDetailView.h"
#import "StudentsAttendanceListModel.h"

@implementation NoteDetailView

+ (void)showWithNotes:(NSArray *)notes{
    NoteDetailView* detailView = [[NoteDetailView alloc] initWithNotes:notes];
    [detailView show];
}
- (instancetype)initWithNotes:(NSArray *)notes{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self){

        UIButton* bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [bgButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        [bgButton setFrame:self.bounds];
        [bgButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgButton];
        
        UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, self.width - 30 * 2, 240)];
        [contentView setBackgroundColor:[UIColor whiteColor]];
        [contentView.layer setCornerRadius:10];
        [contentView.layer setMasksToBounds:YES];
        [contentView setCenterY:self.height / 2];
        [self addSubview:contentView];
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, contentView.width - 10 * 2, 50)];
        [titleLabel setFont:[UIFont systemFontOfSize:15]];
        [titleLabel setTextColor:kColor_33];
        [titleLabel setText:@"查看记录:"];
        [contentView addSubview:titleLabel];
        
        UIView* sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.height, contentView.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [contentView addSubview:sepLine];
        
        UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, titleLabel.height, contentView.width - 10 * 2, contentView.height - titleLabel.height)];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [contentView addSubview:scrollView];
        
        CGFloat spaceYStart = 5;
        for (NSInteger i = 0; i < [notes count]; i++) {
            AttendanceNoteItem* noteItem = notes[i];
            
            UILabel* timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [timeLabel setFont:[UIFont systemFontOfSize:14]];
            [timeLabel setTextColor:kCommonTeacherTintColor];
            [timeLabel setText:noteItem.ctime];
            [timeLabel sizeToFit];
            [timeLabel setOrigin:CGPointMake(0, spaceYStart)];
            [scrollView addSubview:timeLabel];
            
            spaceYStart += timeLabel.height + 5;
            
            UILabel* noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, 0)];
            [noteLabel setText:noteItem.recode];
            [noteLabel setFont:[UIFont systemFontOfSize:14]];
            [noteLabel setTextColor:kColor_66];
            [noteLabel setNumberOfLines:0];
            [noteLabel setLineBreakMode:NSLineBreakByWordWrapping];
            [noteLabel sizeToFit];
            [noteLabel setOrigin:CGPointMake(0, spaceYStart)];
            [scrollView addSubview:noteLabel];
            
            spaceYStart += noteLabel.height + 5;
        }
        [scrollView setContentSize:CGSizeMake(scrollView.width, spaceYStart)];
        
    }
    return self;
}

- (void)show{
    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    self.alpha = 0.f;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.f;
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.f;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
