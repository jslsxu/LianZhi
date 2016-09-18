//
//  NotificationDraftVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/31.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationDraftVC.h"
#import "NotificationSendVC.h"
@implementation NotificationDraftItemCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setSize:CGSizeMake(kScreenWidth, 70)];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self addSubview:_titleLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setFont:[UIFont systemFontOfSize:14]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [self addSubview:_timeLabel];
        
        _audioImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"draft_audio"]];
        [_audioImageView setOrigin:CGPointMake(12, 40)];
        [self addSubview:_audioImageView];
        
        _photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"draft_photo"]];
        [_photoImageView setOrigin:CGPointMake(_audioImageView.right + 12, 40)];
        [self addSubview:_photoImageView];
        
        _videoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"draft_video"]];
        [_videoImageView setOrigin:CGPointMake(_photoImageView.right + 12, 40)];
        [self addSubview:_videoImageView];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
    }
    return self;
}


- (void)setNotification:(NotificationSendEntity *)notification{
    _notification = notification;
    [_titleLabel setFrame:CGRectMake(12, 15, self.width - 12 * 2, 20)];
    NSString *title = _notification.words;
    if(title.length == 0){
        title = @"(正文内容为空)";
    }
    [_titleLabel setText:title];
    [_timeLabel sizeToFit];
    
    NSDate *curDate = [NSDate date];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:_notification.createTime];
    NSString *timeStr = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if(createDate.year == curDate.year){
        [formatter setDateFormat:@"MM-dd HH:mm"];
    }
    else{
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    timeStr = [formatter stringFromDate:createDate];
    [_timeLabel setText:timeStr];
    [_timeLabel sizeToFit];
    [_timeLabel setOrigin:CGPointMake(self.width - 10 - _timeLabel.width, 50 - _timeLabel.height / 2)];
    
    [_sepLine setFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
    [_audioImageView setHidden:!_notification.hasAudio];
    [_photoImageView setHidden:!_notification.hasImage];
    [_videoImageView setHidden:!_notification.hasVideo];
    CGFloat spaceXStart = 20;
    CGFloat centerY = 50;
    if(_notification.hasAudio){
        [_audioImageView setCenter:CGPointMake(spaceXStart, centerY)];
        spaceXStart += _audioImageView.width + 15;
    }
    if(_notification.hasImage){
        [_photoImageView setCenter:CGPointMake(spaceXStart, centerY)];
        spaceXStart += _photoImageView.width + 15;
    }
    if(_notification.hasVideo){
        [_videoImageView setCenter:CGPointMake(spaceXStart, centerY)];
    }

}

@end

@interface NotificationDraftVC ()<UITableViewDelegate, UITableViewDataSource>
{
    
}
@property (nonatomic, strong)UITableView* tableView;
@end

@implementation NotificationDraftVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDraftChanged) name:kDraftNotificationChanged object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];

}

- (EmptyHintView *)emptyView{
    if(_emptyView == nil){
        _emptyView = [[EmptyHintView alloc] initWithImage:@"NoDraft" title:@"暂时没有草稿记录"];
    }
    return _emptyView;
}

- (void)clear{
    LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提醒" message:@"是否清空全部未发草稿?" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"清空"];
    [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
    [alertView setDestructiveButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setDestructiveHandler:^(LGAlertView *alertView) {
        [[NotificationDraftManager sharedInstance] clearDraft];
    }];
    [alertView showAnimated:YES completionHandler:nil];
}

- (void)onDraftChanged{
    [self.tableView reloadData];
}

- (void)deleteDraft:(NotificationSendEntity *)sendEntity{
    [[NotificationDraftManager sharedInstance] removeDraft:sendEntity];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = [[NotificationDraftManager sharedInstance].draftArray count];
    [self showEmptyView:count == 0];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"NotificationDraftItemCell";
    NotificationDraftItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(cell == nil){
        cell = [[NotificationDraftItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    NotificationSendEntity *entity = [NotificationDraftManager sharedInstance].draftArray[indexPath.row];
    [cell setNotification:entity];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    NotificationSendEntity *entity = [NotificationDraftManager sharedInstance].draftArray[indexPath.row];
    LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提醒" message:@"是否删除该条草稿?" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除"];
    [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
    [alertView setDestructiveButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setDestructiveHandler:^(LGAlertView *alertView) {
        @strongify(self)
        [self deleteDraft:entity];
    }];
    [alertView showAnimated:YES completionHandler:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NotificationSendEntity *sendEntity = [[[NotificationDraftManager sharedInstance] draftArray] objectAtIndex:indexPath.row];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:sendEntity];
    NotificationSendEntity *copySendEntity = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NotificationSendVC *sendVC = [[NotificationSendVC alloc] initWithSendEntity:copySendEntity];
    [sendVC setSendType:NotificationSendDraft];
    [CurrentROOTNavigationVC pushViewController:sendVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
