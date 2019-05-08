//
//  TestRouter_ViewB.m
//  ObjcMessageCenter
//
//  Created by zhizi on 2019/4/29.
//  Copyright © 2019 zlh. All rights reserved.
//

#import "TestRouter_ViewB.h"
#import "TestRouter_Pack.h"
#import "NSObject+EMTXRouter.h"

@interface TestRouter_ViewB()

@property (nonatomic, strong) UILabel *lblText;
@end

@implementation TestRouter_ViewB

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 15)];
        lblTitle.font = [UIFont systemFontOfSize:15.0];
        lblTitle.text = @"ViewB";
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
        
        __weak typeof(self) weakSelf = self;
        [self subscribePackName:UPDATE_LABEL_TEXT_PACK execution:^(EMTXRouterPack * _Nonnull pack) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf updateLabelText:pack];
        }];
//        [self setPostFlag:@(2) forPack:UPDATE_LABEL_TEXT_PACK];
        [self subscribePackName:UPDATE_LABEL_TEXT_PACK selector:@selector(updateLabelText:)];
        [self subscribePackName:UPDATE_LABEL_FONT_PACK selector:@selector(updateLabelFont:)];
    }
    return self;
}

- (void)updateLabelText:(EMTXRouterPack *)pack
{
    if (pack.isOutGoing)
    {
        NSDictionary *userInfo = pack.userInfo;
        self.lblText.text = [NSString stringWithFormat:@"欢迎 %@", userInfo[@"text"]];
        if (pack.callBack)
        {
            pack.userInfo = @{@"text" : @"从ViewB成功返回"};
            pack.callBack(pack);
        }        
    }    
}

- (void)updateLabelFont:(EMTXRouterPack *)pack
{
    if (self.lblText.font.pointSize < 30)
    {
        self.lblText.font = [UIFont systemFontOfSize:self.lblText.font.pointSize + 5];
    }
    else if (self.lblText.font.pointSize > 15)
    {
        self.lblText.font = [UIFont systemFontOfSize:self.lblText.font.pointSize - 5];
    }
}

- (void)removeAllMessage
{
    [self unSubscribePacks];
}

- (void)removeTextMessage
{
    [self unSubscribePack:UPDATE_LABEL_TEXT_PACK];
}
@end
