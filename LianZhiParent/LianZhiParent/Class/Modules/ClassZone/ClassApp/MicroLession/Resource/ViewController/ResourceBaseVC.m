//
//  ResourceBaseVC.m
//  LianZhiParent
//
//  Created by Chen Qi on 2016/9/29.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ResourceBaseVC.h"
#import "ResourceDefine.h"


@interface ResourceBaseVC ()<headLineDelegate>
{
    
}
@property(nonatomic,strong)LZHeadLineView *headLineView;//顶部菜单按钮视图

@end

@implementation ResourceBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置顶部菜单按钮视图
    [self setHeadLineView];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
#pragma mark - Navigation
//设置顶部菜单按钮视图
-(void)setHeadLineView
{
    if (!_headLineView) {
        _headLineView=[[LZHeadLineView alloc]init];
        _headLineView.frame = CGRectMake(0, 64, self.view.width, 48);
        _headLineView.backgroundColor = WhiteColor;
        _headLineView.delegate= self;
        
        [self.view addSubview:_headLineView];
    }
    
}
//设置顶部菜单按钮视图显示的字段名数组
-(void)setTitleArray:(NSArray *)titleArray
{
    [_headLineView setTitleArray:titleArray];
}

-(void)setHeadViewCurrentIndex:(NSInteger)CurrentIndex
{
     [_headLineView setCurrentIndex:CurrentIndex];
}

-(void)initViewCurrentIndex
{
    // 改变currentIndex
//    _headLineView.CurrentIndex= 0;
    // 刷新界面
    [_headLineView shuaxinJiemian:self.currentIndex];
}
//设置顶部菜单按钮视图滑动事件处理
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    UIView *targetview = sender.view;
    if(targetview.tag == 1) {
        return;
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (_currentIndex>1) {
            return;
        }
        _currentIndex++;
    }else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if (_currentIndex<=0) {
            return;
        }
        _currentIndex--;
    }
    [_headLineView setCurrentIndex:_currentIndex];
}

//设置顶部菜单按钮视图当前Index
-(void)refreshHeadLine:(NSInteger)currentIndex
{
    _currentIndex=currentIndex;
    
}


- (UIView *)emptydataView{
    if(!_emptydataView){
        
        CGFloat naviframeHeight = CurrentROOTNavigationVC.navigationBar.height;
        CGFloat frameHeight = self.view.frame.size.height - naviframeHeight - 48 - 20 ;

        _emptydataView = [[UIView alloc] initWithFrame:CGRectMake(0, naviframeHeight + 48 + 21, WIDTH, frameHeight)];
        _emptydataView.backgroundColor = BgGrayColor;
        
        UIImageView *_imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nodataImage"]];
        [_emptydataView addSubview:_imageView];
        [_imageView setCenter:CGPointMake(_emptydataView.width / 2, _emptydataView.height / 2 - 20)];
    }
    

    return _emptydataView;
}


//显示对话框
-(void)showAlert:(NSString *)message
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}


@end
