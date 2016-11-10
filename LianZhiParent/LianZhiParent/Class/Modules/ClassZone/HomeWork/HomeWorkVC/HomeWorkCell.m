//
//  HomeWorkCell.m
//  LianZhiParent
//
//  Created by jslsxu on 15/10/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "HomeWorkCell.h"
#import "HomeWorkListModel.h"
#import "CollectionImageCell.h"

@implementation HomeworkExtraInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        UIView* topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kLineHeight)];
        [topLine setBackgroundColor:kSepLineColor];
        [self addSubview:topLine];
        
        _courseLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_courseLabel setTextColor:kCommonParentTintColor];
        [_courseLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_courseLabel];
        
        _imageTypeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_hasPhoto"]];
        [self addSubview:_imageTypeView];
        
        _voiceTypeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_hasAudio"]];
        [self addSubview:_voiceTypeView];
        
        _redDot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        [_redDot setBackgroundColor:[UIColor colorWithHexString:@"e00909"]];
        [_redDot.layer setCornerRadius:3];
        [_redDot.layer setMasksToBounds:YES];
        [self addSubview:_redDot];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_statusLabel setTextColor:kCommonParentTintColor];
        [_statusLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_statusLabel];
        
        _rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gray_expand_indicator"]];
        [_rightArrow setOrigin:CGPointMake(self.width - 10 - _rightArrow.width, (self.height - _rightArrow.height) / 2)];
        [self addSubview:_rightArrow];
    }
    return self;
}

- (void)setHomeworkItem:(HomeworkItem *)homeworkItem{
    _homeworkItem = homeworkItem;
    NSInteger spaceXStart = 10;
    NSInteger spaceXEnd = _rightArrow.left - 5;
    [_courseLabel setText:[NSString stringWithFormat:@"%@作业",_homeworkItem.course_name]];
    [_courseLabel sizeToFit];
    [_courseLabel setOrigin:CGPointMake(spaceXStart, (self.height - _courseLabel.height) / 2)];
    spaceXStart = _courseLabel.right + 10;
    
    if([_homeworkItem hasPhoto]){
        [_imageTypeView setHidden:NO];
        [_imageTypeView setOrigin:CGPointMake(spaceXStart, (self.height - _imageTypeView.height) / 2)];
        spaceXStart = _imageTypeView.right + 10;
    }
    else{
        [_imageTypeView setHidden:YES];
    }
    
    if([_homeworkItem hasAudio]){
        [_voiceTypeView setHidden:NO];
        [_voiceTypeView setOrigin:CGPointMake(spaceXStart, (self.height - _voiceTypeView.height) / 2)];
    }
    else{
        [_voiceTypeView setHidden:YES];
    }
    NSString *status = nil;
    UIColor* statusColor = kCommonParentTintColor;
    if(_homeworkItem.etype){//可以回复
        if(_homeworkItem.status == HomeworkStatusUnread || _homeworkItem.status == HomeworkStatusRead){
            status = @"待提交";
            statusColor = [UIColor colorWithHexString:@"e00909"];
        }
        else if(_homeworkItem.status == HomeworkStatusWaitMark){
            status = @"已提交";
            statusColor = [UIColor colorWithHexString:@"666666"];
        }
        else if(_homeworkItem.status == HomeworkStatusMarked){
            status = @"已批阅";
            statusColor = kCommonParentTintColor;
        }
        [_statusLabel setHidden:NO];
        [_statusLabel setTextColor:statusColor];
        [_statusLabel setText:status];
        [_statusLabel sizeToFit];
        [_statusLabel setOrigin:CGPointMake(spaceXEnd - _statusLabel.width, (self.height - _statusLabel.height) / 2)];
        
        spaceXEnd = _statusLabel.left - 2;
    }
    else{
        [_statusLabel setHidden:YES];
    }
   
    [_redDot setOrigin:CGPointMake(spaceXEnd - _redDot.width, (self.height - _redDot.height) / 2)];
    [_redDot setHidden:!_homeworkItem.unread_s];
}

@end

@implementation HomeWorkCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, self.width - 15 * 2, 0)];
        [_bgView setBackgroundColor:[UIColor whiteColor]];
        [_bgView.layer setCornerRadius:10];
        [_bgView.layer setMasksToBounds:YES];
        [self addSubview:_bgView];
        
        _courseLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 36, 36)];
        [_courseLabel setBackgroundColor:kCommonParentTintColor];
        [_courseLabel setTextAlignment:NSTextAlignmentCenter];
        [_courseLabel setTextColor:[UIColor colorWithHexString:@"75dab8"]];
        [_courseLabel setFont:[UIFont boldSystemFontOfSize:25]];
        [_courseLabel.layer setCornerRadius:18];
        [_courseLabel.layer setMasksToBounds:YES];
        [_bgView addSubview:_courseLabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextColor:kCommonParentTintColor];
        [_bgView addSubview:_nameLabel];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setFrame:CGRectMake(0, 0, 30, 30)];
        [_deleteButton setImage:[UIImage imageNamed:@"MessageDetailTrash"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteHomework) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_deleteButton];
        
        _roleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_roleLabel setFont:[UIFont systemFontOfSize:14]];
        [_roleLabel setTextColor:kCommonParentTintColor];
        [_bgView addSubview:_roleLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setFont:[UIFont systemFontOfSize:12]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_bgView addSubview:_timeLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _courseLabel.bottom + 10, _bgView.width - 10 * 2, 0)];
        [_contentLabel setFont:[UIFont systemFontOfSize:14]];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [_bgView addSubview:_contentLabel];
        
        _endTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_endTimeLabel setTextColor:kCommonParentTintColor];
        [_endTimeLabel setFont:[UIFont systemFontOfSize:12]];
        [_bgView addSubview:_endTimeLabel];

        _extraInfoView = [[HomeworkExtraInfoView alloc] initWithFrame:CGRectMake(0, _endTimeLabel.bottom, _bgView.width, 45)];
        [_bgView addSubview:_extraInfoView];
    }
    return self;
}

- (void)deleteHomework{
    if(self.deleteCallback){
        self.deleteCallback();
    }
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    HomeworkItem *homeworkItem = (HomeworkItem *)modelItem;
    if([homeworkItem.course_name length] > 0){
         [_courseLabel setText:[homeworkItem.course_name substringToIndex:1]];
    }
    else{
        [_courseLabel setText:nil];
    }
    [_nameLabel setText:homeworkItem.teacher.name];
    [_nameLabel sizeToFit];
    [_nameLabel setOrigin:CGPointMake(_courseLabel.right + 10, _courseLabel.top)];
    [_deleteButton setOrigin:CGPointMake(_bgView.width - 10 - _deleteButton.width, _nameLabel.top)];
    [_roleLabel setText:@"教师"];
    [_roleLabel sizeToFit];
    [_roleLabel setOrigin:CGPointMake(_nameLabel.right + 5, _courseLabel.top)];
    [_timeLabel setText:[NSString stringWithFormat:@"发布时间:%@",homeworkItem.ctime]];
    [_timeLabel sizeToFit];
    [_timeLabel setOrigin:CGPointMake(_courseLabel.right + 10, _courseLabel.bottom - _timeLabel.height)];
    
    CGFloat spaceYStart = _courseLabel.bottom + 10;
    NSString *words = homeworkItem.words;
    if(words.length > 0){
        [_contentLabel setHidden:NO];
        [_contentLabel setWidth:_bgView.width - 10 * 2];
        [_contentLabel setText:words];
        [HomeWorkCell dynamicCalculationLabelHight:_contentLabel];
        [_contentLabel setOrigin:CGPointMake(10, spaceYStart)];
        spaceYStart = _contentLabel.bottom + 10;
    }
    else{
        [_contentLabel setHidden:YES];
    }
    
    if(homeworkItem.reply_close && [homeworkItem.reply_close_ctime length] > 0){
        [_endTimeLabel setHidden:NO];
        [_endTimeLabel setText:[NSString stringWithFormat:@"截止时间:%@",homeworkItem.reply_close_ctime]];
        [_endTimeLabel sizeToFit];
        [_endTimeLabel setOrigin:CGPointMake(10, spaceYStart)];
        spaceYStart = _endTimeLabel.bottom + 10;
    }
    else{
        [_endTimeLabel setHidden:YES];
    }

    [_extraInfoView setOrigin:CGPointMake(0, spaceYStart)];
    [_extraInfoView setHomeworkItem:homeworkItem];
    [_bgView setHeight:_extraInfoView.bottom];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width{
    HomeworkItem *homeworkItem = (HomeworkItem *)modelItem;
    CGFloat height = 36 + 10 * 2;
    NSString *words = homeworkItem.words;
    if(words.length > 0){
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width - 15 * 2 - 10 * 2, 0)];
        [contentLabel setFont:[UIFont systemFontOfSize:14]];
        [contentLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [contentLabel setNumberOfLines:0];
        [contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [contentLabel setText:words];
        [HomeWorkCell dynamicCalculationLabelHight:contentLabel];
        height += contentLabel.height + 10;
    }
    if(homeworkItem.reply_close && [homeworkItem.reply_close_ctime length] > 0){
        NSString *endStr = @"截止时间";
        CGSize endTimeSize = [endStr sizeForFont:[UIFont systemFontOfSize:12] size:CGSizeMake(width - 15 * 2 - 10 * 2, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
        height += endTimeSize.height + 10;
    }
    height += 45;
    return @(height + 15);
}

+ (void)dynamicCalculationLabelHight:(UILabel*) label{
    NSInteger n = 2;
    CGSize labelSize = {0, 0};
    labelSize = [self ZFYtextHeightFromTextString:label.text width:label.frame.size.width fontSize:label.font.pointSize];
    // NSLog(@"%f",label.font.pointSize);//获取 label的字体大小 //NSLog(@"%f",label.font.lineHeight);//获取label的在不同字体下的时候所需要的行高 //NSLog(@"%f",labelSize.height);//label计算行高
    CGFloat rate = label.font.lineHeight; //每一行需要的高度
    CGRect frame= label.frame;
    if (labelSize.height>rate*n)
    {
        frame.size.height = rate*n;
    }
    else
    {
        frame.size.height = labelSize.height;
    }
    label.frame = frame;
}
+ (CGSize)ZFYtextHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    CGSize size1 = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:size]}];
    return CGSizeMake(size1.width, rect.size.height);
}


@end
