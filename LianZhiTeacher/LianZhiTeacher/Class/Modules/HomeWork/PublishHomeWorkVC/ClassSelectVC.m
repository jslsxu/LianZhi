//
//  ClassSelectVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/2.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ClassSelectVC.h"

@implementation ClassSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setHeight:56];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _logoView = [[LogoView alloc] initWithRadius:18];
        [_logoView setOrigin:CGPointMake(10, (self.height - _logoView.height) / 2)];
        [self addSubview:_logoView];
        
        _classNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_classNameLabel setFont:[UIFont systemFontOfSize:16]];
        [_classNameLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self addSubview:_classNameLabel];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_numLabel setFont:[UIFont systemFontOfSize:13]];
        [_numLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [self addSubview:_numLabel];
        
        _selectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"send_sms_off"]];
        [_selectImageView setOrigin:CGPointMake(self.width - 10 - _selectImageView.width, (self.height - _selectImageView.height) / 2 )];
        [self addSubview:_selectImageView];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:sepLine];
    }
    return self;
}

- (void)setClassInfo:(ClassInfo *)classInfo{
    _classInfo = classInfo;
    [_logoView sd_setImageWithURL:[NSURL URLWithString:_classInfo.logo]];
    [_classNameLabel setText:_classInfo.name];
    [_classNameLabel sizeToFit];
    [_classNameLabel setOrigin:CGPointMake(_logoView.right + 10, (self.height - _classNameLabel.height) / 2)];
    [_numLabel setText:[NSString stringWithFormat:@"%zd名学生", [_classInfo.students count]]];
    [_numLabel sizeToFit];
    [_numLabel setOrigin:CGPointMake(_classNameLabel.right + 5, (self.height - _numLabel.height) / 2)];
}

- (void)setClassSelected:(BOOL)classSelected{
    _classSelected = classSelected;
    [_selectImageView setImage:[UIImage imageNamed:_classSelected ? @"send_sms_on" : @"send_sms_off"]];
}

@end

@interface ClassSelectVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView*   tableView;
@property (nonatomic, strong)UIButton*      selectButton;
@property (nonatomic, strong)UILabel*       stateLabel;
@property (nonatomic, strong)NSMutableArray*    selectedClassArray;
@property (nonatomic, strong)NSArray*       classArray;
@end

@implementation ClassSelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.classArray = [[UserCenter sharedInstance].curSchool allClasses];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirm)];
    self.selectedClassArray = [NSMutableArray arrayWithArray:self.originalClassArray];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 44, 0)];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    
    UIView *actionView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 44, self.view.width, 44)];
    [actionView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [actionView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectButton setTitle:@"全选" forState:UIControlStateNormal];
    [self.selectButton setFrame:CGRectMake(0, 0, 60, actionView.height)];
    [self.selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.selectButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.selectButton addTarget:self action:@selector(onSelectButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [actionView addSubview:self.selectButton];
    
    _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(actionView.width / 2, 0, actionView.width / 2 - 10, actionView.height)];
    [_stateLabel setFont:[UIFont systemFontOfSize:16]];
    [_stateLabel setTextColor:[UIColor whiteColor]];
    [_stateLabel setTextAlignment:NSTextAlignmentRight];
    [_stateLabel setText:@"已选择0人"];
    [actionView addSubview:_stateLabel];
    
    [self.view addSubview:actionView];
    
    [self updateBottomBar];
}

- (void)onSelectButtonClicked{
    BOOL selectAll = YES;
    for (ClassInfo *classInfo in self.classArray) {
        if(![self containsClass:classInfo]){
            selectAll = NO;
        }
    }
    if(!selectAll){
        for (ClassInfo *classInfo in self.classArray) {
            if(![self containsClass:classInfo]){
                [self.selectedClassArray addObject:classInfo];
            }
        }
    }
    else{
        [self.selectedClassArray removeAllObjects];
    }
    [self.tableView reloadData];
    [self updateBottomBar];
}

- (void)confirm{
    if(self.classSelectCallBack){
        self.classSelectCallBack(self.selectedClassArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateBottomBar{
    
    NSInteger selectNum = 0;
    for (ClassInfo *classInfo in self.classArray) {
        if([self containsClass:classInfo]){
            selectNum ++;
        }
    }
    BOOL selectAll = selectNum == [self.classArray count];
    [self.selectButton setTitle:selectAll ? @"反选" : @"全选" forState:UIControlStateNormal];
    [self.stateLabel setText:[NSString stringWithFormat:@"已选择(%zd)",selectNum]];
}

- (BOOL)containsClass:(ClassInfo *)classInfo{
    for (ClassInfo *classItem in self.selectedClassArray) {
        if([classItem.classID isEqualToString:classInfo.classID]){
            return YES;
        }
    }
    return NO;
}

- (void)addClassInfo:(ClassInfo *)classInfo{
    if(classInfo){
        [self.selectedClassArray addObject:classInfo];
    }
}

- (void)removeClassInfo:(ClassInfo *)classInfo{
    if(classInfo){
        for (ClassInfo *classItem in self.selectedClassArray) {
            if([classInfo.classID isEqualToString:classItem.classID]){
                [self.selectedClassArray removeObject:classItem];
                return;
            }
        }
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.classArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseID = @"ClassInfoCell";
    ClassSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(cell == nil){
        cell = [[ClassSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    ClassInfo *classInfo = [self.classArray objectAtIndex:indexPath.row];
    [cell setClassInfo:classInfo];
    [cell setClassSelected:[self containsClass:classInfo]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ClassInfo *classInfo = [self.classArray objectAtIndex:indexPath.row];
    if([self containsClass:classInfo]){
        [self removeClassInfo:classInfo];
    }
    else{
        [self addClassInfo:classInfo];
    }
    [tableView reloadData];
    [self updateBottomBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
