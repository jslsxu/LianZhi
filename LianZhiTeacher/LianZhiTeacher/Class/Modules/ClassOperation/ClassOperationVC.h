//
//  ClassOperationVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/3.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "ClassOperationHeaderView.h"
#import "StudentGridView.h"
#import "ClassTableCell.h"
#import "ClassBatOperationView.h"
#import "IndividualOperationView.h"
#import "PhotoOperationVC.h"
#import "GrowthTimelinePublishVC.h"
#import "ClassZoneVC.h"
@interface ClassOperationVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, ClassBatOperationDelegate,ClassOperationDelegate, ActionSelectViewDelegate, PhotoOperationDelegate>
{
    NSMutableArray*                     _publishPool;
    
}
@end
