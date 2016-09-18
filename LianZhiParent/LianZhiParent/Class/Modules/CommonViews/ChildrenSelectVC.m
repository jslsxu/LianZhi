//
//  ChildrenSelectVC.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/8/20.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ChildrenSelectVC.h"

#define kChildCellHeight                70

@implementation ChildrenCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _avatar = [[AvatarView alloc] initWithFrame:CGRectMake(12, (kChildCellHeight - 50) / 2, 50, 50)];
        [self addSubview:_avatar];
        
        _redDot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        [_redDot setBackgroundColor:[UIColor colorWithHexString:@"F0003A"]];
        [_redDot.layer setCornerRadius:3];
        [_redDot.layer setMasksToBounds:YES];
        [self addSubview:_redDot];
        
        _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(@"RightArrow")]];
        [_arrowImage setOrigin:CGPointMake(self.width - _arrowImage.width - 20, (60 - _arrowImage.height) / 2)];
        [self addSubview:_arrowImage];
        
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_statusLabel setTextColor:kCommonParentTintColor];
        [_statusLabel setFont:[UIFont systemFontOfSize:15]];
        [_statusLabel setText:@"当前"];
        [_statusLabel sizeToFit];
        [_statusLabel setFrame:CGRectMake(self.width - 20 - _statusLabel.width, (kChildCellHeight - _statusLabel.height) / 2, _statusLabel.width, _statusLabel.height)];
        [self addSubview:_statusLabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatar.right + 10, 0, _statusLabel.x - 10 - (_avatar.right + 10), kChildCellHeight)];
        [_nameLabel setFont:[UIFont systemFontOfSize:15]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self addSubview:_nameLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(_avatar.right, kChildCellHeight - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];

    }
    return self;
}

- (void)setChildInfo:(ChildInfo *)childInfo
{
    _childInfo = childInfo;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:_childInfo.avatar]];
    [_nameLabel setText:_childInfo.name];
    [_nameLabel sizeToFit];
    [_nameLabel setOrigin:CGPointMake(_avatar.right + 10, (kChildCellHeight - _nameLabel.height) / 2)];
}

- (void)setIsCurChild:(BOOL)isCurChild
{
    _isCurChild = isCurChild;
    [_statusLabel setHidden:!_isCurChild];
    [_arrowImage setHidden:_isCurChild];
}

- (void)setHasNew:(BOOL)hasNew
{
    _hasNew = hasNew;
    _redDot.hidden = !_hasNew;
    [_redDot setOrigin:CGPointMake(_nameLabel.right + 5, (kChildCellHeight - _redDot.height) / 2)];
}

@end

@interface ChildrenSelectVC ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView*    _tableView;
}
@property (nonatomic, copy)void (^completion)();
@end

@implementation ChildrenSelectVC

+ (void)showChildrenSelectWithCompletion:(void (^)())completion{
    ChildrenSelectVC *selectVC = [[ChildrenSelectVC alloc] init];
    [selectVC setCompletion:completion];
    [CurrentROOTNavigationVC pushViewController:selectVC animated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"切换孩子";
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [UserCenter sharedInstance].children.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"childrenCell";
    ChildrenCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(cell == nil){
        cell = [[ChildrenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    ChildInfo *childInfo = [UserCenter sharedInstance].children[indexPath.row];
    [cell setChildInfo:childInfo];
    [cell setIsCurChild:[childInfo.uid isEqualToString:[UserCenter sharedInstance].curChild.uid]];
    
    BOOL hasNew = [[UserCenter sharedInstance].statusManager hasNewForChildID:childInfo.uid];
    [cell setHasNew:hasNew];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChildInfo *childInfo = [UserCenter sharedInstance].children[indexPath.row];
    [[UserCenter sharedInstance] setCurChild:childInfo];
    [_tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
