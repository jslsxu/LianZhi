//
//  ResponseView.m
//  LianZhiParent
//
//  Created by jslsxu on 15/8/22.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ResponseView.h"

#define kPraiseViewHeight                   35
#define kHMargin                            10
#define kExtraHeight                        25
#define kMaxResponseNum                     5
#define kResponseItemCellMargin             3

#define kTopUpArrowHeight                   5
#define kResponseTableTopMargin             4

@implementation CommentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.width = kScreenWidth - 55 - 10;
        [self setBackgroundColor:[UIColor clearColor]];
        _commentLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_commentLabel setBackgroundColor:[UIColor clearColor]];
        [_commentLabel setFont:[UIFont systemFontOfSize:12]];
        [_commentLabel setNumberOfLines:0];
        [_commentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self addSubview:_commentLabel];
        
        UIView *selectedView = [[UIView alloc] initWithFrame:CGRectZero];
        [selectedView setBackgroundColor:[UIColor colorWithHexString:@"D0D0D0"]];
        [self setSelectedBackgroundView:selectedView];
    }
    return self;
}

- (void)setResponseItem:(ResponseItem *)responseItem
{
    _responseItem = responseItem;
    NSDictionary *userDic = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"395c9d"]};
    NSDictionary *contentDic = @{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"2c2c2c"]};
    NSMutableAttributedString *commentStr = [[NSMutableAttributedString alloc] init];
    [commentStr appendAttributedString:[[NSAttributedString alloc] initWithString:responseItem.sendUser.name attributes:userDic]];
    if(responseItem.commentItem.toUser.length > 0)
    {
        [commentStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" 回复 " attributes:contentDic]];
        [commentStr appendAttributedString:[[NSAttributedString alloc] initWithString:responseItem.commentItem.toUser attributes:userDic]];
    }
    [commentStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@":%@",responseItem.commentItem.content] attributes:contentDic]];
    [_commentLabel setAttributedText:commentStr];
    CGSize size = [commentStr.string boundingRectWithSize:CGSizeMake(self.width - 10 * 2, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:12]];
    [_commentLabel setFrame:CGRectMake(10, 3, size.width, size.height)];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    ResponseItem *responseItem = (ResponseItem *)modelItem;
    NSMutableString *comment = [[NSMutableString alloc] initWithString:responseItem.sendUser.name];
    if(responseItem.commentItem.toUser.length > 0)
        [comment appendFormat:@" 回复 %@",responseItem.commentItem.toUser];
    [comment appendFormat:@":%@",responseItem.commentItem.content];
    CGSize size = [comment boundingRectWithSize:CGSizeMake(width - 10 * 2, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:12]];
    return @(size.height + 6);
}

@end
@interface PraiseView ()

@end
@implementation PraiseView
+ (CGFloat)praiseHeightForPraiseArray:(NSArray *)praiseArray width:(CGFloat)width{
    if(praiseArray.count > 0){
        NSInteger leftMargin = 30;
        NSInteger itemWIdth = 22;
        NSInteger innerMargin = 5;
        NSInteger num = praiseArray.count;
        NSInteger countPerRow = (width - leftMargin) / (innerMargin + itemWIdth);
        NSInteger row = (num + countPerRow - 1) / countPerRow;
        return innerMargin + (innerMargin + itemWIdth) * row;
    }
    else{
        return 0;
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _praiseImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ActionPraiseHighlighted"]];
        [_praiseImageView setOrigin:CGPointMake(10, (self.height - _praiseImageView.height) / 2)];
        [self addSubview:_praiseImageView];
        
        _praiseListView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, self.width - 30, kPraiseViewHeight)];
        [self addSubview:_praiseListView];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, kPraiseViewHeight, self.width, kLineHeight)];
        [_sepLine setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [_sepLine setBackgroundColor:[UIColor colorWithHexString:@"D8D8D8"]];
        [self addSubview:_sepLine];
    }
    return self;
}

- (void)setPraiseArray:(NSArray *)praiseArray
{
    _praiseArray = praiseArray;
    [_praiseListView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger itemWIdth = 22;
    NSInteger innerMargin = 5;
    NSInteger num = _praiseArray.count;
    NSInteger countPerRow = _praiseListView.width / (innerMargin + itemWIdth);
    CGFloat height = 0;
    for (NSInteger i = 0; i < num; i++)
    {
        NSInteger row = i / countPerRow;
        NSInteger column = i - row * countPerRow;
        UserInfo *userInfo = _praiseArray[i];
        AvatarView *avatar = [[AvatarView alloc] initWithFrame:CGRectMake( (itemWIdth + innerMargin) * column, innerMargin + (itemWIdth + innerMargin) * row, itemWIdth, itemWIdth)];
        [avatar sd_setImageWithURL:[NSURL URLWithString:userInfo.avatar]];
        [_praiseListView addSubview:avatar];
        height = avatar.bottom + innerMargin;
    }
    [_praiseListView setHeight:height];
    [self setHeight:height];
}

@end

@interface ResponseView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ResponseView

+ (CGFloat)responseHeightForResponse:(ResponseModel *)responseModel forWidth:(CGFloat)width
{
    NSInteger height = 0;
    NSArray *praiseArray = responseModel.praiseArray;
    NSArray *responseArray = responseModel.responseArray;
    if(praiseArray.count > 0)
    {
        height += [PraiseView praiseHeightForPraiseArray:praiseArray width:width];
    }
    
    NSInteger tableHeight = 0;
    if(responseArray.count > 0)
    {
        NSInteger responseNum = MIN(kMaxResponseNum, responseArray.count);
        tableHeight += kResponseTableTopMargin;
        for (NSInteger i = 0; i < responseNum; i++)
        {
            ResponseItem *responseItem = responseArray[i];
            NSInteger itemHeight = [CommentCell cellHeight:responseItem cellWidth:width].floatValue;
            tableHeight += itemHeight;
        }
        tableHeight += kExtraHeight + kResponseItemCellMargin;
    }
    height += tableHeight;
    if(height > 0)
        height += kTopUpArrowHeight;
    return height;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setClipsToBounds:YES];
        _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ResponseUpArrow"]];
        [_arrowImage setOrigin:CGPointMake(20, 0.5)];
        [self addSubview:_arrowImage];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopUpArrowHeight, self.width, 0)];
        [_contentView setBackgroundColor:[UIColor colorWithHexString:@"f1f1f1"]];
        [_contentView.layer setCornerRadius:10];
        [_contentView.layer setMasksToBounds:YES];
        [self addSubview:_contentView];
        
        _praiseView = [[PraiseView alloc] initWithFrame:CGRectMake(0, 0, self.width, kPraiseViewHeight)];
        [_praiseView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_contentView addSubview:_praiseView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDetailClicked)];
        [_praiseView addGestureRecognizer:tapGesture];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kPraiseViewHeight, self.width , 50 * 2 + 5 * 2) style:UITableViewStylePlain];
        [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setScrollEnabled:NO];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_contentView addSubview:_tableView];
    }
    return self;
}

- (void)setResponseModel:(ResponseModel *)responseModel
{
    _responseModel = responseModel;
    NSInteger height = 0;
    NSArray *praiseArray = _responseModel.praiseArray;
    NSArray *responseArray = _responseModel.responseArray;
    if(praiseArray.count > 0)
    {
        [_praiseView setHidden:NO];
        [_praiseView setPraiseArray:praiseArray];
        height += _praiseView.height;
    }
    else
        [_praiseView setHidden:YES];
    
    NSInteger tableHeight = 0;
    if(responseArray.count > 0)
    {
        NSInteger responseNum = MIN(kMaxResponseNum, responseArray.count);
        for (NSInteger i = 0; i < responseNum; i++)
        {
            ResponseItem *responseItem = responseArray[i];
            NSInteger itemHeight = [CommentCell cellHeight:responseItem cellWidth:_tableView.width].floatValue;
            tableHeight += itemHeight;
        }
        tableHeight += kExtraHeight + kResponseItemCellMargin;
        [_tableView setHidden:NO];
        [_tableView setFrame:CGRectMake(0, height + kResponseTableTopMargin, self.width, tableHeight)];
        [_tableView reloadData];
        tableHeight += kResponseTableTopMargin;
    }
    else
        [_tableView setHidden:YES];
    height += tableHeight;
    if(height > 0)
        height += kTopUpArrowHeight;
    [_contentView setFrame:CGRectMake(0, kTopUpArrowHeight, self.width, height - kTopUpArrowHeight)];
    [self setHeight:height];
}

- (void)onDetailClicked
{
    if([self.delegate respondsToSelector:@selector(onDetailClicked)])
        [self.delegate onDetailClicked];
}

#pragma mark - UITableVIewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = MIN(self.responseModel.responseArray.count, kMaxResponseNum);
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(self.responseModel.responseArray.count == 0)
        return 0.1;
    else
        return kExtraHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSInteger count = self.responseModel.responseArray.count;
    if(count == 0)
        return nil;
    else
    {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, kExtraHeight)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, footerView.width - 10 * 2, footerView.height)];
        [label setFont:[UIFont systemFontOfSize:12]];
        [label setTextColor:[UIColor colorWithHexString:@"395c9d"]];
        [label setTextAlignment:NSTextAlignmentRight];
        NSString *extraStr = nil;
        if(kMaxResponseNum >= count)//查看详情
            extraStr = @"查看详情>";
        else
            extraStr = [NSString stringWithFormat:@"更多评论(%ld)>",count];
        [label setText:extraStr];
        [footerView addSubview:label];
        
        UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [coverButton setFrame:label.frame];
        [coverButton addTarget:self action:@selector(onDetailClicked) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:coverButton];
        return footerView;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"CommentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    [cell setResponseItem:self.responseModel.responseArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CommentCell cellHeight:self.responseModel.responseArray[indexPath.row] cellWidth:tableView.width].floatValue;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([self.delegate respondsToSelector:@selector(onResponseItemClicked:)])
    {
        ResponseItem *item = self.responseModel.responseArray[indexPath.row];
        [self.delegate onResponseItemClicked:item];
    }
}
@end
