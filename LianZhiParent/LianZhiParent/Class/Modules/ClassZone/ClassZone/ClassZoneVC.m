//
//  ClassZoneVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "ClassZoneVC.h"
#import "ClassAlbumVC.h"
#import "ActionView.h"
#import "SwitchClassVC.h"
#define kClassZoneShown                         @"ClassZoneShown"

@implementation ClassZoneHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor colorWithRed:19 / 255.0 green:48 / 255.0 blue:43 / 255.0 alpha:1.f]];
        
        CGFloat buttonWidth = 40;
        _albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_albumButton addTarget:self action:@selector(onAlbumButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_albumButton setImage:[UIImage imageNamed:@"ZoneAlbum"] forState:UIControlStateNormal];
        [_albumButton setFrame:CGRectMake(self.width - buttonWidth, self.height - 40 - buttonWidth, buttonWidth, buttonWidth)];
        [self addSubview:_albumButton];
        
        _appButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_appButton addTarget:self action:@selector(onAppButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_appButton setImage:[UIImage imageNamed:@"ZoneApp"] forState:UIControlStateNormal];
        [_appButton setFrame:CGRectMake(self.width - buttonWidth, _albumButton.top - buttonWidth, buttonWidth, buttonWidth)];
        [self addSubview:_appButton];
        
        _newpaperImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BlackboardText.png"]];
        [_newpaperImageView setOrigin:CGPointMake(20, 10)];
        [self addSubview:_newpaperImageView];
        
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, self.width - 30 - 40, self.height - 30 - 30)];
        [_contentLabel setUserInteractionEnabled:YES];
        [_contentLabel setTextColor:[UIColor whiteColor]];
        [_contentLabel setFont:[UIFont systemFontOfSize:16]];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self addSubview:_contentLabel];
        
        _brashImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Brash.png"]];
        [_brashImage setFrame:CGRectMake(15, frame.size.height - 12 - _brashImage.height, _brashImage.width, _brashImage.height)];
        [self addSubview:_brashImage];
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 12, self.width, 12)];
        [_bottomView setBackgroundColor:[UIColor colorWithRed:158 / 255.0 green:158 / 255.0 blue:158 / 255.0 alpha:1.f]];
        [self addSubview:_bottomView];
    }
    return self;
}

- (void)setNewsPaper:(NSString *)newsPaper
{
    _newsPaper = newsPaper;
    [_contentLabel setText:_newsPaper];
    //    [_contentLabel sizeToFit];
}

- (void)onAlbumButtonClicked
{
    if([self.delegate respondsToSelector:@selector(classZoneAlbumClicked)])
        [self.delegate classZoneAlbumClicked];
}

- (void)onAppButtonClicked
{
    if([self.delegate respondsToSelector:@selector(classZoneAppClicked)])
        [self.delegate classZoneAppClicked];
}

@end

@interface ClassZoneVC ()<ClassZoneItemCellDelegate>
@property (nonatomic, strong)ClassInfo *classInfo;
@end

@implementation ClassZoneVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL classOperationShow = [[userDefaults valueForKey:kClassZoneShown] boolValue];
    if(classOperationShow == NO)
    {
        [self addUserGuide];
        classOperationShow = YES;
        [userDefaults setValue:@(classOperationShow) forKey:kClassZoneShown];
        [userDefaults synchronize];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
//    self.title = @"班空间";
    self.shouldShowEmptyHint = YES;
    _switchView = [[ClassZoneClassSwitchView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    [_switchView setDelegate:self];
    [self.view addSubview:_switchView];
    [self.tableView setFrame:CGRectMake(0, _switchView.bottom, self.view.width, self.view.height - _switchView.bottom)];
    [self onCurChildChanged];
    
    _headerView = [[ClassZoneHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 160)];
    [_headerView setDelegate:self];
    [self.tableView setTableHeaderView:_headerView];
    
    [self bindTableCell:@"ClassZoneItemCell" tableModel:@"ClassZoneModel"];
    [self setSupportPullDown:YES];
    [self setSupportPullUp:YES];
    [self requestData:REQUEST_REFRESH];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurChildChanged) name:kUserCenterChangedCurChildNotification object:nil];
    
    _replyBox = [[ReplyBox alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - REPLY_BOX_HEIGHT, self.view.width, REPLY_BOX_HEIGHT)];
    [_replyBox setDelegate:self];
    [ApplicationDelegate.homeVC.view addSubview:_replyBox];
    _replyBox.hidden = YES;
}

- (void)addUserGuide
{
    UIView *parentView = [UIApplication sharedApplication].keyWindow;
    
    UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [coverButton addTarget:self action:@selector(onCoverButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [coverButton setFrame:parentView.bounds];
    [coverButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [parentView addSubview:coverButton];
    
    UIImageView *image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ClassZoneGuide1.png"]];
    [image1 setOrigin:CGPointMake(coverButton.width - image1.width - 10, 180)];
    [coverButton addSubview:image1];
    
    UIImageView *image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ClassZoneSwipe.png"]];
    [image2 setOrigin:CGPointMake((self.view.width - image2.width) / 2, image1.bottom + 100)];
    [coverButton addSubview:image2];
}

- (void)onCoverButtonClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [button removeFromSuperview];
}

- (void)onCurChildChanged
{
    if([UserCenter sharedInstance].curChild.classes.count > 0)
    {
        ClassInfo *curClassInfo = [UserCenter sharedInstance].curChild.classes[0];
        [self setClassInfo:curClassInfo];
        [_switchView setClassInfo:self.classInfo];
    }
    else
    {
        TNButtonItem *item = [TNButtonItem itemWithTitle:@"确定" action:nil];
        TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"未找到相关班级，请联系学校教师或直接联系客服人员" buttonItems:@[item]];
        [alertView show];
    }
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"class/space"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    [task setObserver:self];
    
    ClassZoneModel *model = (ClassZoneModel *)self.tableViewModel;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    if(requestType == REQUEST_GETMORE)
        [params setValue:@"old" forKey:@"mode"];
    else
        [params setValue:@"new" forKey:@"mode"];
    [params setValue:model.minID forKey:@"min_id"];
    [params setValue:self.classInfo.classID forKey:@"class_id"];
    
    [params setValue:@(20) forKey:@"num"];
    [task setParams:params];
    return task;
}

#pragma mark - ClassZoneItemCellDelegate
- (void)onResponseClickedAtTarget:(UserInfo *)targetUser
{
    _replyBox.hidden = NO;
    [_replyBox assignFocus];
}

- (void)onActionClicked:(ClassZoneItemCell *)cell
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGPoint point = [cell convertPoint:cell.actionButton.center toView:keyWindow];
    ActionView *actionView = [[ActionView alloc] initWithPoint:point action:^(NSInteger index) {
        if(index == 0)
        {
            
        }
        else if(index == 1)
        {
            _replyBox.hidden = NO;
            [_replyBox assignFocus];
        }
        else
        {
            
        }
    }];
    [actionView show];
}

#pragma mark TNBaseTableViewController
- (BOOL)supportCache
{
    return YES;
}

- (NSString *)cacheFileName
{
    return [NSString stringWithFormat:@"%@_%@_%@",NSStringFromClass([self class]),[UserCenter sharedInstance].curChild.uid,self.classInfo.classID];
}


#pragma mark - ClassZoneSwitchDelegate
- (void)classZoneSwitch
{
    __weak typeof(self) wself = self;
    SwitchClassVC *switchClassVC = [[SwitchClassVC alloc] init];
    [switchClassVC setClassInfo:self.classInfo];
    [switchClassVC setCompletion:^(ClassInfo *classInfo) {
        wself.classInfo = classInfo;
        [_switchView setClassInfo:wself.classInfo];
        [wself requestData:REQUEST_REFRESH];
    }];
    [self.navigationController pushViewController:switchClassVC animated:YES];
}
#pragma mark - ClassZoneHeaderDelegate
- (void)classZoneAlbumClicked
{
    ClassAlbumVC *photoBrowser = [[ClassAlbumVC alloc] init];
    [photoBrowser setShouldShowEmptyHint:YES];
    [photoBrowser setClassID:self.classInfo.classID];
    [self.navigationController pushViewController:photoBrowser animated:YES];
}

- (void)classZoneAppClicked
{
    ClassAppVC *appVC = [[ClassAppVC alloc] init];
    [appVC setClassInfo:self.classInfo];
    [CurrentROOTNavigationVC pushViewController:appVC animated:YES];
}

#pragma mark - ReplyBoxDelegate
- (void)onActionViewCommit:(NSString *)content
{
    _replyBox.hidden = YES;
    [_replyBox setText:@""];
    [_replyBox resignFocus];
}

- (void) onActionViewCancel
{
    [_replyBox setHidden:YES];
    [_replyBox setText:@""];
    [_replyBox resignFocus];
}

#pragma mark TNbaseViewControllerDelegate
- (void)TNBaseTableViewControllerRequestSuccess
{
    NSString *newsPaper = [(ClassZoneModel *)self.tableViewModel newsPaper];
    [_headerView setNewsPaper:newsPaper];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassZoneItemCell *itemCell = (ClassZoneItemCell *)cell;
    [itemCell setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
