//
//  HomeworkCourseView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkCourseView.h"
@interface HomeworkCourseView ()
@property (nonatomic, strong)UITextField*   courseField;
@end
@implementation HomeworkCourseView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setHeight:54];
        UILabel*    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [titleLabel setFont:[UIFont systemFontOfSize:15]];
        [titleLabel setText:@"科目:"];
        [titleLabel sizeToFit];
        [titleLabel setOrigin:CGPointMake(12, (self.height - titleLabel.height) / 2)];
        [self addSubview:titleLabel];
        
        UIImageView*    arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]];
        [arrowImageView setOrigin:CGPointMake(self.width - 10 - arrowImageView.width, (self.height - arrowImageView.height) / 2)];
        [self addSubview:arrowImageView];
        
        self.courseField = [[UITextField alloc] initWithFrame:CGRectMake(titleLabel.right + 30, 0, arrowImageView.left - 10 - (titleLabel.right + 30), self.height)];
        [self.courseField setUserInteractionEnabled:NO];
        [self.courseField setFont:[UIFont systemFontOfSize:15]];
        [self.courseField setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self.courseField setTextAlignment:NSTextAlignmentRight];
        [self.courseField setPlaceholder:@"请选择科目"];
        [self addSubview:self.courseField];
        
        UIView* sepLine = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCourse)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)selectCourse{
    if(self.addCallback){
        self.addCallback();
    }
}

- (void)setCourse:(NSString *)course{
    _course = [course copy];
    [self.courseField setText:_course];
}

@end
