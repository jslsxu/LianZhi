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
#import "QrCodeView.h"
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
    UILabel*        _hintLabel;
    UITextField*    _textField;
    UIImageView*    _qrImageIcon;
    UIView*         _sepLine;
}
@property (nonatomic, readonly)UITextField *textField;
@property (nonatomic, strong)PersonalInfoItem *infoItem;
@end


@interface PersonalInfoVC : UITableViewController<UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UILabel*                _idLabel;
    AvatarView*             _avatar;
    UIButton*               _modifyButton;
    UITextField*            _nameField;
    UILabel*                _genderLabel;
    NSMutableArray*         _infoArray;
    UIView *                _headerView;
}
@end
