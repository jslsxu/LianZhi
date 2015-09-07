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
    if(responseItem.targetUser)
    {
        [commentStr appendAttributedString:[[NSAttributedString alloc] initWithString:@" 回复 " attributes:contentDic]];
        [commentStr appendAttributedString:[[NSAttributedString alloc] initWithString:responseItem.targetUser.name attributes:userDic]];
    }
    [commentStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@":%@",responseItem.content] attributes:contentDic]];
    [_commentLabel setAttributedText:commentStr];
    CGSize size = [commentStr.string boundingRectWithSize:CGSizeMake(self.width - 10 * 2, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:12]];
    [_commentLabel setFrame:CGRectMake(10, 3, size.width, size.height)];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    ResponseItem *responseItem = (ResponseItem *)modelItem;
    NSMutableString *comment = [[NSMutableString alloc] initWithString:responseItem.sendUser.name];
    if(responseItem.targetUser)
        [comment appendFormat:@" 回复 %@",responseItem.targetUser.name];
    [comment appendFormat:@":%@",responseItem.content];
    CGSize size = [comment boundingRectWithSize:CGSizeMake(width - 10 * 2, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:12]];
    return @(size.height + 6);
}

@end
@interface PraiseView ()

@end
@implementation PraiseView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _praiseImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ActionPraiseHighlighted"]];
        [_praiseImageView setOrigin:CGPointMake(10, (self.height - _praiseImageView.height) / 2)];
        [self addSubview:_praiseImageView];

        _praiseListView = [[UIView alloc] initWithFrame:CGRectMake(_praiseImageView.right + 5, 0, self.width - 10 - (_praiseImageView.right + 5), kPraiseViewHeight)];
        [self addSubview:_praiseListView];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, kPraiseViewHeight, self.width, kLineHeight)];
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
    NSInteger num = MIN(_praiseArray.count, 6);
    NSInteger spaceXStart = 0;
    for (NSInteger i = 0; i < num; i++)
    {
        AvatarView *avatar = [[AvatarView alloc] initWithFrame:CGRectMake(spaceXStart, (_praiseListView.height - itemWIdth) / 2, itemWIdth, itemWIdth)];
        [avatar setImageWithUrl:[NSURL URLWithString:_praiseArray[i]]];
        [_praiseListView addSubview:avatar];
        spaceXStart += (itemWIdth + innerMargin);
    }
    if(_praiseArray.count > 6)
    {
        UIImageView *moreView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ActionPraiseMore"]];
        [moreView setOrigin:CGPointMake(spaceXStart, (_praiseListView.height - moreView.height) / 2)];
        [_praiseListView addSubview:moreView];
    }
}

@end

@interface ResponseView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ResponseView

+ (CGFloat)responseHeightForResponse:(ClassZoneItem *)classZoneItem
{
    NSInteger height = 0;
    NSArray *praiseArray = classZoneItem.praiseArray;
    NSArray *responseArray = classZoneItem.responseArray;
    if(praiseArray.count > 0)
    {
        height += kPraiseViewHeight;
    }
    
    NSInteger tableHeight = 0;
    if(responseArray.count > 0)
    {
        for (ResponseItem *responseItem in responseArray)
        {
            NSInteger itemHeight = [CommentCell cellHeight:responseItem cellWidth:kScreenWidth - 55 - 10].floatValue;
            tableHeight += itemHeight;
        }
    }
    height += tableHeight;
    return height;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"F0F0F0"]];
        [self.layer setCornerRadius:10];
        [self.layer setMasksToBounds:YES];
        
        _praiseView = [[PraiseView alloc] initWithFrame:CGRectMake(0, 0, self.width, kPraiseViewHeight)];
        [_praiseView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [self addSubview:_praiseView];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kPraiseViewHeight, self.width , 50 * 2 + 5 * 2) style:UITableViewStylePlain];
        [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setScrollEnabled:NO];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self addSubview:_tableView];
    }
    return self;
}

- (void)setClassZoneItem:(ClassZoneItem *)classZoneItem
{
    _classZoneItem = classZoneItem;
    NSInteger height = 0;
    NSArray *praiseArray = classZoneItem.praiseArray;
    NSArray *responseArray = classZoneItem.responseArray;
    if(praiseArray.count > 0)
    {
        [_praiseView setHidden:NO];
        [_praiseView setPraiseArray:praiseArray];
        height += kPraiseViewHeight;
    }
    else
        [_praiseView setHidden:YES];
    
    NSInteger tableHeight = 0;
    if(responseArray.count > 0)
    {
        for (ResponseItem *responseItem in responseArray)
        {
            NSInteger itemHeight = [CommentCell cellHeight:responseItem cellWidth:_tableView.width].floatValue;
            tableHeight += itemHeight;
        }
        [_tableView setHidden:NO];
        [_tableView setFrame:CGRectMake(0, height, self.width, tableHeight)];
        [_tableView reloadData];
    }
    else
        [_tableView setHidden:YES];
    height += tableHeight;
    [self setHeight:height];
}

#pragma mark - UITableVIewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.classZoneItem.responseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"CommentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    [cell setResponseItem:self.classZoneItem.responseArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CommentCell cellHeight:self.classZoneItem.responseArray[indexPath.row] cellWidth:tableView.width].floatValue;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([self.delegate respondsToSelector:@selector(onResponseItemClicked:)])
    {
        ResponseItem *item = self.classZoneItem.responseArray[indexPath.row];
        [self.delegate onResponseItemClicked:item];
    }
}
@end
