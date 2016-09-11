//
//  ContactVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/3.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ContactVC.h"
#import "ContactClassStudentView.h"
#import "ContactTeacherView.h"
#import "ContactModel.h"
#import "ContactsLoadingView.h"
@interface ContactVC (){
    ContactClassStudentView*     _parentView;
    ContactTeacherView*         _teacherView;
}
@property (nonatomic, strong)ContactModel*  contactModel;
@property (nonatomic, strong)UISegmentedControl*    segmentCtrl;
@property (nonatomic, strong)ContactsLoadingView*   contactsLoadingView;
@end

@implementation ContactVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kUserCenterChangedSchoolNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kUserInfoVCNeedRefreshNotificaiotn object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItems = [ApplicationDelegate.homeVC commonLeftBarButtonItems];
    [[UserCenter sharedInstance] updateSchoolInfo];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationItem.leftBarButtonItems = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contactModel = [[ContactModel alloc] init];
    
    _parentView = [[ContactClassStudentView alloc] initWithFrame:self.view.bounds];
    [_parentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:_parentView];
    
    _teacherView = [[ContactTeacherView alloc] initWithFrame:self.view.bounds];
    [_teacherView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:_teacherView];
    
    [self.view addSubview:[self contactsLoadingView]];
    
    [self reloadData];
}

- (void)reloadData{
    [self.contactModel refresh];
    NSInteger selectedSegmentIndex = [self.segmentCtrl selectedSegmentIndex];
    NSInteger titleCount = [self.contactModel.titleArray count];
    NSInteger titleIndex = MIN(selectedSegmentIndex, titleCount - 1);
    NSInteger originalIndex = MAX(titleIndex, 0);
    if(self.contactModel.titleArray.count > 0){
        [_parentView setClassArray:self.contactModel.classes];
        [_teacherView setTeachers:self.contactModel.teachers];
        [self.navigationItem setTitleView:nil];
        [self setSegmentCtrl:nil];
        [self.navigationItem setTitleView:[self segmentCtrl]];
        [self.segmentCtrl setSelectedSegmentIndex:originalIndex];
        [self onValueChanged];
        [self.contactsLoadingView dismiss];
    }
    else{
        [self.contactsLoadingView show];
    }
}

- (ContactsLoadingView *)contactsLoadingView{
    if(!_contactsLoadingView){
        _contactsLoadingView = [[ContactsLoadingView alloc] initWithFrame:CGRectZero];
        [_contactsLoadingView setOrigin:CGPointMake((self.view.width - _contactsLoadingView.width) / 2, (self.view.height - _contactsLoadingView.height ) / 2)];
    }
    return _contactsLoadingView;
}

- (UISegmentedControl *)segmentCtrl{
    if(_segmentCtrl == nil){
        _segmentCtrl = [[UISegmentedControl alloc] initWithItems:self.contactModel.titleArray];
        [_segmentCtrl addTarget:self action:@selector(onValueChanged) forControlEvents:UIControlEventValueChanged];
        [_segmentCtrl setWidth:140];
    }
    return _segmentCtrl;
}

- (void)onValueChanged{
    NSInteger index = [self.segmentCtrl selectedSegmentIndex];
    NSString *title = [self.segmentCtrl titleForSegmentAtIndex:index];
    if([title isEqualToString:kParentTitle]){
        [_parentView setHidden:NO];
        [_teacherView setHidden:YES];
    }
    else{
        [_parentView setHidden:YES];
        [_teacherView setHidden:NO];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
