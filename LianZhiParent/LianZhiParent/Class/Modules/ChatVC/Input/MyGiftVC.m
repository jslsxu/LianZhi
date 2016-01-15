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
    if(type == REQUEST_REFRESH)
        [self.modelItemArray removeAllObjects];
    for (NSInteger i = 0; i < 10; i++)
    {
        GiftItem *item = [[GiftItem alloc] init];
        [self.modelItemArray addObject:item];
    }
    return YES;
}

@end

@implementation GiftCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self.layer setBorderWidth:0.5];
        [self.layer setCornerRadius:10];
        [self.layer setBorderColor:[UIColor colorWithHexString:@"d8d8d8"].CGColor];
        [self.layer setMasksToBounds:YES];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width)];
        [self addSubview:_imageView];
        
        
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    GiftItem *giftItem = (GiftItem *)modelItem;
    
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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"礼物";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    self.supportPullDown = YES;
    self.supportPullUp = YES;
    [self requestData:REQUEST_REFRESH];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"class/app_list_all"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    [task setObserver:self];
    return task;
}

- (void)TNBaseCollectionViewControllerModifyLayout:(UICollectionViewLayout *)layout
{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)layout;
    [flowLayout setSectionInset:UIEdgeInsetsMake(15, 15, 15, 15)];
    NSInteger itemSize = (self.view.width - 15 * 2 - 10 * 2) / 3;
    [flowLayout setItemSize:CGSizeMake(itemSize, itemSize)];
    [flowLayout setMinimumLineSpacing:10];
    
}

- (void)onCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if(self.completion)
        self.completion(nil);
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
