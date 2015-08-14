//
//  ClassTableCell.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/4.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ClassTableCell.h"

@implementation ClassTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.textLabel setFont:[UIFont systemFontOfSize:16]];
        [self.textLabel setTextColor:kCommonTeacherTintColor];
        [self.textLabel setHighlightedTextColor:[UIColor whiteColor]];
        _accessView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        [self addSubview:_accessView];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setClassInfo:(ClassInfo *)classInfo
{
    _classInfo = classInfo;
    [self.textLabel setText:self.classInfo.className];
    [_accessView setCenter:CGPointMake(self.width - 30, self.height / 2)];
    if(!classInfo.canSelected)
        [_accessView setHidden:YES];
    else
    {
        [_accessView setHidden:NO];
        if(classInfo.selected)
            [_accessView setImage:[UIImage imageNamed:(@"CheckboxOn.png")]];
        else
            [_accessView setImage:[UIImage imageNamed:(@"CheckboxOff.png")]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
