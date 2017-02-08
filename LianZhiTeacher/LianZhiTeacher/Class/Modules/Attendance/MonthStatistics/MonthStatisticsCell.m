//
//  MonthStatisticsCell.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/23.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "MonthStatisticsCell.h"
#import "MonthStatisticsListModel.h"
@interface MonthStatisticsCell ()
@property (nonatomic, strong)AvatarView* avatar;
@property (nonatomic, strong)UILabel* nameLabel;
@property (nonatomic, strong)UILabel* attendanceNumLabel;
@property (nonatomic, strong)UILabel* offNumLabel;
@property (nonatomic, strong)UIView* sepLine;
@end

@implementation MonthStatisticsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.avatar = [[AvatarView alloc] initWithRadius:18];
        [self.avatar setOrigin:CGPointMake(10, (60 - self.avatar.height) / 2)];
        [self addSubview:self.avatar];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.nameLabel setFont:[UIFont systemFontOfSize:15]];
        [self.nameLabel setTextColor:kColor_33];
        [self addSubview:self.nameLabel];
        
        self.attendanceNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width / 2, 0, self.width / 4, 60)];
        [self.attendanceNumLabel setTextAlignment:NSTextAlignmentCenter];
        [self.attendanceNumLabel setFont:[UIFont systemFontOfSize:15]];
        [self.attendanceNumLabel setTextColor:kCommonTeacherTintColor];
        [self addSubview:self.attendanceNumLabel];
        
        self.offNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.attendanceNumLabel.right, 0, self.width / 4, 60)];
        [self.offNumLabel setTextAlignment:NSTextAlignmentCenter];
        [self.offNumLabel setFont:[UIFont systemFontOfSize:15]];
        [self.offNumLabel setTextColor:kRedColor];
        [self addSubview:self.offNumLabel];
    
        self.sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [self.sepLine setBackgroundColor:kSepLineColor];
        [self.sepLine setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [self addSubview:self.sepLine];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem{
    MonthStatisticsItem* item = (MonthStatisticsItem *)modelItem;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:item.child_info.avatar] placeholderImage:nil];
    [self.nameLabel setText:item.child_info.name];
    [self.nameLabel sizeToFit];
    [self.nameLabel setOrigin:CGPointMake(self.avatar.right + 5, (60 - self.nameLabel.height) / 2)];
    
    [self.attendanceNumLabel setText:kStringFromValue(item.attendance)];
    
    [self.offNumLabel setText:kStringFromValue(item.absence)];
}

- (void)setRow:(NSInteger)row{
    _row = row;
    if(_row % 2 == 0){
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        [self setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    }
}

- (void)setShowSepLine:(BOOL)showSepLine{
    _showSepLine = showSepLine;
    [self.sepLine setHidden:!self.showSepLine];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width{
    return @(60);
}
@end
