//
//  TestRouter_ViewC.m
//  ObjcMessageCenter
//
//  Created by zhizi on 2019/4/29.
//  Copyright © 2019 zlh. All rights reserved.
//

#import "TestRouter_ViewC.h"
#import "TestRouter_Pack.h"
#import "NSObject+EMTXRouter.h"

@interface TestRouter_ViewC()

@property (nonatomic, strong) UILabel *lblText;
@end

@implementation TestRouter_ViewC

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 15)];
        lblTitle.font = [UIFont systemFontOfSize:15.0];
        lblTitle.text = @"ViewC";
        [self addSubview:lblTitle];
        
        UILabel *lblText = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 260, 40)];
        lblText.backgroundColor = [UIColor whiteColor];
        [self addSubview:lblText];
        _lblText = lblText;
        
        UIButton *btnRemoveAll = [[UIButton alloc] initWithFrame:CGRectMake(10, 70, 120, 40)];
        [btnRemoveAll setTitle:@"移除所有通知" forState:UIControlStateNormal];
        btnRemoveAll.backgroundColor = [UIColor lightGrayColor];
        [btnRemoveAll addTarget:self action:@selector(removeAllMessage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnRemoveAll];
        
        UIButton *btnRemoveText = [[UIButton alloc] initWithFrame:CGRectMake(150, 70, 120, 40)];
        [btnRemoveText setTitle:@"移除文本通知" forState:UIControlStateNormal];
        btnRemoveText.backgroundColor = [UIColor lightGrayColor];
        [btnRemoveText addTarget:self action:@selector(removeTextMessage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnRemoveText];
         
         [self setPostFlag:@(1) forPack:UPDATE_LABEL_TEXT_PACK];
        __weak typeof(self) weakSelf = self;
        [self subscribePackName:UPDATE_LABEL_TEXT_PACK execution:^(EMTXRouterPack * _Nonnull pack) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.lblText.text = pack.userInfo[@"text"];
            
            pack.userInfo = @{@"text":@"成功返回"};
        }];
    }
    return self;
}

@end
