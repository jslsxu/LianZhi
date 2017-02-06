//
//  FilterView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "FilterView.h"

@interface ClassFilterView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)NSArray* filterList;
@property (nonatomic, copy)NSString* filterType;
@property (nonatomic, copy)void (^completion)(NSString* filterType);
@property (nonatomic, strong)UIButton* bgButton;
@property (nonatomic, strong)UIView* contentView;
@property (nonatomic, strong)UITableView* tableView;
@end

@implementation ClassFilterView

+ (NSString *)filterNameForType:(AttendanceClassFilterType)filterType{
    NSArray* filterNames = @[@"显示全部班级", @"显示未提交班级", @"显示已提交班级", @"显示无故缺勤的班级", @"显示迟到的班级"];
    return filterNames[filterType];
}

+ (void)showWithFilterList:(NSArray *)filterList filterType:(NSString* )filterType completion:(void (^)(NSString* filterType))completion{
    ClassFilterView* filterView = [[ClassFilterView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [filterView setFilterList:filterList];
    [filterView setFilterType:filterType];
    [filterView setCompletion:completion];
    [filterView show];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgButton setFrame:self.bounds];
        [self.bgButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        [self.bgButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.bgButton];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 270)];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self setupContentView:self.contentView];
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)setupContentView:(UIView *)viewParent{
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewParent.width, 45)];
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [titleLabel setText:@"显示班级"];
    [titleLabel setBackgroundColor:[UIColor colorWithHexString:@"eeeeee"]];
    [viewParent addSubview:titleLabel];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom, viewParent.width, viewParent.height - titleLabel.bottom) style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [viewParent addSubview:self.tableView];
}

- (void)show{
    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [self.bgButton setAlpha:0.f];
    [UIView animateWithDuration:0.3 animations:^{
        [self.bgButton setAlpha:1.f];
        [self.contentView setBottom:self.height];
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        [self.bgButton setAlpha:0.f];
        [self.contentView setTop:self.height];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.filterList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* reuseID = @"FilterCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.textLabel setTextColor:kCommonTeacherTintColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSString* filterName = self.filterList[indexPath.row];
    [cell.textLabel setText:filterName];
    if([self.filterType isEqualToString:filterName]){
        [cell.textLabel setTextColor:kCommonTeacherTintColor];
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_state_selected"]]];
    }
    else{
        [cell.textLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [cell setAccessoryView:nil];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView reloadData];
    NSString* filterName = self.filterList[indexPath.row];
    if(![filterName isEqualToString:self.filterType]){
        self.filterType = filterName;
        if(self.completion){
            self.completion(self.filterType);
        }
    }
    [self dismiss];
}
@end

@interface FilterView ()
@property (nonatomic, strong)UILabel* titleLabel;
@property (nonatomic, strong)UIImageView* arrow;
@end

@implementation FilterView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setHeight:45];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        UIView* topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kLineHeight)];
        [topLine setBackgroundColor:kSepLineColor];
        [self addSubview:topLine];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [self.titleLabel setTextColor:kCommonTeacherTintColor];
        [self addSubview:self.titleLabel];
        
        self.arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UpArrow"]];
        [self addSubview:self.arrow];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setFilterType:(NSString* )filterType{
    _filterType = [filterType copy];
    
    [self.titleLabel setWidth:0];
    [self.titleLabel setText:_filterType];
    [self.titleLabel sizeToFit];
    [self.titleLabel setOrigin:CGPointMake(10, (self.height - self.titleLabel.height) / 2)];
    
    [self.arrow setOrigin:CGPointMake(self.titleLabel.right + 5, (self.height - self.arrow.height) / 2)];
}

- (void)onTap{
    if(self.clickCallback){
        self.clickCallback();
    }
}

@end
