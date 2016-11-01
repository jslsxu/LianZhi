//
//  MarkHomeworkVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "MarkHomeworkVC.h"
#import "HomeworkMarkHeaderView.h"
#import "HomeworkMarkFooterView.h"
#import "ZYBannerView.h"


@interface MarkHomeworkVC ()<ZYBannerViewDelegate, ZYBannerViewDataSource, HomeworkMarkHeaderDelegate>
@property (nonatomic, strong)UIView*                    contentView;
@property (nonatomic, strong)HomeworkMarkHeaderView*    headerView;
@property (nonatomic, strong)ZYBannerView*              circleView;
@property (nonatomic, strong)HomeworkMarkFooterView*    footerView;
@property (nonatomic, strong)HomeworkMarkItem*          markItem;
@property (nonatomic, strong)NSMutableDictionary*       markMap;
@end

@implementation MarkHomeworkVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        [self addKeyboardNotifications];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.markItem = [[HomeworkMarkItem alloc] init];
    self.title = @"批阅作业";
    for (HomeworkStudentInfo *studentInfo in self.homeworkArray) {
        HomeworkTeacherMark* teacherMark = [[HomeworkTeacherMark alloc] initWithPhotoArray:studentInfo.s_answer.pics];
        [self.markMap setValue:teacherMark forKey:studentInfo.student.uid];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"批阅" style:UIBarButtonItemStylePlain target:self action:@selector(mark)];
    [self.view addSubview:[self contentView]];
    [self.contentView addSubview:[self headerView]];
    [self.contentView addSubview:[self footerView]];
    [self.contentView addSubview:[self circleView]];
    
    [self showHomeworkWithIndex:self.curIndex];
}

- (void)onKeyboardWillShow:(NSNotification *)note{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView animateWithDuration:[duration floatValue] delay:0 options:curve.integerValue animations:^{
        [self.contentView setY:-keyboardBounds.size.height];
    } completion:nil];
}

- (void)onKeyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView animateWithDuration:[duration floatValue] delay:0 options:curve.integerValue animations:^{
        [self.contentView setY:0];
    } completion:nil];
}

- (NSMutableDictionary *)markMap{
    if(_markMap == nil){
        _markMap = [NSMutableDictionary dictionary];
    }
    return _markMap;
}

- (void)mark{
    __weak typeof(self) wself = self;
    HomeworkStudentInfo *studentInfo = self.homeworkArray[self.curIndex];
    if(![studentInfo.s_answer marked]){
        HomeworkTeacherMark *mark = self.markMap[studentInfo.student.uid];
        if(![mark isEmpty]){
            NSString *markDetail = [mark modelToJSONString];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:markDetail forKey:@"mark_detail"];
            [params setValue:self.homeworkItem.eid forKey:@"eid"];
            [params setValue:studentInfo.student.uid forKey:@"child_id"];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/marking" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                [hud hide:NO];
                [ProgressHUD showHintText:@"批阅成功"];
                [studentInfo setMark_detail:markDetail];
                [studentInfo.s_answer setTeacherMark:[HomeworkTeacherMark markWithString:markDetail]];
                [wself showHomeworkWithIndex:wself.curIndex];
            } fail:^(NSString *errMsg) {
                [hud hide:NO];
                [ProgressHUD showError:errMsg];
            }];
        }
       
    }
}

- (UIView *)contentView{
    if(_contentView == nil){
        _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
        [_contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    }
    return _contentView;
}

- (HomeworkMarkHeaderView *)headerView{
    if(_headerView == nil){
        _headerView = [[HomeworkMarkHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 110)];
        [_headerView setDelegate:self];
    }
    return _headerView;
}

- (ZYBannerView *)circleView{
    if(_circleView == nil){
        _circleView = [[ZYBannerView alloc] initWithFrame:CGRectMake(0, [self.headerView bottom], self.view.width, self.view.height - 120 - 64 - (self.headerView.bottom))];
        [_circleView setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
        [_circleView setDelegate:self];
        [_circleView setDataSource:self];

    }
    return _circleView;
}

- (HomeworkMarkFooterView *)footerView{
    if(_footerView == nil){
        _footerView = [[HomeworkMarkFooterView alloc] initWithFrame:CGRectMake(0, self.view.height - 120 - 64, self.view.width, 120)];
    }
    return _footerView;
}

- (void)showHomeworkWithIndex:(NSInteger)index{
    self.curIndex = index;
    [self.headerView setCanPre:self.curIndex > 0];
    [self.headerView setCanNext:self.curIndex < [self.homeworkArray count] - 1];
    HomeworkStudentInfo *studentInfo = self.homeworkArray[self.curIndex];
    [self.navigationItem.rightBarButtonItem setEnabled:[studentInfo.mark_detail length] == 0];
    
    [self.headerView setStudentHomeworkInfo:studentInfo];
    HomeworkTeacherMark *mark = self.markMap[studentInfo.student.uid];
    BOOL haveMarked = [studentInfo.mark_detail length] > 0;
    [self.footerView setTeacherMark:mark];
    [self.footerView setUserInteractionEnabled:!haveMarked];
    if(haveMarked){
        [self.footerView clearMark];
    }
    [self.circleView reloadData];
}

#pragma mark - HomeworkMarkHeaderDelegate
- (void)requestPreHomework{
    if(self.curIndex > 0){
        [self showHomeworkWithIndex:self.curIndex - 1];
    }
}

- (void)requestNextHomework{
    if(self.curIndex < [self.homeworkArray count] - 1){
        [self showHomeworkWithIndex:self.curIndex + 1];
    }
}

#pragma mark - ZYbannerDelegate
- (NSInteger)numberOfItemsInBanner:(ZYBannerView *)banner{
    HomeworkStudentInfo *studentInfo = self.homeworkArray[self.curIndex];
    HomeworkTeacherMark* teacherMark = self.markMap[studentInfo.student.uid];
    return [teacherMark.marks count];
}

- (UIView *)banner:(ZYBannerView *)banner viewForItemAtIndex:(NSInteger)index{
    HomeworkPhotoImageView *imageView = [[HomeworkPhotoImageView alloc] initWithFrame:banner.bounds];
    HomeworkStudentInfo *studentInfo = self.homeworkArray[self.curIndex];
    HomeworkTeacherMark* teacherMark = self.markMap[studentInfo.student.uid];
    [imageView setCanEdit:studentInfo.mark_detail.length == 0];
    [imageView setMarkItem:teacherMark.marks[index]];
    return imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
