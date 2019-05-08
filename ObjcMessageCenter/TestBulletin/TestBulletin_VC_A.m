//
//  TestBulletin_VC_A.m
//  ObjcMessageCenter
//
//  Created by zhizi on 2019/5/7.
//  Copyright © 2019 zlh. All rights reserved.
//

#import "TestBulletin_VC_A.h"
#import "TestBulletin_ViewA.h"
#import "TestBulletin_ViewB.h"
#import "TestBulletin_bulletin.h"
#import "NSObject+EMTXBulletin.h"

@interface TestBulletin_VC_A ()

@end

@implementation TestBulletin_VC_A

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    TestBulletin_ViewA *viewA = [[TestBulletin_ViewA alloc] initWithFrame:CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, 170)];
    TestBulletin_ViewB *viewB = [[TestBulletin_ViewB alloc] initWithFrame:CGRectMake(0, 270, [UIScreen mainScreen].bounds.size.width, 120)];
    UIButton *btnText = [[UIButton alloc] initWithFrame:CGRectMake(0, 410, [UIScreen mainScreen].bounds.size.width, 40)];
    [btnText setTitle:@"查看文本公告" forState:UIControlStateNormal];
    [btnText addTarget:self action:@selector(readText) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btnSendText = [[UIButton alloc] initWithFrame:CGRectMake(0, 470, [UIScreen mainScreen].bounds.size.width, 40)];
    [btnSendText setTitle:@"发布修改文本公告" forState:UIControlStateNormal];
    [btnSendText addTarget:self action:@selector(sendText) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btnRemoveAll = [[UIButton alloc] initWithFrame:CGRectMake(0, 530, [UIScreen mainScreen].bounds.size.width, 40)];
    [btnRemoveAll setTitle:@"擦除所有公告" forState:UIControlStateNormal];
    [btnRemoveAll addTarget:self action:@selector(removeAll) forControlEvents:UIControlEventTouchUpInside];
    viewA.backgroundColor = [UIColor greenColor];
    viewB.backgroundColor = [UIColor greenColor];
    btnText.backgroundColor = [UIColor greenColor];
    btnSendText.backgroundColor = [UIColor greenColor];
    btnRemoveAll.backgroundColor = [UIColor greenColor];
    [self.view addSubview:viewA];
    [self.view addSubview:viewB];
    [self.view addSubview:btnText];
    [self.view addSubview:btnSendText];
    [self.view addSubview:btnRemoveAll];
}

- (void)dealloc
{
//    [[EMTXBulletinBoard defaultBoard] erase];
    NSLog(@"dealloc");
}

- (void)readText
{
    [self readBulletinName:UPDATE_LABEL_TEXT_BULLETIN selector:@selector(didReadText:)];
}

- (void)didReadText:(EMTXBulletin *)bulletin
{
    NSString *name = bulletin.name;
    NSDictionary *usrInfo = bulletin.userInfo;
    id object = bulletin.object;
    self.title = name;
    NSLog(@"readText");
}

- (void)sendText
{
    NSDictionary *userInfo = @{@"text" : @"VC_A"};
    [self writeBulletin:UPDATE_LABEL_TEXT_BULLETIN userInfo:userInfo object:self];
}

- (void)removeAll
{
    [[EMTXBulletinBoard defaultBoard] erase];
}
@end
