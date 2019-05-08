//
//  TestMOC_VC_A.m
//  ObjcMessageCenter
//
//  Created by zhizi on 2019/4/24.
//  Copyright © 2019 zlh. All rights reserved.
//

#import "TestMOC_VC_A.h"
#import "TestMOC_VIewA.h"
#import "TestMOC_ViewB.h"
#import "TestMOC_Messages.h"
#import "EMTXMessageObserverCenter.h"

@interface TestMOC_VC_A ()

@property (nonatomic, strong) EMTXMessageObserverCenter *smallCenter;

@end

@implementation TestMOC_VC_A

- (void)viewDidLoad {
    [super viewDidLoad];
    self.smallCenter = [EMTXMessageObserverCenter smallCenter];
    
    self.view.backgroundColor = [UIColor whiteColor];
    TestMOC_VIewA *viewA = [[TestMOC_VIewA alloc] initWithFrame:CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, 70)];
    TestMOC_ViewB *viewB = [[TestMOC_ViewB alloc] initWithFrame:CGRectMake(0, 170, [UIScreen mainScreen].bounds.size.width, 120)];
    UIButton *btnText = [[UIButton alloc] initWithFrame:CGRectMake(0, 310, [UIScreen mainScreen].bounds.size.width, 40)];
    [btnText setTitle:@"发送文本" forState:UIControlStateNormal];
    [btnText addTarget:self action:@selector(didClickTextButton:) forControlEvents:UIControlEventTouchUpInside];
    viewA.backgroundColor = [UIColor greenColor];
    viewB.backgroundColor = [UIColor greenColor];
    btnText.backgroundColor = [UIColor greenColor];
    [self.view addSubview:viewA];
    [self.view addSubview:viewB];
    [self.view addSubview:btnText];
    
    viewA.smallCenter = self.smallCenter;
    
    //添加修改文本的消息观察者
    [self.smallCenter addObserver:self selector:@selector(updateTitleText:) name:UPDATE_LABEL_TEXT_MSG];
//    __weak typeof(self) weakSelf = self;
//    //添加修改文本的消息块
//    [self.smallCenter addObserver:self execution:^(EMTXMessage * _Nonnull message) {
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        [strongSelf updateTitleText:message];
//    } name:UPDATE_LABEL_TEXT_MSG];
}

- (void)updateTitleText:(EMTXMessage *)message
{
    NSDictionary *userInfo = message.userInfo;
    self.title = userInfo[@"text"];
}

- (void)dealloc
{
    NSLog(@"dealloc TestMOC_VC_A");
}

- (void)didClickTextButton:(UIButton *)button
{
    NSDictionary *userInfo = @{@"text" : @"来自vc的文本", @"object" : self};
    [self.smallCenter postMessageName:UPDATE_LABEL_TEXT_MSG userInfo:userInfo object:self];
}
@end
