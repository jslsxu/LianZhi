//
//  MyGiftVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/11/24.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "MyGiftVC.h"

@implementation GiftItem

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    
}

@end

@implementation GiftModel
- (BOOL)hasMoreData
{
    return NO;
}
- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    return YES;
}

@end

@implementation GiftCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
    }
    return self;
}

@end

@implementation MyGiftVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.cellName = @"GiftCell";
        self.modelName = @"GiftModel";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"礼物";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    
    [self requestData:REQUEST_REFRESH];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    return task;
}

- (void)onCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath
{
    
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

@end
