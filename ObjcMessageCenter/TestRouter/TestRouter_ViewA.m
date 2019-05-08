//
//  TestRouter_ViewA.m
//  ObjcMessageCenter
//
//  Created by zhizi on 2019/4/29.
//  Copyright © 2019 zlh. All rights reserved.
//

#import "TestRouter_ViewA.h"
#import "TestRouter_Pack.h"
#import "NSObject+EMTXRouter.h"

@interface TestRouter_ViewA()

@property (nonatomic, strong) UITextField *txtField;
@end

@implementation TestRouter_ViewA

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 15)];
        lblTitle.font = [UIFont systemFontOfSize:15.0];
        lblTitle.text = @"ViewA";
        [self addSubview:lblTitle];
        
        UITextField *txtField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, 180, 40)];
        txtField.placeholder = @"请输入文本";
        txtField.backgroundColor = [UIColor whiteColor];
        [self addSubview:txtField];
        _txtField = txtField;
        
        UIButton *btnSendText = [[UIButton alloc] initWithFrame:CGRectMake(200, 20, 80, 40)];
        [btnSendText setTitle:@"发送文本" forState:UIControlStateNormal];
        btnSendText.backgroundColor = [UIColor lightGrayColor];
        [btnSendText addTarget:self action:@selector(didClickTextButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnSendText];
        
        UIButton *btnSendFont = [[UIButton alloc] initWithFrame:CGRectMake(290, 20, 80, 40)];
        [btnSendFont setTitle:@"修改字体" forState:UIControlStateNormal];
        btnSendFont.backgroundColor = [UIColor lightGrayColor];
        [btnSendFont addTarget:self action:@selector(didClickFontButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnSendFont];
        
        __weak typeof(self) weakSelf = self;
        [self setPostFlag:@(2) forPack:UPDATE_LABEL_TEXT_PACK];//不管订阅返回还是向上消息,postFlag必须设为非0和非1,否则不会向上发送
        [self subscribePackName:UPDATE_LABEL_TEXT_PACK execution:^(EMTXRouterPack * _Nonnull pack) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!pack.isOutGoing)
            {
                strongSelf.txtField.text = pack.userInfo[@"text"];
            }
        }];
    }
    return self;    
}

- (void)didClickTextButton:(UIButton *)button
{
    NSDictionary *userInfo = @{@"text" : self.txtField.text};
    __weak typeof(self) weakSelf = self;
    EMTXRouterPack *pack = [EMTXRouterPack packWithName:UPDATE_LABEL_TEXT_PACK source:self callBack:^(EMTXRouterPack * _Nonnull pack) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.txtField.text = pack.userInfo[@"text"];
    } userInfo:userInfo];
    [self postPack:pack];
}

- (void)didClickFontButton:(UIButton *)button
{
    EMTXRouterPack *pack = [EMTXRouterPack packWithName:UPDATE_LABEL_FONT_PACK source:self callBack:nil userInfo:nil];
    [self postPack:pack];
}
@end
