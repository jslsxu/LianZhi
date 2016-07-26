//
//  HomeWorkDetailVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/11/28.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "HomeWorkDetailVC.h"
#import "HomeWorkHistoryModel.h"
#import "CollectionImageCell.h"
#import "NotificationTargetVC.h"
#import "SDWebImagePrefetcher.h"
@interface HomeWorkDetailVC ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong)HomeWorkItem *homeWorkItem;
@property (nonatomic, strong)NSArray* targetArray;
@end

@implementation HomeWorkDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"作业详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"转发" style:UIBarButtonItemStylePlain target:self action:@selector(onSendNextClicked)];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorColor:kSepLineColor];
    [self.view addSubview:_tableView];
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    
    [self requestData];
}

- (void)setupHeaderView
{
    UIView *viewParent = _headerView;
    [viewParent setBackgroundColor:[UIColor whiteColor]];
    
    NSInteger spaceYStart = 15;
    NSString *words = self.homeWorkItem.words;
    if(words.length > 0)
    {
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, spaceYStart, viewParent.width - 10 * 2, 0)];
        [contentLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [contentLabel setFont:[UIFont systemFontOfSize:12]];
        [contentLabel setNumberOfLines:0];
        [contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [contentLabel setText:words];
        [contentLabel sizeToFit];
        [viewParent addSubview:contentLabel];
        
        spaceYStart += contentLabel.height + 10;
    }
    
    if(self.homeWorkItem.audioItem)
    {
        _voiceButton = [[MessageVoiceButton alloc] initWithFrame:CGRectMake(20, spaceYStart, viewParent.width / 2, 35)];
        [_voiceButton addTarget:self action:@selector(onVoiceClicked) forControlEvents:UIControlEventTouchUpInside];
        [_voiceButton setAudioItem:self.homeWorkItem.audioItem];
        [viewParent addSubview:_voiceButton];
        
        [_voiceButton setVoiceWithURL:[NSURL URLWithString:self.homeWorkItem.audioItem.audioUrl] withAutoPlay:NO];
        
        UILabel *spanLabel = [[UILabel alloc] initWithFrame:CGRectMake(_voiceButton.right, _voiceButton.y, 60, _voiceButton.height)];
        [spanLabel setTextColor:[UIColor colorWithHexString:@"8f8f8f"]];
        [spanLabel setFont:[UIFont systemFontOfSize:10]];
        [spanLabel setText:[Utility formatStringForTime:self.homeWorkItem.audioItem.timeSpan]];
        [spanLabel sizeToFit];
        [spanLabel setOrigin:CGPointMake(_voiceButton.right + 10, spaceYStart + (_voiceButton.height - spanLabel.height) / 2)];
        [viewParent addSubview:spanLabel];
        
        spaceYStart += 35 + 10;
    }
    
    if(self.homeWorkItem.photoArray.count > 0)
    {
        NSInteger count = self.homeWorkItem.photoArray.count;
        NSInteger itemWidth = 80;
        NSInteger innerMargin = 5;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake(itemWidth, itemWidth)];
        [layout setMinimumInteritemSpacing:innerMargin];
        [layout setMinimumLineSpacing:innerMargin];
        
        NSInteger row = (count + 2) / 3;
        NSInteger width = row > 1 ? (itemWidth * 3 + innerMargin * 2) : (itemWidth * count + innerMargin * (count - 1));
        NSInteger height = itemWidth  * row + innerMargin * (row - 1);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake((viewParent.width - width) / 2, spaceYStart, width, height) collectionViewLayout:layout];
        [collectionView setBackgroundColor:[UIColor clearColor]];
        [collectionView setShowsHorizontalScrollIndicator:NO];
        [collectionView setShowsVerticalScrollIndicator:NO];
        [collectionView setScrollsToTop:NO];
        [collectionView setDelegate:self];
        [collectionView setDataSource:self];
        [collectionView registerClass:[CollectionImageCell class] forCellWithReuseIdentifier:@"CollectionImageCell"];
        [viewParent addSubview:collectionView];
        
        spaceYStart += height + 10;
    }
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, spaceYStart, viewParent.width, kLineHeight)];
    [sepLine setBackgroundColor:kSepLineColor];
    [viewParent addSubview:sepLine];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [timeLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
    [timeLabel setFont:[UIFont systemFontOfSize:10]];
    [timeLabel setText:self.homeWorkItem.timeStr];
    [timeLabel sizeToFit];
    [timeLabel setOrigin:CGPointMake(10, sepLine.bottom + (22 - timeLabel.height) / 2)];
    [viewParent addSubview:timeLabel];
    
    spaceYStart = sepLine.bottom + 22;
    
    NSInteger sendNum = 0;
    for (TargetClass *targetClass in self.targetArray)
    {
        sendNum += targetClass.publish;
    }
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [numLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
    [numLabel setFont:[UIFont systemFontOfSize:10]];
    [numLabel setText:[NSString stringWithFormat:@"已发送%ld人",(long)sendNum]];
    [numLabel sizeToFit];
    [numLabel setOrigin:CGPointMake(viewParent.width - 10 - numLabel.width, sepLine.bottom + (22 - numLabel.height) / 2)];
    [viewParent addSubview:numLabel];

    [viewParent setHeight:spaceYStart];
}

- (void)requestData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.homeworkID forKey:@"practice_id"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"practice/detail" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        TNDataWrapper *practiseWrapper = [responseObject getDataWrapperForKey:@"practice"];
        HomeWorkItem *homeWorkItem = [[HomeWorkItem alloc] init];
        [homeWorkItem parseData:practiseWrapper];
        self.homeWorkItem = homeWorkItem;
        
        TNDataWrapper *classWrapper = [responseObject getDataWrapperForKey:@"classes"];
        if(classWrapper.count > 0)
        {
            NSMutableArray *targetArray = [NSMutableArray array];
            for (NSInteger i = 0; i < classWrapper.count; i++)
            {
                TNDataWrapper *targetClassWrapper = [classWrapper getDataWrapperForIndex:i];
                TargetClass *targetClass = [[TargetClass alloc] init];
                [targetClass parseData:targetClassWrapper];
                [targetArray addObject:targetClass];
            }
            self.targetArray = targetArray;
        }
        [self setupHeaderView];
        [_tableView setTableHeaderView:_headerView];
        [_tableView reloadData];
    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)onVoiceClicked
{
    [_voiceButton setVoiceWithURL:[NSURL URLWithString:self.homeWorkItem.audioItem.audioUrl] withAutoPlay:YES];
}

- (void)onSendNextClicked
{
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:self.view];
    __weak typeof(self) wself = self;
    void (^finishBlk)() = ^{
        [hud hide:NO];
        if(self.homeWorkItem)
        {
            if(wself.completion)
                wself.completion(wself.homeWorkItem);
        }
    };
    if(self.homeWorkItem.photoArray.count > 0)
    {
        NSMutableArray *urlArray = [NSMutableArray array];
        for (PhotoItem *photoItem in self.homeWorkItem.photoArray)
        {
            if(photoItem.big)
                [urlArray addObject:photoItem.big];
        }
        [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:urlArray progress:nil completed:^(NSUInteger noOfFinishedUrls, NSUInteger noOfSkippedUrls) {
            NSMutableArray *imageArray = [NSMutableArray array];
            for (NSString *url in urlArray)
            {
                [imageArray addObject:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url]];
            }
            finishBlk();
        }];
    }
    else if(self.homeWorkItem.audioItem)
    {
        NSData * audioData = [[MLDataCache shareInstance] cachedDataForRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:wself.homeWorkItem.audioItem.audioUrl]]];
        if(audioData.length == 0)
        {
            [_voiceButton setVoiceWithURL:[NSURL URLWithString:self.homeWorkItem.audioItem.audioUrl] success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSURL *voicePath) {
                finishBlk();
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                [hud hide:NO];
                [ProgressHUD showHintText:@"语音下载失败"];
            }];
        }
        else
            finishBlk();
    }
    else
        finishBlk();

}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.targetArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
        [cell.textLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.detailTextLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]]];
    }
    TargetClass *targetClass = self.targetArray[indexPath.row];
    [cell.textLabel setText:targetClass.className];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld/%ld",targetClass.publish, targetClass.total]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TargetClass *targetClass = self.targetArray[indexPath.row];
    NotificationTargetVC *notificationTargetVC = [[NotificationTargetVC alloc] init];
    [notificationTargetVC setGroupID:targetClass.classID];
    [notificationTargetVC setSelectedArray:targetClass.students];
    [self.navigationController pushViewController:notificationTargetVC animated:YES];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.homeWorkItem.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionImageCell" forIndexPath:indexPath];
    [cell setItem:self.homeWorkItem.photoArray[indexPath.row]];
    return cell;
}

@end
