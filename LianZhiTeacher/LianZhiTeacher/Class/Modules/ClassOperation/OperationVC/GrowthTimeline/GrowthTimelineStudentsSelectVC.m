//
//  GrowthTimelineStudentsSelectVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/9.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "GrowthTimelineStudentsSelectVC.h"
#import "GrowthTimelineClassChangeVC.h"

@implementation GrowthStudentItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _avatarView = [[AvatarView alloc] initWithFrame:CGRectMake((self.width - 40) / 2, (self.height - 60) / 2, 40, 40)];
        [self addSubview:_avatarView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _avatarView.bottom, self.width, 20)];
        [_nameLabel setFont:[UIFont systemFontOfSize:12]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_nameLabel];
        
        _checkedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 12 - 10, 10, 12, 12)];
        [self addSubview:_checkedImageView];
        
        UIView *hLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [hLine setBackgroundColor:[UIColor colorWithHexString:@"D8D8D8"]];
        [self addSubview:hLine];
        
        UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(self.width - kLineHeight, 0, kLineHeight, self.height)];
        [vLine setBackgroundColor:[UIColor colorWithHexString:@"D8D8D8"]];
        [self addSubview:vLine];
    }
    return self;
}

- (void)setStudentInfo:(StudentInfo *)studentInfo
{
    _studentInfo = studentInfo;
    [_avatarView setImageWithUrl:[NSURL URLWithString:_studentInfo.avatar]];
    [_nameLabel setText:_studentInfo.name];
}

- (void)setHasBeenSelected:(BOOL)hasBeenSelected
{
    _hasBeenSelected = hasBeenSelected;
    [_checkedImageView setImage:[UIImage imageNamed:_hasBeenSelected ? @"StudentSelected" : @"StudentUnselected"]];
}

@end

@interface GrowthTimelineStudentsSelectVC ()

@end

@implementation GrowthTimelineStudentsSelectVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        _selectedArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"切换" style:UIBarButtonItemStylePlain target:self action:@selector(onClassChanged)];
    NSInteger itemWith = (self.view.width + 3) / 4;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(itemWith, itemWith)];
    [layout setMinimumInteritemSpacing:0];
    [layout setMinimumLineSpacing:0];
    [layout setSectionInset:UIEdgeInsetsMake(0, 0, 40, 0)];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake((self.view.width - itemWith * 4) / 2, 0, itemWith * 4, self.view.height - 64) collectionViewLayout:layout];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [_collectionView registerClass:[GrowthStudentItemCell class] forCellWithReuseIdentifier:@"GrowthStudentItemCell"];
    [self.view addSubview:_collectionView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 64 - 40, self.view.width, 35)];
    [bottomView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
    [self setupBottomView:bottomView];
    [self.view addSubview:bottomView];
}

- (void)setupBottomView:(UIView *)viewParent
{
    _selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_selectAllButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_selectAllButton addTarget:self action:@selector(onSelectAllClicked) forControlEvents:UIControlEventTouchUpInside];
    [_selectAllButton setTitle:@"全选" forState:UIControlStateNormal];
    [_selectAllButton setTitle:@"反选" forState:UIControlStateSelected];
    [_selectAllButton setFrame:CGRectMake(0, 0, 50, viewParent.height)];
    [viewParent addSubview:_selectAllButton];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(onSendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_sendButton setFrame:CGRectMake(viewParent.width - 50, 0, 50, viewParent.height)];
    [viewParent addSubview:_sendButton];
    
}

- (void)onSelectAllClicked
{
    _selectAllButton.selected = !_selectAllButton.selected;
    [_selectedArray removeAllObjects];
    if(_selectAllButton.selected)
        [_selectedArray addObjectsFromArray:self.classInfo.students];
    [_collectionView reloadData];
}

- (void)onSendButtonClicked
{
    
}

- (void)onClassChanged
{
    GrowthTimelineClassChangeVC *classChangeVC = [[GrowthTimelineClassChangeVC alloc] init];
    [classChangeVC setCompletion:^(ClassInfo *classInfo) {
        self.classInfo = classInfo;
    }];
    [CurrentROOTNavigationVC pushViewController:classChangeVC animated:YES];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.classInfo.students.count ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GrowthStudentItemCell *studentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GrowthStudentItemCell" forIndexPath:indexPath];
    StudentInfo *studentInfo = self.classInfo.students[indexPath.row];
    [studentCell setStudentInfo:studentInfo];
    [studentCell setHasBeenSelected:[_selectedArray containsObject:studentInfo]];
    return studentCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GrowthStudentItemCell *studentCell = (GrowthStudentItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [studentCell setHasBeenSelected:!studentCell.hasBeenSelected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
