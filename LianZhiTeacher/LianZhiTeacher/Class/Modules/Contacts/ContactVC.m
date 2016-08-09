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
@interface ContactVC (){
    ContactClassStudentView*     _parentView;
    ContactTeacherView*         _teacherView;
}
@property (nonatomic, strong)ContactModel*  contactModel;
@property (nonatomic, strong)UISegmentedControl*    segmentCtrl;
@end

@implementation ContactVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kUserCenterChangedSchoolNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kUserInfoChangedNotification object:nil];
    }
    return self;
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
    
    [self reloadData];

    [[UserCenter sharedInstance] updateUserInfo];
}

- (void)reloadData{
    [self.contactModel refresh];
    if(self.contactModel.titleArray.count > 0){
        [_parentView setClassArray:self.contactModel.classes];
        [_teacherView setTeachers:self.contactModel.teachers];
        [self.navigationItem setTitleView:nil];
        [self setSegmentCtrl:nil];
        [self.navigationItem setTitleView:[self segmentCtrl]];
        [self.segmentCtrl setSelectedSegmentIndex:0];
        [self onValueChanged];
    }
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
