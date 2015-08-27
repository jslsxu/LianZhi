//
//  ResponseView.h
//  LianZhiParent
//
//  Created by jslsxu on 15/8/22.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : TNTableViewCell
{
    UILabel*    _commentLabel;
}

@end

@interface PraiseView : UIView
{
    
}
@end

@interface ResponseView : UIView
{
    UICollectionView*   _praiseView;
    UIImageView*        _moreView;
    UIImageView*        _praiseImageView;
    UIView*             _sepLine;
    
}
@end
