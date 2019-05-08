//
//  TestMOC_VIewA.m
//  ObjcMessageCenter
//
//  Created by zhizi on 2019/4/24.
//  Copyright © 2019 zlh. All rights reserved.
//

#import "TestMOC_VIewA.h"
#import "TestMOC_Messages.h"
#import "EMTXMessageObserverCenter.h"

@interface TestMOC_VIewA()

@property (nonatomic, strong) UITextField *txtField;
@end

@implementation TestMOC_VIewA

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
    }
    return self;
}

- (void)didClickTextButton:(UIButton *)button
{
    NSDictionary *userInfo = @{@"text" : self.txtField.text, @"object" : self};
    [[EMTXMessageObserverCenter defaultCenter] postMessageName:UPDATE_LABEL_TEXT_MSG userInfo:userInfo object:self];
}

- (void)didClickFontButton:(UIButton *)button
{
    [[EMTXMessageObserverCenter defaultCenter] postMessageName:UPDATE_LABEL_FONT_MSG userInfo:nil object:nil];
}
@end
