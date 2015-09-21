//
//  StudentParentsVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/9/14.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "StudentParentsVC.h"
#import "JSMessagesViewController.h"
@implementation StudentParentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatButton setFrame:CGRectMake(self.width - 40 - 10, (self.height - 30) / 2, 40, 30)];
        [_chatButton addTarget:self action:@selector(onChatClicked) forControlEvents:UIControlEventTouchUpInside];
        [_chatButton setImage:[UIImage imageNamed:@"SingleChatNormal"] forState:UIControlStateNormal];
        [_chatButton setImage:[UIImage imageNamed:@"SignleChatHighlighted"] forState:UIControlStateHighlighted];
        [self addSubview:_chatButton];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
    }
    return self;
}

- (void)onChatClicked
{
    JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
    [ApplicationDelegate popAndPush:chatVC];
}

@end

@interface StudentParentsVC ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation StudentParentsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
}

#pragma mark - 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"爸爸";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"ParentCell";
    StudentParentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[StudentParentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.textLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
    }
    [cell.textLabel setText:@"爸爸"];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
