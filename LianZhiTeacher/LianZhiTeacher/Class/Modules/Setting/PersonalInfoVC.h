//
//  PersonalInfoVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/3.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

#import "SettingDatePickerView.h"
#import "PasswordModifyVC.h"
@interface PersonalInfoItem : TNModelItem
@property (nonatomic, copy)NSString *requestKey;
@property (nonatomic, copy)NSString *key;
@property (nonatomic, copy)NSString *value;
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, assign)BOOL changeDirectly;
- (instancetype)initWithKey:(NSString *)key value:(NSString *)value canEdit:(BOOL)canEdit;
@end

@interface PersonalInfoCell : UITableViewCell<UITextFieldDelegate>
{
    UIView*         _sepLine;
}
@property (nonatomic, strong)PersonalInfoItem *infoItem;
@end


@interface PersonalInfoVC : UITableViewController<UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    AvatarView*             _avatar;
    UIButton*               _modifyButton;
    NSMutableArray*         _infoArray;
    UIView *                _headerView;
}
@end
