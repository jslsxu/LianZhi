//
//  GrowthRecordChildSelectVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 17/2/8.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "GrowthRecordChildSelectVC.h"
#import "GrowthSegmentCtrl.h"
#import "DDCollectionViewHorizontalLayout.h"

#define kStudentSelectedStatusChangedNotification @"StudentSelectedStatusChanged"

@interface GrowthRecordChildSelectItemCell ()
@property (nonatomic, strong)AvatarView* avatarView;
@property (nonatomic, strong)UILabel* nameLabel;
@end

@implementation GrowthRecordChildSelectItemCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.avatarView = [[AvatarView alloc] initWithRadius:20];
        [self addSubview:self.avatarView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 25)];
        [self.nameLabel setFont:[UIFont systemFontOfSize:14]];
        [self.nameLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self.nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.nameLabel];
        
        [self.avatarView setOrigin:CGPointMake((self.width - self.avatarView.width) / 2, (self.height - (40 + 25)) / 2)];
        [self.nameLabel setY:self.avatarView.bottom];
    }
    return self;
}

- (void)setStudentInfo:(GrowthStudentInfo *)studentInfo{
    _studentInfo = studentInfo;
    
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:_studentInfo.avatar] placeholderImage:nil];
    [self.nameLabel setText:_studentInfo.name];
}

@end

@interface GrowthRecordChildSelectCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong)UIView* headerView;
@property (nonatomic, strong)AvatarView* avatarView;
@property (nonatomic, strong)UILabel* classNameLabel;
@property (nonatomic, strong)UIImageView* rightArrow;
@property (nonatomic, strong)UIView* redDot;

@property (nonatomic, strong)GrowthSegmentCtrl* segmentCtrl;
@property (nonatomic, strong)UICollectionView* collectionView;
@end

@implementation GrowthRecordChildSelectCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
        [self addSubview:self.headerView];
        
        UIView* topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.headerView.width, kLineHeight)];
        [topLine setBackgroundColor:kSepLineColor];
        [self.headerView addSubview:topLine];
        
        self.avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
        [self.headerView addSubview:self.avatarView];
        
        self.classNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.classNameLabel setFont:[UIFont systemFontOfSize:15]];
        [self.classNameLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [self.headerView addSubview:self.classNameLabel];
        
        self.rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        [self.rightArrow setOrigin:CGPointMake(self.headerView.width - 10 - self.rightArrow.width, (self.headerView.height - self.rightArrow.height) / 2)];
        [self.headerView addSubview:self.rightArrow];
        
        self.redDot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        [self.redDot.layer setCornerRadius:3];
        [self.redDot.layer setMasksToBounds:YES];
        [self.redDot setBackgroundColor:kRedColor];
        [self.redDot setOrigin:CGPointMake(self.rightArrow.left - 5 - self.redDot.width, (self.headerView.height - self.redDot.height) / 2)];
        [self.headerView addSubview:self.redDot];
        
        UIView* sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.height - kLineHeight, self.headerView.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [self.headerView addSubview:sepLine];
        
        self.segmentCtrl = [[GrowthSegmentCtrl alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, self.width, 40)];
        [self.segmentCtrl setIndexChanged:^(NSInteger selectedIndex) {
            
        }];
        [self addSubview:self.segmentCtrl];
        
        DDCollectionViewHorizontalLayout* layout = [[DDCollectionViewHorizontalLayout alloc] init];
        [layout setRowCount:2];
        [layout setItemCountPerRow:5];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [layout setMinimumLineSpacing:0];
        [layout setMinimumInteritemSpacing:0];
        [layout setItemSize:CGSizeMake((self.width) / 5, 80)];
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.segmentCtrl.bottom, self.width, 160) collectionViewLayout:layout];
        [self.collectionView setBackgroundColor:[UIColor whiteColor]];
        [self.collectionView setShowsHorizontalScrollIndicator:NO];
        [self.collectionView setPagingEnabled:YES];
        [self.collectionView setDelegate:self];
        [self.collectionView setDataSource:self];
        [self.collectionView registerClass:[GrowthRecordChildSelectItemCell class] forCellWithReuseIdentifier:@"GrowthRecordChildSelectItemCell"];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem{
    GrowthClassInfo* classInfo = (GrowthClassInfo *)modelItem;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[classInfo logo]] placeholderImage:nil];
    [self.classNameLabel setText:classInfo.name];
    [self.classNameLabel sizeToFit];
    [self.classNameLabel setOrigin:CGPointMake(self.avatarView.right + 10, (self.headerView.height - self.classNameLabel.height) / 2)];
    
    [self.redDot setHidden:![classInfo hasNew]];
    
    NSMutableArray* segments = [NSMutableArray array];
    [segments addObject:[GrowthSegmentItem itemWithTitle:@"未发送" hasNew:NO]];
    [segments addObject:[GrowthSegmentItem itemWithTitle:@"已发送" hasNew:NO]];
    [segments addObject:[GrowthSegmentItem itemWithTitle:@"已反馈" hasNew:YES]];
    [segments addObject:[GrowthSegmentItem itemWithTitle:@"未出勤" hasNew:NO]];
    [self.segmentCtrl setSegments:segments];
    [self.segmentCtrl setSelectedIndex:0];
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    GrowthClassInfo* classInfo = (GrowthClassInfo *)self.modelItem;
    return [classInfo.students count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GrowthRecordChildSelectItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GrowthRecordChildSelectItemCell" forIndexPath:indexPath];
    GrowthClassInfo* classInfo = (GrowthClassInfo *)self.modelItem;
    NSArray* students = classInfo.students;
    [cell setStudentInfo:students[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GrowthClassInfo* classInfo = (GrowthClassInfo *)self.modelItem;
    NSArray* students = classInfo.students;
    GrowthStudentInfo* studentInfo = students[indexPath.row];
    [studentInfo setSelected:!studentInfo.selected];
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kStudentSelectedStatusChangedNotification object:nil];
}

@end

@interface GrowthRecordChildSelectVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)UIView* bottomView;
@property (nonatomic, strong)UILabel* numLabel;
@end

@implementation GrowthRecordChildSelectVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectChange) name:kStudentSelectedStatusChangedNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"家园手册";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    [self.view addSubview:[self tableView]];
    [self.view addSubview:[self bottomView]];
    [self.tableView setFrame:CGRectMake(0, 0, self.view.width, self.bottomView.top)];
}

- (UITableView* )tableView{
    if(nil == _tableView){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _tableView;
}

- (UIView *)bottomView{
    if(nil == _bottomView){
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 40, self.view.width, 40)];
        [_bottomView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        
        UIButton* selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectButton setFrame:CGRectMake(0, 0, 60, _bottomView.height)];
        [selectButton setTitleColor:[UIColor colorWithHexString:@"cccccc"] forState:UIControlStateNormal];
        [selectButton setTitle:@"选择" forState:UIControlStateNormal];
        [selectButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [selectButton addTarget:self action:@selector(showSelectType) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:selectButton];
        
        self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(selectButton.right, 0, _bottomView.width - 10 - selectButton.right, _bottomView.height)];
        [self.numLabel setTextColor:[UIColor colorWithHexString:@"cccccc"]];
        [self.numLabel setFont:[UIFont systemFontOfSize:16]];
        [_bottomView addSubview:self.numLabel];
    }
    return _bottomView;
}

- (NSInteger)selectedNum{
    NSInteger count = 0;
    for (GrowthClassInfo* classInfo in self.classArray) {
        for (GrowthStudentInfo* studentInfo in classInfo.students) {
            if(studentInfo.selected){
                count++;
            }
        }
    }
    return count;
}

- (void)selectChange{
    [self.numLabel setText:[NSString stringWithFormat:@"已选择(%zd)", [self selectedNum]]];
}

- (void)showSelectType{
    LGAlertView* alertView = [[LGAlertView alloc] initWithTitle:nil message:nil style:LGAlertViewStyleActionSheet buttonTitles:@[@"未发孩子", @"全部孩子", @"取消选中"] cancelButtonTitle:nil destructiveButtonTitle:nil];
    [alertView setButtonsTitleColor:kCommonTeacherTintColor];
    [alertView setButtonsTitleColorHighlighted:kCommonTeacherTintColor];
    [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger row) {
        
    }];
    [alertView showAnimated:YES completionHandler:nil];
}

- (void)finish{
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.classArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* reuseID = @"GrowthRecordChildSelectCell";
    GrowthRecordChildSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell){
        cell = [[GrowthRecordChildSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    GrowthClassInfo* classInfo = self.classArray[indexPath.row];
    [cell setClassInfo:classInfo];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
