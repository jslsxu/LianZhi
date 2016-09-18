//
//  SearchChatMessageVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/2.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "SearchChatMessageVC.h"
#import "JSMessagesViewController.h"

@implementation SearchChatItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.width = kScreenWidth;
        _avatarView = [[AvatarView alloc] initWithRadius:25];
        [_avatarView setOrigin:CGPointMake(12, (75 - _avatarView.height) / 2)];
        [self addSubview:_avatarView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setFont:[UIFont systemFontOfSize:15]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_timeLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_timeLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_contentLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_contentLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 75 - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
    }
    return self;
}

- (void)updateWithMessage:(MessageItem *)messageItem keyword:(NSString *)keyword{
    self.messageItem = messageItem;
    self.keyword = keyword;
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:self.messageItem.user.avatar]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.messageItem.content.ctime];
    NSString *timeStr = [formatter stringFromDate:date];

    [_timeLabel setText:timeStr];
    [_timeLabel sizeToFit];
    [_timeLabel setOrigin:CGPointMake(self.width - _timeLabel.width - 12, 20)];
    [_nameLabel setText:self.messageItem.user.name];
    [_nameLabel sizeToFit];
    [_nameLabel setFrame:CGRectMake(_avatarView.right + 12, 18, _timeLabel.left - 10 - (_avatarView.right + 12), _nameLabel.height)];
    NSString *contentText = self.messageItem.content.text;
    NSRange range = [contentText rangeOfString:keyword];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contentText];
    [attrStr setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]} range:NSMakeRange(0, contentText.length)];
    [attrStr setAttributes:@{NSForegroundColorAttributeName : kCommonParentTintColor} range:range];
    [_contentLabel setWidth:self.width - 10 - _nameLabel.left];
    [_contentLabel setAttributedText:attrStr];
    [_contentLabel sizeToFit];
    [_contentLabel setOrigin:CGPointMake(_nameLabel.left, 45)];
    
    [_sepLine setFrame:CGRectMake(0, _contentLabel.bottom + 15 - kLineHeight, self.width, kLineHeight)];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width{
    MessageItem *messageItem = (MessageItem *)modelItem;
    CGSize size = [messageItem.content.text boundingRectWithSize:CGSizeMake(kScreenWidth - 10 - 12 * 2 - 50, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:14]];
    return @(MAX(size.height + 45 + 15, 75));
}

@end

@interface SearchChatMessageVC ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong)UISearchBar*           searchBar;
@property (nonatomic, strong)UITableView*           tableView;
@property (nonatomic, strong)NSMutableArray*        searchResultArray;
@end

@implementation SearchChatMessageVC

- (void)dealloc{
    [self resignKeyboard];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查找聊天记录";
    self.searchResultArray = [NSMutableArray array];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    [_searchBar setBackgroundColor:[UIColor whiteColor]];
    [_searchBar setDelegate:self];
    [self.view addSubview:_searchBar];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.height, self.view.width, self.view.height - 64 - self.searchBar.height) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    [self addKeyboardNotifications];
}

- (EmptyHintView *)emptyView{
    if(!_emptyView){
        _emptyView = [[EmptyHintView alloc] initWithImage:@"NoSearchChatRecord" title:@"暂时没有聊天记录"];
    }
    return _emptyView;
}

- (void)onKeyboardWillShow:(NSNotification *)note{
    NSDictionary *userInfo = [note userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    NSInteger keyboardHeight = keyboardRect.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, keyboardHeight, 0)];
    }];
}

- (void)onKeyboardWillHide:(NSNotification *)note{
    NSDictionary *userInfo = [note userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:0.3 animations:^{
        [self.tableView setContentInset:UIEdgeInsetsZero];
    }];
}

- (void)searchResultForKeyword:(NSString *)keyword{
    NSArray *vcArray = self.navigationController.viewControllers;
    JSMessagesViewController *targetVC;
    for (UIViewController *vc in vcArray) {
        if([vc isKindOfClass:[JSMessagesViewController class]]){
            targetVC = (JSMessagesViewController *)vc;
        }
    }

    ChatMessageModel *messageModel = [targetVC curChatMessageModel];
    NSArray *resultArray = [messageModel searchMessageWithKeyword:keyword from:self.searchResultArray.count];
    [self.searchResultArray addObjectsFromArray:resultArray];
    [self.tableView reloadData];
    if(self.searchResultArray.count == 0){
        [self.tableView setMj_footer:nil];
    }
    else{
        if(self.tableView.mj_footer == nil){
            @weakify(self)
            [self.tableView setMj_footer:[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                @strongify(self)
                [self searchResultForKeyword:[self.searchBar text]];
            }]];
        }
        else{
            if(resultArray.count == 20){
                [self.tableView.mj_footer endRefreshing];
            }
            else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }
}

- (void)clear{
    [self.searchResultArray removeAllObjects];
    [self.tableView reloadData];
}


#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self clear];
    [self searchResultForKeyword:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self clear];
     [self searchResultForKeyword:searchBar.text];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = [self.searchResultArray count];
    [self showEmptyView:count == 0];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [SearchChatItemCell cellHeight:self.searchResultArray[indexPath.row] cellWidth:tableView.width].floatValue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseID = @"SearchChatCell";
    SearchChatItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(cell == nil){
        cell = [[SearchChatItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        
    }
    MessageItem *messageItem = self.searchResultArray[indexPath.row];
    [cell updateWithMessage:messageItem keyword:self.searchBar.text];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MessageItem *messageItem = self.searchResultArray[indexPath.row];
    NSArray *vcArray = self.navigationController.viewControllers;
    JSMessagesViewController *targetVC;
    for (UIViewController *vc in vcArray) {
        if([vc isKindOfClass:[JSMessagesViewController class]]){
            targetVC = (JSMessagesViewController *)vc;
        }
    }
    if(targetVC){
        [targetVC scrollToSearchResult:messageItem];
        [self.navigationController popToViewController:targetVC animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([_searchBar isFirstResponder]){
        [_searchBar resignFirstResponder];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
