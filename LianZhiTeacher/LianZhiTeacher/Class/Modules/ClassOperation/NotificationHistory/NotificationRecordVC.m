//
//  NotificationRecordVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/31.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationRecordVC.h"

@implementation NotificationRecordItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.moreOptionsButton setBackgroundColor:[UIColor colorWithHexString:@"28c4d8"]];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self.actualContentView addSubview:_titleLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setFont:[UIFont systemFontOfSize:14]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_timeLabel setText:@"05-11 11:23"];
        [self.actualContentView addSubview:_timeLabel];
        
        _audioImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"draft_audio"]];
        [_audioImageView setOrigin:CGPointMake(12, 40)];
        [self.actualContentView addSubview:_audioImageView];
        
        _photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"draft_photo"]];
        [_photoImageView setOrigin:CGPointMake(_audioImageView.right + 12, 40)];
        [self.actualContentView addSubview:_photoImageView];
        
        _videoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"draft_video"]];
        [_videoImageView setOrigin:CGPointMake(_photoImageView.right + 12, 40)];
        [self.actualContentView addSubview:_videoImageView];

        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self.actualContentView addSubview:_sepLine];
        
        [self.moreOptionsButton setHidden:YES];
    }
    return self;
}

- (CGFloat)contextMenuWidth
{
    return CGRectGetWidth(self.deleteButton.frame);
}
- (CGFloat)menuOptionButtonWidth{
    return 66;
}

- (void)setData{
    [_titleLabel setFrame:CGRectMake(12, 18, self.width - 12 * 2, 0)];
    [_titleLabel setText:@"今天要明上课很认真过，课上积极"];
    [_titleLabel sizeToFit];
    [self.moreOptionsButton setTitle:@"转发" forState:UIControlStateNormal];
    [_sepLine setFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
}

@end

@interface NotificationRecordVC ()
{
   
}
@end

@implementation NotificationRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}


- (void)clear{
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"NotificationRecordItemCell";
    NotificationRecordItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(cell == nil){
        cell = [[NotificationRecordItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        [cell setDelegate:self];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationRecordItemCell *itemCell = (NotificationRecordItemCell *)cell;
    [itemCell setData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - DAContextMenuCellDelegate
- (void)contextMenuCellDidSelectDeleteOption:(DAContextMenuCell *)cell{
    
}

- (void)contextMenuCellDidSelectMoreOption:(DAContextMenuCell *)cell{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
