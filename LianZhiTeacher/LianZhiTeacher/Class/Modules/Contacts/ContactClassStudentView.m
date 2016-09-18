//
//  ContactClassParentView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/3.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ContactClassStudentView.h"
#import "ContactItemCell.h"
#import "ContactParentsView.h"
@implementation ContactClassHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self){
        [self setSize:CGSizeMake(kScreenWidth, 60)];
//        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        _logoView = [[LogoView alloc] initWithRadius:18];
        [self.contentView addSubview:_logoView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:_nameLabel];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_numLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_numLabel setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:_numLabel];
        
        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatButton setImage:[UIImage imageNamed:@"contact_class_chat"] forState:UIControlStateNormal];
        [_chatButton addTarget:self action:@selector(onChatClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_chatButton];
        
        UIView* sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [sepLine setBackgroundColor:[UIColor colorWithHexString:@"eaeaea"]];
        [self.contentView addSubview:sepLine];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
        [self.contentView addGestureRecognizer:tapGesture];
        
    }
    return self;
}

- (void)onTap{
    if(self.clickCallback){
        self.clickCallback();
    }
}

- (void)setClassInfo:(ClassInfo *)classInfo{
    _classInfo = classInfo;
    [_logoView setOrigin:CGPointMake(15, (self.height - _logoView.height) / 2)];
    [_chatButton setFrame:CGRectMake(self.width  - 50, 0, 50, self.height)];
    [_logoView sd_setImageWithURL:[NSURL URLWithString:_classInfo.logo]];
    [_nameLabel setText:_classInfo.name];
    [_nameLabel sizeToFit];
    [_nameLabel setOrigin:CGPointMake(_logoView.right + 15, (self.height - _nameLabel.height) / 2)];
    [_numLabel setText:[NSString stringWithFormat:@"%zd名学生",_classInfo.students.count]];
    [_numLabel sizeToFit];
    [_numLabel setOrigin:CGPointMake(_nameLabel.right + 10, (self.height - _numLabel.height) / 2)];
}

- (void)onChatClicked{
    if(self.chatCallback){
        self.chatCallback();
    }
}

@end

@interface ContactClassStudentView ()<UITableViewDelegate, UITableViewDataSource>{
    UITableView*    _tableView;
}
@property (nonatomic, strong)UITableView*   tableView;
@property (nonatomic, strong)ContactParentsView*    parentsView;
@property (nonatomic, strong)NSMutableDictionary*   expandDictionary;
@end

@implementation ContactClassStudentView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setShowsVerticalScrollIndicator:NO];
        [self addSubview:_tableView];
        
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissParentsView)];
        [swipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
        [self addGestureRecognizer:swipeGesture];
    }
    return self;
}

- (void)setClassArray:(NSArray *)classArray{
    _classArray = classArray;
    if(self.expandDictionary == nil){
        self.expandDictionary = [NSMutableDictionary dictionary];
    }
    BOOL expand = (_classArray.count == 1);
    NSArray *allKeys = self.expandDictionary.allKeys;
    for (ClassInfo *classInfo in _classArray) {
        BOOL inDic = NO;
        for (NSString *key in allKeys) {
            if([classInfo.classID isEqualToString:key]){
                inDic = YES;
            }
        }
        if(!inDic){
            [self.expandDictionary setValue:@(expand) forKey:classInfo.classID];
        }
    }
    [_tableView reloadData];
}

- (void)showInfoWithStudentInfo:(StudentInfo *)studentInfo{
    if(self.parentsView == nil){
        self.parentsView = [[ContactParentsView alloc] initWithFrame:CGRectMake(self.width, 0, self.width - 60, self.height)];
        [self addSubview:self.parentsView];
    }
    [self.parentsView setStudentInfo:studentInfo];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.3 animations:^{
        self.parentsView.x = 60;
    }completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

- (void)dismissParentsView{
    if(self.parentsView.x < self.width){
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:0.3 animations:^{
            self.parentsView.x = self.width;
        }completion:^(BOOL finished) {
            
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.classArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ClassInfo* classInfo = self.classArray[section];
    BOOL expand = [self.expandDictionary[classInfo.classID] boolValue];
    if(expand){
        return classInfo.students.count;
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"ContactItemCell";
    ContactItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(cell == nil){
        cell = [[ContactItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ContactClassHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ContactClassHeaderView"];
    if(headerView == nil){
        headerView = [[ContactClassHeaderView alloc] initWithReuseIdentifier:@"ContactClassHeaderView"];
    }
    ClassInfo* classInfo = self.classArray[section];
    [headerView setClassInfo:classInfo];
    __weak typeof(self) wself = self;
    [headerView setClickCallback:^{
        BOOL expand = [self.expandDictionary[classInfo.classID] boolValue];
        [wself.expandDictionary setValue:@(!expand) forKey:classInfo.classID];
        [wself.tableView reloadData];
    }];
    [headerView setChatCallback:^{
        JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
        [chatVC setTo_objid:[UserCenter sharedInstance].curSchool.schoolID];
        [chatVC setTargetID:classInfo.classID];
        [chatVC setChatType:ChatTypeClass];
        [chatVC setName:classInfo.name];
//        [CurrentROOTNavigationVC pushViewController:chatVC animated:YES];
        [ApplicationDelegate popAndPush:chatVC];
    }];
    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactItemCell *itemCell = (ContactItemCell *)cell;
    ClassInfo* classInfo = self.classArray[indexPath.section];
    StudentInfo* studentInfo = classInfo.students[indexPath.row];
    [itemCell setUserInfo:studentInfo];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClassInfo* classInfo = self.classArray[indexPath.section];
    StudentInfo* studentInfo = classInfo.students[indexPath.row];
    [self showInfoWithStudentInfo:studentInfo];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self dismissParentsView];
}
@end
