//
//  BGTableViewCell.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/23.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TableViewCellType) {
    TableViewCellTypeFirst,
    TableViewCellTypeMiddle,
    TableViewCellTypeLast,
    TableViewCellTypeSingle,
    TableViewCellTypeAny
};


@interface BGTableViewCell : UITableViewCell
{
    
}
@property (nonatomic, assign)TableViewCellType cellType;
- (UIImage *)BGImageForCellType:(TableViewCellType)cellType;
- (UIImage *)highlightedBGImageForCellType:(TableViewCellType)cellType;
+(TableViewCellType)cellTypeForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
@end
