//
//  GrowthTimelineClassChangeVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/9.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "GrowthTimelineClassChangeVC.h"
#import "GrowthTimelineStudentsSelectVC.h"
@implementation GrowthClassCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.width = kScreenWidth;
        _logoView = [[LogoView alloc] initWithFrame:CGRectMake(12, (self.height - 36) / 2, 36, 36)];
        [self addSubview:_logoView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_logoView.right + 10, 0, self.width - 50 - (_logoView.right + 10), self.height)];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [self addSubview:_nameLabel];
        
        [self setSelectType:SelectTypeNone];
    }
    return self;
}

- (void)setClassInfo:(ClassInfo *)classInfo
{
    _classInfo = classInfo;
    [_logoView setImageWithUrl:[NSURL URLWithString:_classInfo.logoUrl]];
    [_nameLabel setText:_classInfo.className];
}

- (void)setSelectType:(SelectType)selectType
{
    _selectType = selectType;
    UIImage *image = nil;
    if(_selectType == SelectTypeAll)
        image = [UIImage imageNamed:@"ControlSelectAll"];
    else if(_selectType == SelectTypePart)
        image = [UIImage imageNamed:@"ControlSelectPart"];
    else
        image = [UIImage imageNamed:@"ControlDefault"];
    [self setAccessoryView:[[UIImageView alloc] initWithImage:image]];
}

@end

@interface GrowthTimelineClassChangeVC ()

@end

@implementation GrowthTimelineClassChangeVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        _paramsDic = [NSMutableDictionary dictionary];
        for (ClassInfo *classInfo in [UserCenter sharedInstance].curSchool.classes)
        {
            NSMutableArray *selectedArray = [NSMutableArray array];
            [_paramsDic setValue:selectedArray forKey:classInfo.classID];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所有的班";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onConfirm)];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorColor:kSepLineColor];
    [self.view addSubview:_tableView];
}

- (void)onConfirm
{
    if(self.completion)
        self.completion(_paramsDic);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [UserCenter sharedInstance].curSchool.classes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"GrowthClassCell";
    GrowthClassCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[GrowthClassCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    ClassInfo *classInfo = [UserCenter sharedInstance].curSchool.classes[indexPath.row];
    [cell setClassInfo:classInfo];
    SelectType selectType = SelectTypeNone;
    NSArray *studentArray = [_paramsDic valueForKey:classInfo.classID];
    if(studentArray.count == 0)
        selectType = SelectTypeNone;
    else if(studentArray.count == classInfo.students.count)
        selectType = SelectTypeAll;
    else
        selectType = SelectTypePart;
    [cell setSelectType:selectType];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClassInfo *classInfo = [UserCenter sharedInstance].curSchool.classes[indexPath.row];
    GrowthTimelineStudentsSelectVC *studentVC = [[GrowthTimelineStudentsSelectVC alloc] init];
    [studentVC setClassInfo:classInfo];
    [studentVC setOriginalStudentArray:_paramsDic[classInfo.classID]];
    [studentVC setTitle:classInfo.className];
    [studentVC setCompletion:^(NSArray *studentArray) {
        [_paramsDic setValue:studentArray forKey:classInfo.classID];
        [_tableView reloadData];
    }];
    [self.navigationController pushViewController:studentVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
