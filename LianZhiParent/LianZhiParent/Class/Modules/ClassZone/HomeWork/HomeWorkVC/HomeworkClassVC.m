//
//  HomeworkClassVC.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkClassVC.h"
#import "HomeWorkVC.h"
@implementation HomeworkClassItem

@end

@implementation HomeworkClassModel

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type{
    if(type == REQUEST_REFRESH){
        [self.modelItemArray removeAllObjects];
    }
    TNDataWrapper *dataWrapper = [data getDataWrapperForKey:@"classes"];
    [self.modelItemArray addObjectsFromArray:[HomeworkClassItem nh_modelArrayWithJson:dataWrapper.data]];
    return YES;
}
@end

@implementation HomeworkClassCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _logoView = [[LogoView alloc] initWithRadius:18];
        [_logoView setOrigin:CGPointMake(10, (60 - _logoView.height) / 2)];
        [self addSubview:_logoView];
        
        _classNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_classNameLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_classNameLabel setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:_classNameLabel];
        
        _schoolNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_schoolNameLabel setTextColor:[UIColor colorWithHexString:@"02c994"]];
        [_schoolNameLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:_schoolNameLabel];
        
        _rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]];
        [_rightArrow setOrigin:CGPointMake(self.width - 10 - _rightArrow.width, (60 - _rightArrow.height) / 2)];
        [self addSubview:_rightArrow];
        
        _redDot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        [_redDot.layer setCornerRadius:4];
        [_redDot.layer setMasksToBounds:YES];
        [_redDot setBackgroundColor:[UIColor colorWithHexString:@"F0003A"]];
        [_redDot setOrigin:CGPointMake(_rightArrow.left - 9 - _redDot.width, (60 - _redDot.height) / 2)];
        [self addSubview:_redDot];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(56, self.height - kLineHeight, self.width - 56, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [_sepLine setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [self addSubview:_sepLine];
        
        
    }
    return self;
}

- (void)setData:(TNModelItem *)modelItem{
    HomeworkClassItem *classItem = (HomeworkClassItem *)modelItem;
    [_logoView sd_setImageWithURL:[NSURL URLWithString:classItem.class_logo] placeholderImage:nil];
    [_classNameLabel setText:classItem.class_name];
    [_classNameLabel sizeToFit];
    [_classNameLabel setOrigin:CGPointMake(_logoView.right + 10, (60 - _classNameLabel.height) / 2)];
    
    [_schoolNameLabel setText:classItem.school_name];
    [_schoolNameLabel sizeToFit];
    [_schoolNameLabel setOrigin:CGPointMake(_classNameLabel.right + 10, (60 - _schoolNameLabel.height) / 2)];
    
    [_redDot setHidden:!classItem.has_new];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width{
    return @(60);
}

@end

@interface HomeworkClassVC ()

@end

@implementation HomeworkClassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我所有的班";
    [self bindTableCell:@"HomeworkClassCell" tableModel:@"HomeworkClassModel"];
    [self requestData:REQUEST_REFRESH];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    task.requestUrl = @"exercises/classes";
    return task;
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath{
    HomeworkClassItem *classItem = (HomeworkClassItem *)modelItem;
    HomeWorkVC *homeworkVC = [[HomeWorkVC alloc] init];
    [homeworkVC setClassID:classItem.class_id];
    [self.navigationController pushViewController:homeworkVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
