//
//  ClassAppVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ClassAppVC.h"
#import "GrowthTimelineVC.h"
#import "ContactVC.h"

@interface ClassAppVC ()

@end

@implementation ClassAppVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [self setCellName:@"ClassAppCell"];
        [self setModelName:@"ClassAppModel"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"班应用";
    [self.collectionView setScrollEnabled:NO];
    [self requestData:REQUEST_REFRESH];
}

- (void)setupSubviews
{
    UIImageView *grayBG = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:(@"GrayBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    [grayBG setFrame:CGRectMake(12, 15, self.view.width - 12 * 2, self.view.height - 15 * 2)];
    [self.view insertSubview:grayBG belowSubview:self.collectionView];
    
    UIImageView *whiteBG = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:(@"WhiteBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    [whiteBG setFrame:CGRectMake(12, 15, grayBG.width - 12 * 2, grayBG.height - 15 * 2)];
    [grayBG addSubview:whiteBG];
}

- (void)TNBaseCollectionViewControllerModifyLayout:(UICollectionViewLayout *)layout
{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)layout;
    [flowLayout setItemSize:CGSizeMake(60, 60)];
    [flowLayout setMinimumInteritemSpacing:20];
    [flowLayout setMinimumLineSpacing:15];
    [flowLayout setSectionInset:UIEdgeInsetsMake(50, 50, 50, 50)];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"class/app_list"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.classID forKey:@"class_id"];
    [task setParams:params];
    [task setObserver:self];
    return task;
}

- (BOOL)supportCache
{
    return YES;
}

- (NSString *)cacheFileName
{
    return [NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),self.classID];
}


- (void)TNBaseTableViewControllerRequestStart
{
    [self startLoading];
}

- (void)TNBaseTableViewControllerRequestSuccess
{
    [self endLoading];
}

- (void)TNBaseTableViewControllerRequestFailedWithError:(NSString *)errMsg
{
    [self endLoading];
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath
{
    ClassAppItem *appItem = (ClassAppItem *)modelItem;
    NSString *actionUrl = appItem.actionUrl;
    if([actionUrl length] > 0)
    {
        NSURL *hyperLink = [NSURL URLWithString:actionUrl];
        if(hyperLink)
        {
            NSString *scheme = hyperLink.scheme;
            NSString *host = hyperLink.host;
            if([scheme isEqualToString:@"http"])
            {
                TNBaseWebViewController *webVC = [[TNBaseWebViewController alloc] initWithUrl:[NSURL URLWithString:actionUrl]];
                [webVC setTitle:appItem.appName];
                [self.navigationController pushViewController:webVC animated:YES];
            }
            else if([scheme isEqualToString:@"lianzhi"])
            {
                if([host isEqualToString:@"contact"])
                {
                    ContactVC *contactVC = [[ContactVC alloc] init];
                    [self.navigationController pushViewController:contactVC animated:YES];
                }
                else if([host isEqualToString:@"record"])
                {
                    GrowthTimelineVC *recordVC = [[GrowthTimelineVC alloc] init];
                    [recordVC setClassID:self.classID];
                    [self.navigationController pushViewController:recordVC animated:YES];
                }
            }
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
