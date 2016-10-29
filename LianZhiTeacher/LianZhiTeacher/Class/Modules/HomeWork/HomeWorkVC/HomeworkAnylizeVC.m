//
//  HomeworkAnylizeVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkAnylizeVC.h"

@implementation HomeworkSituation

@end

@interface HomeworkAnylizeVC ()
@property (nonatomic, strong)HomeworkSituation *situation;
@end

@implementation HomeworkAnylizeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学情分析";
    [self loadAnylization];
}

- (void)setSituation:(HomeworkSituation *)situation{
    _situation = situation;
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setFont:[UIFont systemFontOfSize:15]];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
    [titleLabel setText:[NSString stringWithFormat:@"累计作业数:%zd道", self.situation.total]];
    [titleLabel sizeToFit];
    [titleLabel setOrigin:CGPointMake(10, 20)];
    [self.view addSubview:titleLabel];
    
    NSArray* nameArray = @[@"学生完成率:", @"作业批改率:", @"答题正确率:", @"作业解析率:"];
    CGFloat spaceYStart = titleLabel.bottom + 10;
    for (NSInteger i = 0; i < 4; i++) {
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(10, spaceYStart, self.view.width - 10 * 2, 30)];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [nameLabel setFont:[UIFont systemFontOfSize:15]];
        [nameLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [nameLabel setText:nameArray[i]];
        [nameLabel sizeToFit];
        [nameLabel setOrigin:CGPointMake(0, (itemView.height - nameLabel.height) / 2)];
        [itemView addSubview:nameLabel];
        
        NSInteger progress = 0;
        if(i == 0){
            progress = self.situation.finished;
        }
        else if(i == 1){
            progress = self.situation.marking;
        }
        else if(i == 2){
            progress = self.situation.correct;
        }
        else{
            progress = self.situation.answer;
        }
        UILabel*  rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemView.width - 50, 0, 50, itemView.height)];
        [rateLabel setFont:[UIFont systemFontOfSize:15]];
        [rateLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [rateLabel setTextAlignment:NSTextAlignmentRight];
        [rateLabel setText:[NSString stringWithFormat:@"%zd%%", progress]];
        [itemView addSubview:rateLabel];
        
        UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(nameLabel.right + 10, (itemView.height - 6) / 2, rateLabel.left - 5 - (nameLabel.right + 10), 6)];
        [bgView setBackgroundColor:[UIColor colorWithHexString:@"dde352"]];
        [itemView addSubview:bgView];
        
        UIView* rateView = [[UIView alloc] initWithFrame:CGRectMake(nameLabel.right + 10, (itemView.height - 6) / 2, bgView.width * progress / 100, 6)];
        [rateView setBackgroundColor:[UIColor colorWithHexString:@"7ab0f7"]];
        [itemView addSubview:rateView];
        
        [self.view addSubview:itemView];
        spaceYStart = itemView.bottom;
    }
}

- (void)loadAnylization{
    __weak typeof(self) wself = self;
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/situation" method:REQUEST_GET type:REQUEST_REFRESH withParams:nil observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        wself.situation = [HomeworkSituation nh_modelWithJson:responseObject.data];
        
    } fail:^(NSString *errMsg) {
        
    }];
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
