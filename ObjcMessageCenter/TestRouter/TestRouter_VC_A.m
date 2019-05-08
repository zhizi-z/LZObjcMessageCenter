//
//  TestRouter_VC_A.m
//  ObjcMessageCenter
//
//  Created by zhizi on 2019/4/29.
//  Copyright © 2019 zlh. All rights reserved.
//

#import "TestRouter_VC_A.h"
#import "TestRouter_Pack.h"
#import "NSObject+EMTXRouter.h"
#import "TestRouter_ViewA.h"
#import "TestRouter_ViewB.h"
#import "TestRouter_ViewC.h"

@interface TestRouter_VC_A ()
@property (strong, nonatomic) TestRouter_ViewA *viewA;
@end

@implementation TestRouter_VC_A

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    TestRouter_ViewA *viewA = [[TestRouter_ViewA alloc] initWithFrame:CGRectMake(0, 125, [UIScreen mainScreen].bounds.size.width, 70)];
    TestRouter_ViewB *viewB = [[TestRouter_ViewB alloc] initWithFrame:CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, 200)];
    TestRouter_ViewC *viewC = [[TestRouter_ViewC alloc] initWithFrame:CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width, 120)];
    viewA.backgroundColor = [UIColor yellowColor];
    viewB.backgroundColor = [UIColor greenColor];
    viewC.backgroundColor = [UIColor greenColor];
    [self.view addSubview:viewB];
    [self.view addSubview:viewC];
    [viewB addSubview:viewA];
//    __weak typeof(self) weakSelf = self;
    
    self.viewA = viewA;
//    [viewA addNextNode:viewC];
//    viewA.nextNode = self;
//    __weak typeof(self) weakSelf = self;
//    [self subscribePackName:UPDATE_LABEL_TEXT_PACK execution:^(EMTXRouterPack * _Nonnull pack) {
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        strongSelf.title = pack.userInfo[@"text"];
//    }];
//    self.dicPostFlag[UPDATE_LABEL_TEXT_PACK] = @(1);
    [self setPostFlag:@(1) forPack:UPDATE_LABEL_TEXT_PACK];
    [self subscribePackName:UPDATE_LABEL_TEXT_PACK selector:@selector(updateTitle:)];
    [self subscribePackName:UPDATE_LABEL_FONT_PACK selector:@selector(updateLabelFont:)];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.viewA removeNextNode];
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

- (void)updateTitle
{
    self.title = @"成功接受";
}

- (void)updateTitle:(EMTXRouterPack *)pack
{
    self.title = pack.userInfo[@"text"];
//    if (pack.callBack)
    {
        pack.userInfo = @{@"text":@"成功返回"};
//        pack.callBack(pack);
    }
}

- (void)updateLabelFont:(EMTXRouterPack *)pack
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30]}];
}
@end
