//
//  ResponseView.h
//  LianZhiParent
//
//  Created by jslsxu on 15/8/22.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassZoneModel.h"
@interface CommentCell : TNTableViewCell
{
    UILabel*    _commentLabel;
}
@property (nonatomic, strong)ResponseItem *responseItem;
@end

@interface PraiseView : UIView
{
    UIImageView*        _praiseImageView;
    UIView*             _praiseListView;
    UIView*             _sepLine;
}
@property (nonatomic, strong)NSArray *praiseArray;
+ (CGFloat)praiseHeightForPraiseArray:(NSArray *)praiseArray width:(CGFloat)width;
@end

@protocol ResponseDelegate <NSObject>
- (void)onDetailClicked;
- (void)onResponseItemClicked:(ResponseItem *)responseItem;

@end

@interface ResponseView : UIView
{
    UIImageView*        _arrowImage;
    UIView*             _contentView;
    PraiseView*         _praiseView;
    UITableView*        _tableView;
}
@property (nonatomic, strong)ResponseModel *responseModel;
@property (nonatomic, weak)id<ResponseDelegate> delegate;
+ (CGFloat)responseHeightForResponse:(ResponseModel *)responseModel forWidth:(CGFloat)width;
@end
