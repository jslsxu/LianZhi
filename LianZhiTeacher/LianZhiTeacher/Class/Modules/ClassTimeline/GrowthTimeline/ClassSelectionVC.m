//
//  ClassSelectionVC.m
#define kSectionHea
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/24.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ClassSelectionVC.h"
#import "ContactItemCell.h"

@implementation ClassSelectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _logoView = [[LogoView alloc] initWithFrame:CGRectMake(15, (self.height - 36) / 2, 36, 36)];
        [self addSubview:_logoView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_logoView.right + 15, 0, self.width - _logoView.right - 30, self.height)];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_nameLabel];
        
        _indicator = [[NumIndicator alloc] init];
        [_indicator setIndicator:nil];
        [self addSubview:_indicator];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - 0.5, self.width, 0.5)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
    }
    return self;
}

- (void)setClassInfo:(ClassInfo *)classInfo
{
    _classInfo = classInfo;
    [_logoView sd_setImageWithURL:[NSURL URLWithString:_classInfo.logo]];
    [_nameLabel setText:_classInfo.name];
    [_nameLabel sizeToFit];
    [_nameLabel setY:(self.height - _nameLabel.height) / 2];
}

- (void)setBadge:(NSString *)badge
{
    _badge = badge;
    if(!badge)
        [_indicator setHidden:YES];
    else
    {
        [_indicator setHidden:NO];
        [_indicator setIndicator:_badge];
        [_indicator setOrigin:CGPointMake(_nameLabel.right + 10, (self.height - _indicator.height) / 2)];
    }
}

@end

@interface ClassSelectionVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)NSArray *classArray;
@end

@implementation ClassSelectionVC
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStatusChanged) name:kStatusChangedNotification object:nil];
    }
    return self;
}

- (void)onStatusChanged
{
    if(self.classInfoDic && self.showNew)
    {
        NSMutableDictionary *classInfoDic = [NSMutableDictionary dictionary];
        //新动态
        NSArray *newCommentArray = [UserCenter sharedInstance].statusManager.classNewCommentArray;
        
        for (ClassInfo *classInfo in [UserCenter sharedInstance].curSchool.classes)
        {
            NSString *badge = nil;
            NSInteger commentNum = 0;
            for (TimelineCommentItem *commentItem in newCommentArray)
            {
                if([commentItem.classID isEqualToString:classInfo.classID] && commentItem.alertInfo.num > 0)
                    commentNum += commentItem.alertInfo.num;
            }
            
            if(commentNum > 0)
                badge = kStringFromValue(commentNum);
            else
            {
                //新日志
                NSArray *newFeedArray = [UserCenter sharedInstance].statusManager.feedClassesNew;
                NSInteger num = 0;
                for (ClassFeedNotice *noticeItem in newFeedArray)
                {
                    if([noticeItem.schoolID isEqualToString:[UserCenter sharedInstance].curSchool.schoolID] && [noticeItem.classID isEqualToString:classInfo.classID])
                    {
                        num += noticeItem.num;
                    }
                }
                if(num > 0)
                    badge = @"";
                else
                    badge = nil;
            }
            [classInfoDic setValue:badge forKey:classInfo.classID];
        }
        self.classInfoDic = classInfoDic;
        [_tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我所有的班";
    
    self.classArray = [UserCenter sharedInstance].curSchool.allClasses;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorColor:kSepLineColor];
    [self.view addSubview:_tableView];
    
}

#pragma mark - UITableviewdele

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.classArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"ClassSelectionCell";
    ClassSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[ClassSelectionCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]]];
    }
    
    ClassInfo *classInfo = self.classArray[indexPath.row];
    [cell setClassInfo:classInfo];
    [cell setBadge:self.classInfoDic[classInfo.classID]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClassInfo *classInfo = self.classArray[indexPath.row];
    self.originalClassID = classInfo.classID;
    [tableView reloadData];
    if(self.selection)
        self.selection(classInfo);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
