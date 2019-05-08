//
//  TestBulletin_ViewA.m
//  ObjcMessageCenter
//
//  Created by zhizi on 2019/5/7.
//  Copyright © 2019 zlh. All rights reserved.
//

#import "TestBulletin_ViewA.h"
#import "NSObject+EMTXBulletin.h"
#import "TestBulletin_bulletin.h"

@interface TestBulletin_ViewA()

@property (nonatomic, strong) UITextField *txtField;
@end

@implementation TestBulletin_ViewA

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
        
        UIButton *btnSendText = [[UIButton alloc] initWithFrame:CGRectMake(10, 70, 160, 40)];
        [btnSendText setTitle:@"发布修改文本公告" forState:UIControlStateNormal];
        btnSendText.backgroundColor = [UIColor lightGrayColor];
        [btnSendText addTarget:self action:@selector(didClickTextButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnSendText];
        
        UIButton *btnSendFont = [[UIButton alloc] initWithFrame:CGRectMake(180, 70, 160, 40)];
        [btnSendFont setTitle:@"发布修改字体公告" forState:UIControlStateNormal];
        btnSendFont.backgroundColor = [UIColor lightGrayColor];
        [btnSendFont addTarget:self action:@selector(didClickFontButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnSendFont];
        
        UIButton *btnRemoveText = [[UIButton alloc] initWithFrame:CGRectMake(10, 120, 160, 40)];
        [btnRemoveText setTitle:@"移除修改文本公告" forState:UIControlStateNormal];
        btnRemoveText.backgroundColor = [UIColor lightGrayColor];
        [btnRemoveText addTarget:self action:@selector(removeText) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnRemoveText];
        
        UIButton *btnRemoveFont = [[UIButton alloc] initWithFrame:CGRectMake(180, 120, 160, 40)];
        [btnRemoveFont setTitle:@"移除修改字体公告" forState:UIControlStateNormal];
        btnRemoveFont.backgroundColor = [UIColor lightGrayColor];
        [btnRemoveFont addTarget:self action:@selector(removeFont) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnRemoveFont];
    }
    return self;
}

- (void)didClickTextButton:(UIButton *)button
{
    NSDictionary *userInfo = @{@"text" : self.txtField.text};
    [self writeBulletin:UPDATE_LABEL_TEXT_BULLETIN userInfo:userInfo object:self];
}

- (void)didClickFontButton:(UIButton *)button
{
    [self writeBulletin:UPDATE_LABEL_FONT_BULLETIN userInfo:nil object:self];
}

- (void)removeText
{
    [self eraseBulletin:UPDATE_LABEL_TEXT_BULLETIN object:nil];
}

- (void)removeFont
{
    [self eraseBulletin:UPDATE_LABEL_FONT_BULLETIN object:nil];
}

@end
