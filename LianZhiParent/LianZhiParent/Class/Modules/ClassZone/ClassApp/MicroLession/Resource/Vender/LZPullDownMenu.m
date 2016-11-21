//
//  LZPullDownMenu.m
//  LianzhiParent
//
//  Created by Chen qi 开发者 on 16/5/19.
//  Copyright © 2016年 chen. All rights reserved.
//

#import "LZPullDownMenu.h"
#import "ResourceDefine.h"

#import <objc/runtime.h>

#define Kscreen_width  [UIScreen mainScreen].bounds.size.width
#define Kscreen_height [UIScreen mainScreen].bounds.size.height
#define KTitleButtonHeight 44

// 格式 0xff3737
#define RGBHexAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define KDefaultColor RGBHexAlpha(0x189cfb, 1)

#define KmaskBackGroundViewColor  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:.75]
#define kCellBgColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:.7]

#define KTableViewCellHeight 40

#define KDisplayMaxCellOfNumber  8

#define KTitleButtonTag 1000


#define KOBJCSetObject(object,value)  objc_setAssociatedObject(object,@"title" , value, OBJC_ASSOCIATION_RETAIN_NONATOMIC)

#define KOBJCGetObject(object) objc_getAssociatedObject(object, @"title")

@interface LZPullDownMenu () <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    UITapGestureRecognizer *tapGesture;
}

@property (nonatomic) NSArray *titleArray ;

@property (nonatomic)UITableView *tableView;
@property (nonatomic)NSMutableArray *tableDataArray;

@property (nonatomic) CGFloat selfOriginalHeight ;
@property (nonatomic) CGFloat tableViewMaxHeight ;

@property (nonatomic) NSMutableArray *buttonArray;

@property (nonatomic) UIView  *maskBackGroundView;


@end

@implementation LZPullDownMenu


- (instancetype)initWithFrame:(CGRect)frame menuTitleArray:(NSArray *)titleArray
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.tableViewMaxHeight = KTableViewCellHeight * KDisplayMaxCellOfNumber;
        self.selfOriginalHeight =frame.size.height;
        self.titleArray =titleArray;
        [self addSubview:self.maskBackGroundView];
 
        [self configBaseInfo];
        
        [self addSubview:self.tableView];
        
    }
    return self;
}

-(void)configBaseInfo
{
    
    //    self.backgroundColor=KmaskBackGroundViewColor;
    
    //用于遮盖self.backgroundColor 。
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Kscreen_width, KTitleButtonHeight)];
    view.backgroundColor= WhiteColor;
    [self addSubview:view];
    
    CGFloat width = Kscreen_width /self.titleArray.count;
    
    for (int index=0; index<self.titleArray.count; index++) {
        
        UIButton *titleButton=[UIButton buttonWithType:UIButtonTypeCustom];
        
        titleButton.frame= CGRectMake(width * index + 1, 0, width - 1, KTitleButtonHeight);
        titleButton.backgroundColor =[UIColor clearColor];
        [titleButton setTitle:self.titleArray[index] forState:UIControlStateNormal];
        [titleButton setTitleColor:JXColor(0x5c,0x5d,0x5d,1) forState:UIControlStateNormal];
        titleButton.tag =KTitleButtonTag + index ;
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [titleButton setTitleColor:GreenLineColor forState:UIControlStateSelected];
        [titleButton setImage:[UIImage imageNamed:@"iconTc1"] forState:UIControlStateNormal];
        [titleButton setImage:[UIImage imageNamed:@"iconTc2"] forState:UIControlStateSelected];
        titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, width - 40 , 0, 0);
        
        [self addSubview:titleButton];
        [self.buttonArray addObject:titleButton];
        
        if (index < self.titleArray.count -1) {
            UILabel *sepLabel=[[UILabel alloc]init];
            sepLabel.frame=CGRectMake(width * (index + 1)  , 5 , 1, KTitleButtonHeight - 10);
            [sepLabel setBackgroundColor:JXColor(0xd7, 0xd7, 0xd7, 1)]; //JXColor(0xd7, 0xd7, 0xd7, 1)
            [self addSubview:sepLabel];
        }
    }
    
}

-(void)tableViewReloadData
{
    [_tableView reloadData];
}
-(UITableView *)tableView
{
    if (_tableView) {
        return _tableView;
    }
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, Kscreen_width, 0)];
    self.tableView.tag = 2002;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.tableView.rowHeight= KTableViewCellHeight;
    
    
    return self.tableView;
}


#pragma mark  --  <代理方法>
-(void)closeTableView
{
    
    if(self.tempButton && self.tempButton.selected)
    {
        [self takeBackTableView];
    }
}

#pragma mark  --  <UITableViewDelegate,UITableViewDataSource>

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableDataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    downMenuCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell =[[downMenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = self.tableDataArray[indexPath.row];
//    NSLog(@"cell.textLabel.text = %@",cell.textLabel.text);
    NSString *objcTitle = KOBJCGetObject(self.tempButton);
    
    if ([cell.textLabel.text isEqualToString:objcTitle]) {
        cell.isSelected = YES;
    }
    else
    {
        cell.isSelected=NO;
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    downMenuCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setIsSelected:YES];
    
    [self.tempButton setTitle:cell.textLabel.text forState:UIControlStateNormal];
    [tableView reloadData];
    KOBJCSetObject(self.tempButton, cell.textLabel.text);
    
    if (self.handleSelectDataBlock) {
        self.handleSelectDataBlock(cell.textLabel.text,indexPath.row,self.tempButton.tag - KTitleButtonTag);
    }
    
//    [self takeBackTableView];
    
}



-(void)setDefauldSelectedCell
{
    
    for (int index=0; index<self.buttonArray.count; index++) {
        
        self.tableDataArray =self.menuDataArray[index];
        
        UIButton *button =self.buttonArray[index];
        
        NSString *title = self.tableDataArray.firstObject;
        
        KOBJCSetObject(button, title);
        
    }
    
    [self takeBackTableView];
    
}

-(void)resetMiddleButtonTitle{
    for (int index=0; index<self.buttonArray.count; index++) {
 
        UIButton *button =self.buttonArray[index];
        if(button.tag == KTitleButtonTag +1){
//            self.tableDataArray =self.menuDataArray[index];
//            NSString *title = self.tableDataArray.firstObject;
            [button setTitle:@"能力" forState:UIControlStateNormal];
            break;
        }
        
    }
}
-(void)titleButtonClick:(UIButton *)titleButton
{
    if (self.handleTitleSelectDataBlock) {
        self.handleTitleSelectDataBlock(titleButton.tag);
    }
    
    NSUInteger index =  titleButton.tag - KTitleButtonTag;
    
    for (UIButton *button in self.buttonArray) {
        if (button == titleButton) {
            button.selected=!button.selected;
            self.tempButton =button;
//            self.tempButton.titleLabel.textColor = GreenLineColor;
        }else
        {
            button.selected=NO;
//            [button setTitleColor:JXColor(0x5c,0x5d,0x5d,1) forState:UIControlStateNormal];
        }
    }
    
    
    if (titleButton.selected) {
        
        self.tableDataArray = self.menuDataArray[index];
        
        //设置默认选中第一项。
        if ([KOBJCGetObject(self.tempButton) length]<1) {
            
            NSString *title = self.tableDataArray.firstObject;
            KOBJCSetObject(self.tempButton, title);
            
        }
        
        [self.tableView reloadData];
        
        CGFloat tableViewHeight =  self.tableDataArray.count * KTableViewCellHeight < self.tableViewMaxHeight ?
        self.tableDataArray.count * KTableViewCellHeight : self.tableViewMaxHeight;
        
        
        [self expandWithTableViewHeight:tableViewHeight];
        
    }else
    {
        [self takeBackTableView];
    }
    
    //    NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
    //    [_tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}



//展开。
-(void)expandWithTableViewHeight:(CGFloat )tableViewHeight
{
    
    self.maskBackGroundView.hidden=NO;
    
    CGRect rect = self.frame;
    rect.size.height = Kscreen_height - self.frame.origin.y;
    self.frame= rect;
    
    [self showSpringAnimationWithDuration:0.3 animations:^{
        
        self.tableView.frame = CGRectMake(0, self.selfOriginalHeight, Kscreen_width, tableViewHeight);
        
        self.maskBackGroundView.alpha =1;
        
        tapGesture.enabled = YES;
        
    } completion:^{
        
    }];
}

//收起。
-(void)takeBackTableView
{
    for (UIButton *button in self.buttonArray) {
        button.selected=NO;
    }
    
    CGRect rect = self.frame;
    rect.size.height = self.selfOriginalHeight;
    self.frame = rect;
    
    if (self.closeViewBlock) {
        self.closeViewBlock();
    }
    
    [self showSpringAnimationWithDuration:.3 animations:^{
        
        self.tableView.frame = CGRectMake(0, self.selfOriginalHeight, Kscreen_width,0);;
        self.maskBackGroundView.alpha =0;
        
    } completion:^{
        self.maskBackGroundView.hidden=YES;
        tapGesture.enabled = NO;
    }];
    
}



-(void)showSpringAnimationWithDuration:(CGFloat)duration
                            animations:(void (^)())animations
                            completion:(void (^)())completion
{
    
    //    [UIView animateWithDuration:duration animations:^{
    //        if (animations) {
    //            animations();
    //        }
    //        
    //    } completion:^(BOOL finished) {
    //        if (completion) {
    //            completion();
    //        }
    //    }];
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:.8 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        if (animations) {
            animations();
        }
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}



-(void)maskBackGroundViewTapClick
{
    
    
    [self takeBackTableView];
}



-(NSMutableArray *)menuDataArray
{
    if (_menuDataArray) {
        return _menuDataArray;
    }
    self.menuDataArray =[[NSMutableArray alloc]init];
    
    return self.menuDataArray;
}


-(NSMutableArray *)tableDataArray
{
    if (_tableDataArray) {
        return _tableDataArray;
    }
    self.tableDataArray = [[NSMutableArray alloc]init];
    
    return self.tableDataArray;
}

-(NSMutableArray *)buttonArray
{
    if (_buttonArray) {
        return _buttonArray;
    }
    self.buttonArray =[[NSMutableArray alloc]init];
    
    return self.buttonArray;
}

-(UIView *)maskBackGroundView
{
    if (_maskBackGroundView) {
        return _maskBackGroundView;
    }
    self.maskBackGroundView=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width, Kscreen_height - self.frame.origin.y)];
    self.maskBackGroundView.backgroundColor=KmaskBackGroundViewColor;
    self.maskBackGroundView.hidden=YES;
    self.maskBackGroundView.userInteractionEnabled=YES;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskBackGroundViewTapClick)];
//    tap.delegate = self;
    
    __weak typeof(self) wself = self;
    tapGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [wself maskBackGroundViewTapClick];
    }];
//    tapGesture.delegate = self;
    [self.maskBackGroundView addGestureRecognizer:tapGesture];
    
    return self.maskBackGroundView;
}

#pragma mark UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    
//    if ([touch.view isKindOfClass:[UIButton class]]) {
//        //放过button点击拦截
//        return NO;
//    }else{
//        return YES;
//    }
//    
//}

//重写该方法后可以让超出父视图范围的子视图响应事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }
    return view;
}
@end




@implementation downMenuCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configCellView];
    }
    
    return self;
}


-(void)configCellView
{
    self.selectImageView.hidden=YES;
    self.textLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.selectImageView];
}


-(UIImageView *)selectImageView
{
    if (_selectImageView) {
        return _selectImageView;
    }
    
    UIImage *image = [UIImage imageNamed:@"checked"];
    self.selectImageView = [[UIImageView alloc]init];
    self.selectImageView.image=image;
    
    self.selectImageView.frame = CGRectMake(0,0,image.size.width,image.size.height);
    
    self.selectImageView.center = CGPointMake(Kscreen_width-40, self.frame.size.height/2);
    
    return self.selectImageView;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (isSelected) {
        self.textLabel.textColor = GreenLineColor;
        
        self.selectImageView.hidden = NO;
    }else
    {
        self.textLabel.textColor = GrayLblColor;
        self.selectImageView.hidden = YES;

    }
    self.backgroundColor =kCellBgColor;
}

@end











