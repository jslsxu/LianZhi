//
//  StudentAttendanceNoteView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "StudentAttendanceNoteView.h"

@interface StudentAttendanceNoteView ()
@property (nonatomic, strong)UIView* contentView;
@end

@implementation StudentAttendanceNoteView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.width - 10 * 2, 0)];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView.layer setCornerRadius:6];
        [self.contentView.layer setMasksToBounds:YES];
        [self addSubview:self.contentView];
        
    }
    return self;
}

@end
