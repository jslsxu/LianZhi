//
//  LeaveDetailView.m
//  LianZhiParent
//
//  Created by jslsxu on 16/1/12.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "LeaveDetailView.h"

@implementation LeaveDetailView

- (instancetype)initWithVacationItem:(VacationHistoryItem *)leaveItem
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        self.leaveItem = leaveItem;
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgButton setFrame:self.bounds];
        [_bgButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_bgButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
        [self addSubview:_bgButton];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(30, 100, self.width - 30 * 2, self.height - 100 * 2)];
        NSInteger cornerRadius = 15;
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, cornerRadius, 0);
        CGPathAddLineToPoint(path, NULL, _contentView.width - cornerRadius, 0);
        CGPathAddArcToPoint(path, NULL, _contentView.width, 0, _contentView.width, cornerRadius, cornerRadius);
        CGPathAddLineToPoint(path, NULL, _contentView.width, _contentView.height);
        CGPathAddLineToPoint(path, NULL, 0, _contentView.height);
        CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
        CGPathAddArcToPoint(path, NULL, 0, 0, cornerRadius, 0, cornerRadius);
        CGPathCloseSubpath(path);
        [shapeLayer setPath:path];
        CFRelease(path);
        _contentView.layer.mask = shapeLayer;
        [_contentView.layer setMasksToBounds:YES];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        
        
        UIView* statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentView.width, 100)];
        [statusView setBackgroundColor:[UIColor colorWithHexString:@"87dd51"]];
        [_contentView addSubview:statusView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, statusView.width / 2, statusView.height)];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setFont:[UIFont systemFontOfSize:18]];
        [nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [nameLabel setText:[UserCenter sharedInstance].curChild.name];
        [statusView addSubview:nameLabel];
        
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(statusView.width / 2, 0, statusView.width / 2, statusView.height)];
        [statusLabel setTextColor:[UIColor colorWithHexString:@"f03f64"]];
        [statusLabel setFont:[UIFont systemFontOfSize:18]];
        [statusLabel setTextAlignment:NSTextAlignmentCenter];
        NSString *dateStr = nil;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *leaveDate = [dateFormatter dateFromString:leaveItem.leaveDate];
        if([leaveDate isToday])
            dateStr = @"今日";
        else
        {
            [dateFormatter setDateFormat:@"MM月dd日"];
            dateStr = [dateFormatter stringFromDate:leaveDate];
        }
        NSString *statusStr = nil;
        if(leaveItem.leaveType == LeaveTypeAbsence)
            statusStr = @"缺勤";
        else if(leaveItem.leaveType == LeaveTypeLeave)
            statusStr = @"请假";
        else
            statusStr = @"出勤";
        [statusLabel setText:[NSString stringWithFormat:@"%@%@",dateStr, statusStr]];
        [statusView addSubview:statusLabel];
        
        NSInteger spaceYEnd = _contentView.height;
        if(leaveItem.leaveType == LeaveTypeLeave)
        {
            UIView *bottomInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, _contentView.height - 90, _contentView.width, 90)];
            
            UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bottomInfoView.width, kLineHeight)];
            [topLine setBackgroundColor:kSepLineColor];
            [bottomInfoView addSubview:topLine];
            
            NSArray *strArray = @[@"请假开始:",leaveItem.leaveTime,@"请假结束:",leaveItem.arriveTime];
            NSInteger infoWidth = (_contentView.width - 20 * 2) / 2;
            for (NSInteger i = 0; i < 2; i++)
            {
                for (NSInteger j = 0; j < 2; j++)
                {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20 + infoWidth * j, 45 * i, infoWidth, 45)];
                    [label setFont:[UIFont systemFontOfSize:14]];
                    [label setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
                    if(j == 1)
                        [label setTextAlignment:NSTextAlignmentRight];
                    [label setText:strArray[i * 2 + j]];
                    [bottomInfoView addSubview:label];
                }
            }
            
            [_contentView addSubview:bottomInfoView];
            spaceYEnd = bottomInfoView.y;
        }
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, statusView.bottom + 20, _contentView.width - 20 * 2, spaceYEnd - statusView.bottom - 20 * 2)];
        [infoLabel setNumberOfLines:0];
        [infoLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [infoLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [infoLabel setFont:[UIFont systemFontOfSize:14]];
        [infoLabel setText:leaveItem.remark];
        [self addSubview:_contentView];
        
        UIImageView *bottomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LeaveDetailBottom"]];
        [bottomView setFrame:CGRectMake(_contentView.x, _contentView.bottom, _contentView.width, 5.5)];
        [self addSubview:bottomView];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:[UIImage imageNamed:@"AttendanceDetailClose"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setFrame:CGRectMake(_contentView.right - 20, _contentView.top - 20, 40, 40)];
        [self addSubview:closeButton];
    }
    return self;
}

- (void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    self.alpha = 0.f;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        
    }];
}

@end
