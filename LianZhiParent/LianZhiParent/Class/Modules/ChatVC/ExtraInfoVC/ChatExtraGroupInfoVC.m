//
//  ChatExtraGroupInfoVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/3.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ChatExtraGroupInfoVC.h"
#import "ClassMemberVC.h"
#import "SearchChatMessageVC.h"
@implementation ChatExtraGroupInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        [self.textLabel setFont:[UIFont systemFontOfSize:15]];
        [self.textLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self.textLabel setText:@"群头像"];
        _logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [_logoView.layer setCornerRadius:30];
        [_logoView.layer setMasksToBounds:YES];
        [_logoView setUserInteractionEnabled:YES];
        [_logoView setOrigin:CGPointMake(self.width - 35 - _logoView.width, (80 - _logoView.height) / 2)];
        [self addSubview:_logoView];

        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
        [_logoView addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setLogoUrl:(NSString *)logoUrl{
    _logoUrl = [logoUrl copy];
    [_logoView sd_setImageWithURL:[NSURL URLWithString:_logoUrl] placeholderImage:[UIImage imageNamed:@"NoLogoDefault.png"]];

}
- (void)onTap{
    [[PBImageController sharedInstance] showForView:_logoView placeHolder:_logoView.image url:self.logoUrl];
    //[self _showPhotoBrowser:_logoView];
}
/*
- (void)_showPhotoBrowser:(UIView *)sender {
    PBViewController *pbViewController = [PBViewController new];
    pbViewController.pb_dataSource = self;
    pbViewController.pb_delegate = self;
    pbViewController.pb_startPage = 0;
    [CurrentROOTNavigationVC presentViewController:pbViewController animated:YES completion:nil];
}

- (NSInteger)numberOfPagesInViewController:(PBViewController *)viewController {
    return 1;
}

- (void)viewController:(PBViewController *)viewController presentImageView:(UIImageView *)imageView forPageAtIndex:(NSInteger)index progressHandler:(void (^)(NSInteger, NSInteger))progressHandler {
    UIImage *placeholder = _logoView.image;
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.logoUrl]
                 placeholderImage:placeholder
                          options:0
                         progress:progressHandler
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        }];
}

- (UIView *)thumbViewForPageAtIndex:(NSInteger)index {
    return _logoView;
}

#pragma mark - PBViewControllerDelegate

- (void)viewController:(PBViewController *)viewController didSingleTapedPageAtIndex:(NSInteger)index presentedImage:(UIImage *)presentedImage {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewController:(PBViewController *)viewController didLongPressedPageAtIndex:(NSInteger)index presentedImage:(UIImage *)presentedImage {
    if(presentedImage){
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:nil message:nil style:LGAlertViewStyleActionSheet buttonTitles:@[@"保存到相册"] cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
        [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
        [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
        [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
        [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
            [Utility saveImageToAlbum:presentedImage];
        }];
        [alertView showAnimated:YES completionHandler:nil];
    }
}
*/
@end

@interface ChatExtraGroupInfoVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView*   tableView;
@property (nonatomic, strong)UISwitch*      disturbSwitch;
@property (nonatomic, strong)NSMutableArray*    memberArray;
@property (nonatomic, strong)ClassInfo*     classInfo;
@end

@implementation ChatExtraGroupInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"聊天信息";
    [self.view addSubview:self.tableView];
    [self loadData];
}

- (UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSeparatorColor:kSepLineColor];
    }
    return _tableView;
}

- (UISwitch *)disturbSwitch{
    if(_disturbSwitch == nil){
        _disturbSwitch = [[UISwitch alloc] init];
        [_disturbSwitch addTarget:self action:@selector(onDisturbValueChanged) forControlEvents:UIControlEventValueChanged];
    }
    [_disturbSwitch setOn:self.quietModeOn];
    return _disturbSwitch;
}

- (NSMutableArray *)memberArray{
    if(!_memberArray){
        _memberArray = [NSMutableArray array];
    }
    return _memberArray;
}

- (void)onDisturbValueChanged{
    BOOL quietModeOn = !self.quietModeOn;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.groupID forKey:@"from_id"];
    [params setValue:kStringFromValue(self.chatType) forKey:@"from_type"];
    [params setValue:quietModeOn ? @"close" : @"open" forKey:@"sound"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/set_thread" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        self.quietModeOn = quietModeOn;
        if(self.alertChangeCallback){
            self.alertChangeCallback(quietModeOn);
        }
    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)onGroupChatValueChanged{
    
}

- (void)loadData{
    for (ClassInfo *classInfo in [UserCenter sharedInstance].curChild.classes) {
        if([classInfo.classID isEqualToString:self.groupID]){
            self.classInfo = classInfo;
            [self.memberArray addObjectsFromArray:classInfo.teachers];
            for (ChildInfo *childInfo in classInfo.students) {
                [self.memberArray addObjectsFromArray:childInfo.family];
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 2;
    }
    else
        return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row == 0)
        return 80;
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == 0 && row == 0){
        NSString *reuseID = @"ChatExtraGroupInfoCell";
        ChatExtraGroupInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if(nil == cell){
            cell = [[ChatExtraGroupInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        }
        [cell setLogoUrl:self.classInfo.logo];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else{
//        UIImageView* accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        NSString *reuseID = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if(nil == cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
            [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
            [cell.textLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        }
        if(section == 0){
            [cell.textLabel setText:[NSString stringWithFormat:@"全部群成员(%zd)", self.memberArray.count]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        else if(section == 1){
            if(row == 0){
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textLabel setText:@"消息免打扰"];
                [cell setAccessoryView:self.disturbSwitch];
            }
            else if(row == 1){
                [cell.textLabel setText:@"查找聊天记录"];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            else if(row == 2){
                [cell.textLabel setText:@"清空聊天记录"];
                [cell setAccessoryView:nil];
            }
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == 0){
        if(row == 0){
            
        }
        else if(row == 1){
            ClassMemberVC *memberVC = [[ClassMemberVC alloc] init];
            [memberVC setClassID:self.groupID];
            [self.navigationController pushViewController:memberVC animated:YES];
        }
    }
    else if(section == 1){
        if(row == 0){
            
        }
        else if(row == 1){
            SearchChatMessageVC*    searchVC = [[SearchChatMessageVC alloc] init];
            [self.navigationController pushViewController:searchVC animated:YES];
        }
        else if(row == 2){
            @weakify(self)
            LGAlertView *alertView = [LGAlertView alertViewWithTitle:@"确定要清空聊天记录吗?" message:nil style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除"];
            [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
            [alertView setDestructiveButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
            [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
            [alertView setDestructiveHandler:^(LGAlertView *alertView) {
                @strongify(self)
                if(self.clearChatRecordCallback){
                    self.clearChatRecordCallback(^(BOOL success){
                        if(success){
                            [ProgressHUD showSuccess:@"聊天记录已清除"];
                        }
                    });
                }
            }];
            [alertView showAnimated:YES completionHandler:nil];
        }
    }
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
