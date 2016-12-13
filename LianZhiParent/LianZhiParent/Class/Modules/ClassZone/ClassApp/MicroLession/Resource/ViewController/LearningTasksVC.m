//
//  LearningTasksVC.m
//  LianZhiParent
//
//  Created by Chen Qi on 2016/9/28.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "LearningTasksVC.h"
#import "LZHeadLineView.h"
#import "LearningTasksCell.h"

@interface LearningTasksVC ()<headLineDelegate,UITableViewDataSource, UITableViewDelegate>
{
    UITableView*        _tableView;
}

@property(nonatomic,strong)LZHeadLineView *headLineView;//
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,strong)NSMutableArray *infoArray;
@end

@implementation LearningTasksVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setHeadLineView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 112, self.view.width, self.view.height - 156) style:UITableViewStyleGrouped];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)setHeadLineView
{
    if (!_headLineView) {
        _headLineView=[[LZHeadLineView alloc]init];
        _headLineView.frame=CGRectMake(0, 64, self.view.width, 48);
        _headLineView.delegate=self;
        [_headLineView setTitleArray:@[@"语文",@"数学",@"英语"]];
        [self.view addSubview:_headLineView];
    }
    
}

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
-(void)refreshHeadLine:(NSInteger)currentIndex
{
    _currentIndex=currentIndex;
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  5;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
 
    
        NSString *reuseID = @"InfoCell";
        LearningTasksCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if(nil == cell)
        {
            cell = [[LearningTasksCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
        }
//        [cell setInfoItem:_infoArray[row - 1]];
    
    
        return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 100;
 
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    NSInteger row = indexPath.row;
    PersonalInfoItem *item = nil;
    if(row > 0)
        item = _infoArray[row - 1];
    
    if(row == 0)
    {
        
    }
    else
    {
    

    }
}


@end
