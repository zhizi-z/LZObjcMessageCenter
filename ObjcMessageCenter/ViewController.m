//
//  ViewController.m
//  ObjcMessageCenter
//
//  Created by zhizi on 2019/4/24.
//  Copyright © 2019 zlh. All rights reserved.
//

#import "ViewController.h"
#import "TestMOC_Messages.h"
#import "EMTXMessageObserverCenter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btnVC_A = [[UIButton alloc] initWithFrame:CGRectMake(0, 80, 120, 40)];
    [btnVC_A setTitle:@"消息中心" forState:UIControlStateNormal];
    [btnVC_A addTarget:self action:@selector(pushToVCA) forControlEvents:UIControlEventTouchUpInside];
    btnVC_A.backgroundColor = [UIColor redColor];
    [self.view addSubview:btnVC_A];
    
    UIButton *btnSend = [[UIButton alloc] initWithFrame:CGRectMake(130, 80, 240, 40)];
    [btnSend setTitle:@"给被释放的对象发送消息" forState:UIControlStateNormal];
    [btnSend addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    btnSend.backgroundColor = [UIColor redColor];
    [self.view addSubview:btnSend];
    
    UIButton *btnVC_RouterA = [[UIButton alloc] initWithFrame:CGRectMake(0, 140, 120, 40)];
    [btnVC_RouterA setTitle:@"包路由" forState:UIControlStateNormal];
    [btnVC_RouterA addTarget:self action:@selector(pushToRouterVCA) forControlEvents:UIControlEventTouchUpInside];
    btnVC_RouterA.backgroundColor = [UIColor redColor];
    [self.view addSubview:btnVC_RouterA];
    
    UIButton *btnVC_BulletinA = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, 120, 40)];
    [btnVC_BulletinA setTitle:@"公告板" forState:UIControlStateNormal];
    [btnVC_BulletinA addTarget:self action:@selector(pushToBulletionVCA) forControlEvents:UIControlEventTouchUpInside];
    btnVC_BulletinA.backgroundColor = [UIColor redColor];
    [self.view addSubview:btnVC_BulletinA];
}

- (void)pushToVCA
{
    TestMOC_VC_A *vca = [TestMOC_VC_A new];
    [self.navigationController pushViewController:vca animated:YES];
}

- (void)sendMessage
{
    NSDictionary *userInfo = @{@"text" : @"dealloc test"};
    //8.x系统不会崩溃
    [[EMTXMessageObserverCenter defaultCenter] postMessageName:UPDATE_LABEL_TEXT_MSG userInfo:userInfo object:nil];
    //8.x系统下观察者销毁时不从通知中心移除会崩溃
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_LABEL_TEXT_MSG object:nil];
}

- (void)pushToRouterVCA
{
    TestRouter_VC_A *vca = [TestRouter_VC_A new];
    [self.navigationController pushViewController:vca animated:YES];
}

- (void)pushToBulletionVCA
{
    TestBulletin_VC_A *vc = [TestBulletin_VC_A new];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
