//
//  NotificationTargetSelectVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationMemberSelectVC.h"

@implementation NotificationMemberHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self){
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        _stateImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_stateImageView];
        
        _logoView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_logoView.layer setCornerRadius:18];
        [_logoView.layer setMasksToBounds:YES];
        [self addSubview:_logoView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setText:@"二班"];
        [self addSubview:_nameLabel];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_numLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_numLabel setFont:[UIFont systemFontOfSize:14]];
        [_numLabel setText:@"2/30"];
        [_numLabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_numLabel];
        
        _allSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_allSelectButton setImage:[UIImage imageNamed:@"ic_xuan_selected"] forState:UIControlStateSelected];
        [_allSelectButton setImage:[UIImage imageNamed:@"send_sms_off"] forState:UIControlStateNormal];
        [_allSelectButton addTarget:self action:@selector(onAllSelectClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_allSelectButton];
        
        _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        [_bottomLine setBackgroundColor:kSepLineColor];
        [self addSubview:_bottomLine];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHeaderClick)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setExpand:(BOOL)expand{
    _expand = expand;
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [_logoView setFrame:CGRectMake(40, (self.height - 36) / 2, 36, 36)];
    [_allSelectButton setFrame:CGRectMake(self.width - 40, 0, 40, self.height)];
    [_numLabel setFrame:CGRectMake(_allSelectButton.left - 50, 0, 50, self.height)];
    [_nameLabel setFrame:CGRectMake(_logoView.right + 10, 0, _numLabel.left - 10 - (_logoView.right + 10), self.height)];
    [_bottomLine setFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
}

- (void)onHeaderClick{
    if(self.headerExpandClick){
        self.headerExpandClick();
    }
}

- (void)onAllSelectClicked{
    if(self.allSelectClick){
        self.allSelectClick();
    }
}

@end

@implementation NotificationMemberItemCell
+ (CGFloat)cellHeight{
    return 60;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _stateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 60)];
        [_stateImageView setContentMode:UIViewContentModeCenter];
        [_stateImageView setImage:[UIImage imageNamed:@"send_sms_on"]];
        [self addSubview:_stateImageView];
        
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_avatarView.layer setCornerRadius:18];
        [_avatarView.layer setMasksToBounds:YES];
        [self addSubview:_avatarView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self addSubview:_nameLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
    }
    return self;
}

- (void)setUserInfo:(UserInfo *)userInfo{
    _userInfo = userInfo;
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:_userInfo.avatar] placeholderImage:nil];
    [_avatarView setFrame:CGRectMake(40, (60 - 36) / 2, 36, 36)];
    [_nameLabel setText:_userInfo.name];
    [_nameLabel setFrame:CGRectMake(_avatarView.right + 10, 0, self.width - 10 - (_avatarView.right + 10), self.height)];
    [_sepLine setFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
}

@end

@interface NotificationMemberView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *selectedArray;
@end

@implementation NotificationMemberView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSectionHeaderHeight:56];
        [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 44, 0)];
        [self addSubview:_tableView];
        
        _actionView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 44, self.width, 44)];
        [_actionView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        
        _selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectAllButton setTitle:@"全选" forState:UIControlStateNormal];
        [_selectAllButton setFrame:CGRectMake(0, 0, 60, _actionView.height)];
        [_selectAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_selectAllButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_selectAllButton addTarget:self action:@selector(onSelectButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_actionView addSubview:_selectAllButton];
        
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_actionView.width / 2, 0, _actionView.width / 2 - 10, _actionView.height)];
        [_stateLabel setFont:[UIFont systemFontOfSize:16]];
        [_stateLabel setTextColor:[UIColor whiteColor]];
        [_stateLabel setTextAlignment:NSTextAlignmentRight];
        [_stateLabel setText:[NSString stringWithFormat:@"已选择(%zd)",self.selectedArray.count]];
        [_actionView addSubview:_stateLabel];
        
        [self addSubview:_actionView];
    }
    return self;
}

- (NSMutableArray *)selectedArray{
    if(!_selectedArray){
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

- (void)onSelectButtonClicked{
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.userType == UserTypeStudent){
        ClassInfo *classInfo = [self.dataSource objectAtIndex:section];
        return classInfo.students.count;
    }
    else{
        TeacherGroup *group = [self.dataSource objectAtIndex:section];
        return group.teachers.count;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [NotificationMemberItemCell cellHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *reuseID = @"NotificationMemberHeaderView";
    NotificationMemberHeaderView *headerView  = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseID];
    if(!headerView){
        headerView = [[NotificationMemberHeaderView alloc] initWithReuseIdentifier:reuseID];
    }
    [headerView setHeaderExpandClick:^{
        
    }];
    [headerView setAllSelectClick:^{
        
    }];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"NotificationMemberItemCell";
    NotificationMemberItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(!cell){
        cell = [[NotificationMemberItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationMemberItemCell *itemCell = (NotificationMemberItemCell *)cell;
    UserInfo *userInfo;
    if(self.userType == UserTypeStudent){
        ClassInfo *classInfo = [self.dataSource objectAtIndex:indexPath.section];
        userInfo = classInfo.students[indexPath.row];
    }
    else{
        TeacherGroup *group = [self.dataSource objectAtIndex:indexPath.section];
        userInfo = group.teachers[indexPath.row];
    }
    [itemCell setUserInfo:userInfo];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    NotificationMemberHeaderView *headerView = (NotificationMemberHeaderView *)view;
    [headerView setExpand:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

@interface NotificationMemberSelectVC ()
@property (nonatomic, strong)NSMutableArray *selectArray;
@end

@implementation NotificationMemberSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _segmentCtrl = [[UISegmentedControl alloc] initWithItems:@[@"家长",@"同事"]];
    [_segmentCtrl setSelectedSegmentIndex:0];
    [_segmentCtrl setWidth:120];
    [_segmentCtrl addTarget:self action:@selector(onValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:_segmentCtrl];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onConfirm)];
    
    _studentView = [[NotificationMemberView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    [_studentView setDataSource:[UserCenter sharedInstance].curSchool.classes];
    [_studentView setUserType:UserTypeStudent];
    [self.view addSubview:_studentView];
    
    _teacherView = [[NotificationMemberView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    [_teacherView setDataSource:[UserCenter sharedInstance].curSchool.groups];
    [_teacherView setUserType:UserTypeTeacher];
    [_teacherView setHidden:YES];
    [self.view addSubview:_teacherView];
    
}

- (NSMutableArray *)selectArray{
    if(!_selectArray){
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (void)onValueChanged{
    NSInteger index = _segmentCtrl.selectedSegmentIndex;
    [_studentView setHidden:index != 0];
    [_teacherView setHidden:index != 1];
}

#pragma mark - Actions
- (void)onConfirm{
    if(self.selectCompletion){
        self.selectCompletion(self.selectArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
