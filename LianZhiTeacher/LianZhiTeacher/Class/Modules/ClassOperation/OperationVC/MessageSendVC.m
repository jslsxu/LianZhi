//
//  MessageSendVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "MessageSendVC.h"
#import "NotificationTargetSelectVC.h"
@interface MessageSendVC ()

@end

@implementation MessageSendVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:(@"WhiteLeftArrow")] style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(onNext)];
    
    self.words = [NSString stringWithFormat:@"%@教师:",[UserCenter sharedInstance].userData.userInfo.name];
}


- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)validate
{
    return YES;
}

- (NSDictionary *)params
{
    return nil;
}

- (NSArray *)imageArray
{
    return nil;
}

- (NSData *)audioData
{
    return nil;
}

- (void)onNext
{
    if([self validate])
    {
        NotificationTargetSelectVC *targetSelectVC = [[NotificationTargetSelectVC alloc] init];
        [targetSelectVC setImageArray:[self imageArray]];
        [targetSelectVC setAudioData:[self audioData]];
        [targetSelectVC setParams:[self params]];
        [self.navigationController pushViewController:targetSelectVC animated:YES];
    }
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
