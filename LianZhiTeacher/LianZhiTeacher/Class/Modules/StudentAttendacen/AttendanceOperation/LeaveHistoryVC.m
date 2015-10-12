//
//  LeaveHistoryVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/8.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "LeaveHistoryVC.h"

@implementation LeaveHistoryItem

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    
}

@end

@implementation LeaveHistoryModel

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    return YES;
}

@end

@implementation LeaveHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40, 40)];
        [self addSubview:_typeImageView];
        
        _startLabel = [[UILabel alloc] initWithFrame:CGRectMake(_typeImageView.right + 10, 10, self.width - 60 - (_typeImageView.right + 10), 20)];
        [_startLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_startLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:_startLabel];
        
        _endLabel = [[UILabel alloc] initWithFrame:CGRectMake(_typeImageView.right + 10, _startLabel.bottom, self.width - 60 - (_typeImageView.right + 10), 20)];
        [_endLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_endLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:_endLabel];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(_statusLabel.right, 10, 50, 20)];
        [_statusLabel setTextAlignment:NSTextAlignmentRight];
        [_statusLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_statusLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:_statusLabel];

        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_statusLabel.right, _statusLabel.bottom, 50, 20)];
        [_timeLabel setTextAlignment:NSTextAlignmentRight];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_timeLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:_timeLabel];
    }
    return self;
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    return @(60);
}

@end

@interface LeaveHistoryVC ()

@end

@implementation LeaveHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self bindTableCell:@"LeaveHistoryCell" tableModel:@"LeaveHistoryModel"];
    [self requestData:REQUEST_REFRESH];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
