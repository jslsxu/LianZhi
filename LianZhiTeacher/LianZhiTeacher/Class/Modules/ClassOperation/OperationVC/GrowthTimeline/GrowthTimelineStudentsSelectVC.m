//
//  GrowthTimelineStudentsSelectVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/9.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "GrowthTimelineStudentsSelectVC.h"
#import "GrowthTimelineClassChangeVC.h"
#import "GrowthTimelineModel.h"
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

- (void)setHasSend:(BOOL)hasSend
{
    _hasSend = hasSend;
    [_avatarView setStatus:_hasSend ? @"已发" : nil];
}

- (void)setHasBeenSelected:(BOOL)hasBeenSelected
{
    _hasBeenSelected = hasBeenSelected;
    [_checkedImageView setImage:[UIImage imageNamed:_hasBeenSelected ? @"StudentSelected" : @"StudentUnselected"]];
}

@end

@interface GrowthTimelineStudentsSelectVC ()
@property (nonatomic, strong)NSMutableArray *recordList;
@end

@implementation GrowthTimelineStudentsSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _selectedArray = [NSMutableArray arrayWithArray:self.originalStudentArray];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onConfirm)];
    NSInteger itemWith = (self.view.width + 3) / 4;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(itemWith, itemWith)];
    [layout setMinimumInteritemSpacing:0];
    [layout setMinimumLineSpacing:0];
    [layout setSectionInset:UIEdgeInsetsMake(0, 0, 40, 0)];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake((self.view.width - itemWith * 4) / 2, 0, itemWith * 4, self.view.height - 64) collectionViewLayout:layout];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView setBounces:NO];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [_collectionView registerClass:[GrowthStudentItemCell class] forCellWithReuseIdentifier:@"GrowthStudentItemCell"];
    [self.view addSubview:_collectionView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 64 - 40, self.view.width, 40)];
    [bottomView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
    [self setupBottomView:bottomView];
    [self.view addSubview:bottomView];
    
    [self requestData];
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

    
}

- (BOOL)isHasSend:(NSString *)userId
{
    for (GrowthTimelineItem *timelineItem in self.recordList)
    {
        StudentInfo *studentInfo = timelineItem.student;
        if([userId isEqualToString:studentInfo.uid])
            return YES;
    }
    return NO;
}

//获取发送记录
- (void)requestData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.classInfo.classID forKey:@"class_id"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"class/record_list" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        TNDataWrapper *listWrapper = [responseObject getDataWrapperForKey:@"list"];
        if(listWrapper.count > 0)
        {
            NSMutableArray *recordList = [NSMutableArray array];
            for (NSInteger i = 0; i < listWrapper.count; i++)
            {
                TNDataWrapper *recordItemWrapper = [listWrapper getDataWrapperForIndex:i];
                GrowthTimelineItem *timelineItem = [[GrowthTimelineItem alloc] init];
                [timelineItem parseData:recordItemWrapper];
                [recordList addObject:timelineItem];
            }
            self.recordList = recordList;
            [_collectionView reloadData];
        }
    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)onConfirm
{
    if(self.completion)
        self.completion(_selectedArray);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onSelectAllClicked
{
    _selectAllButton.selected = !_selectAllButton.selected;
    [_selectedArray removeAllObjects];
    if(!_selectAllButton.selected)
    {
        [_collectionView reloadData];
    }
    else
    {
        if(self.recordList.count == 0)
        {
            [_selectedArray addObjectsFromArray:self.classInfo.students];
            [_collectionView reloadData];
        }
        else
        {
            TNButtonItem *allItem = [TNButtonItem itemWithTitle:@"全班学生" action:^{
                [_selectedArray addObjectsFromArray:self.classInfo.students];
                [_collectionView reloadData];
            }];
            TNButtonItem *notSentItem = [TNButtonItem itemWithTitle:@"今日未发" action:^{
                for (StudentInfo *student in self.classInfo.students)
                {
                    if(![self isHasSend:student.uid])
                        [_selectedArray addObject:student];
                }
                [_collectionView reloadData];
            }];
            
            TNActionSheet *actionSheet = [[TNActionSheet alloc] initWithTitle:nil descriptionView:nil destructiveButton:nil cancelItem:nil otherItems:@[allItem, notSentItem]];
            [actionSheet show];
        }
    }

}

- (void)onSendButtonClicked
{
    
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = self.classInfo.students.count;
    _selectAllButton.selected = (_selectedArray.count == count);
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GrowthStudentItemCell *studentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GrowthStudentItemCell" forIndexPath:indexPath];
    StudentInfo *studentInfo = self.classInfo.students[indexPath.row];
    [studentCell setStudentInfo:studentInfo];
    [studentCell setHasBeenSelected:[_selectedArray containsObject:studentInfo]];
    [studentCell setHasSend:[self isHasSend:studentInfo.uid]];
    return studentCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GrowthStudentItemCell *studentCell = (GrowthStudentItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    StudentInfo *studentInfo = studentCell.studentInfo;
    [studentCell setHasBeenSelected:!studentCell.hasBeenSelected];
    if(studentCell.hasBeenSelected)
        [_selectedArray addObject:studentInfo];
    else
        [_selectedArray removeObject:studentInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
