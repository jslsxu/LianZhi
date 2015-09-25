//
//  NotificationClassStudentsVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/11.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "NotificationClassStudentsVC.h"

#define kCellHeight                 50

@implementation NotificationStudentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(10, (kCellHeight - 32) / 2, 32, 32)];
        [self addSubview:_avatarView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarView.right + 10, 0, 0, 0)];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_nameLabel];
        
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatarView.right + 10, 0, 0, 0)];
        [_infoLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [_infoLabel setFont:[UIFont systemFontOfSize:10]];
        [self addSubview:_infoLabel];
        
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkButton setFrame:CGRectMake(self.width - 20 - 20, (kCellHeight - 20) / 2, 20, 20)];
        [_checkButton setImage:[UIImage imageNamed:@"ControlDefault"] forState:UIControlStateNormal];
        [_checkButton setImage:[UIImage imageNamed:@"ControlSelectAll"] forState:UIControlStateSelected];
        [self addSubview:_checkButton];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, kCellHeight - kLineHeight, self.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
        
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    StudentInfo *studentInfo = (StudentInfo *)modelItem;
    [_avatarView setImageWithUrl:[NSURL URLWithString:studentInfo.avatar]];
    [_nameLabel setText:studentInfo.name];
    [_nameLabel sizeToFit];
    [_nameLabel setOrigin:CGPointMake(_avatarView.right + 10, (kCellHeight - _nameLabel.height) / 2)];
    [_infoLabel setText:[NSString stringWithFormat:@"(%ld位家长)",(long)studentInfo.family.count]];
    [_infoLabel sizeToFit];
    [_infoLabel setOrigin:CGPointMake(_nameLabel.right + 10, (kCellHeight - _infoLabel.height) / 2)];
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    [_checkButton setSelected:_checked];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    return @(kCellHeight);
}

@end

@implementation StudentsModel
- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    if(type == REQUEST_REFRESH)
        [self.modelItemArray removeAllObjects];
    TNDataWrapper *studentsWrapper = [data getDataWrapperForKey:@"students"];
    if(studentsWrapper.count > 0)
    {
        for (NSInteger i = 0; i < studentsWrapper.count; i++)
        {
            TNDataWrapper *studentItemWrapper = [studentsWrapper getDataWrapperForIndex:i];
            StudentInfo *studentInfo = [[StudentInfo alloc] init];
            [studentInfo parseData:studentItemWrapper];
            [self.modelItemArray addObject:studentInfo];
        }
    }
    return YES;
}

@end

@interface NotificationClassStudentsVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)NSMutableArray *seletedArray;
@end

@implementation NotificationClassStudentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.seletedArray = [NSMutableArray array];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onConfirm)];
    [self bindTableCell:@"NotificationStudentCell" tableModel:@"StudentsModel"];
    [self requestData:REQUEST_REFRESH];
    
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"class/info"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.classID forKey:@"class_id"];
    [task setParams:params];
    [task setObserver:self];
    return task;

}

- (BOOL)selectedForStudent:(StudentInfo *)studentInfo
{
    BOOL selected = NO;
    for (NSString *studentId in self.seletedArray)
    {
        if([studentId isEqualToString:studentInfo.uid])
            selected = YES;
    }
    return selected;
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath
{
    StudentInfo *studentInfo = (StudentInfo *)modelItem;
    if([self selectedForStudent:studentInfo])
        [self.seletedArray removeObject:studentInfo.uid];
    else
    {
        [self.seletedArray addObject:studentInfo.uid];
    }
    [_tableView reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationStudentCell *studentCell = (NotificationStudentCell *)cell;
    [studentCell setChecked:[self selectedForStudent:self.tableViewModel.modelItemArray[indexPath.row]]];
}

- (void)onConfirm
{
    if(self.selectedCompletion)
        self.selectedCompletion(self.seletedArray);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
