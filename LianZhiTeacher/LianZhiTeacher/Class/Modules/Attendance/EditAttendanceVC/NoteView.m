//
//  NoteView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/25.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NoteView.h"

@interface NoteView ()
@property (nonatomic, strong)UILabel* timeLabel;
@property (nonatomic, strong)UILabel* contentLabel;
@property (nonatomic, strong)UIImageView* arrowImageView;
@end

@implementation NoteView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.timeLabel setTextColor:kCommonTeacherTintColor];
        [self.timeLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:self.timeLabel];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentLabel setTextColor:kColor_66];
        [self.contentLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:self.contentLabel];
        
        self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]];
        [self addSubview:self.arrowImageView];
    }
    return self;
}

- (void)setNoteItem:(AttendanceNoteItem *)noteItem{
    _noteItem = noteItem;
    [self.timeLabel setText:_noteItem.ctime];
    [self.timeLabel sizeToFit];
    [self.timeLabel setOrigin:CGPointMake(0, (self.height - self.timeLabel.height) / 2)];
    
    [self.arrowImageView setOrigin:CGPointMake(self.width - self.arrowImageView.width, (self.height - self.arrowImageView.height) / 2)];
    
    [self.contentLabel setFrame:CGRectMake(self.timeLabel.right + 5, 0, self.arrowImageView.left - 5 - (self.timeLabel.right + 5), self.height)];
    [self.contentLabel setText:_noteItem.recode];
    
}

@end
