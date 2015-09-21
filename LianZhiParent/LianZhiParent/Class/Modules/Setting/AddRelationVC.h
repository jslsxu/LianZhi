//
//  AddRelationVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/2/6.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "PersonalInfoVC.h"
@interface AddRelationVC : UITableViewController<ActionSelectViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSMutableArray*         _infoArray;
    NSArray*                _relationArray;

}
@property (nonatomic, strong)ChildInfo *childInfo;
@end
