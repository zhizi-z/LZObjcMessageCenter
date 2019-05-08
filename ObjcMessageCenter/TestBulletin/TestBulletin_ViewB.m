//
//  TestBulletin_ViewB.m
//  ObjcMessageCenter
//
//  Created by zhizi on 2019/5/7.
//  Copyright © 2019 zlh. All rights reserved.
//

#import "TestBulletin_ViewB.h"
#import "NSObject+EMTXBulletin.h"
#import "TestBulletin_bulletin.h"

@interface TestBulletin_ViewB()

@property (nonatomic, strong) UILabel *lblText;
@end

@implementation TestBulletin_ViewB

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
        
        UIButton *btnReadText = [[UIButton alloc] initWithFrame:CGRectMake(10, 70, 160, 40)];
        [btnReadText setTitle:@"查看修改文本公告" forState:UIControlStateNormal];
        btnReadText.backgroundColor = [UIColor lightGrayColor];
        [btnReadText addTarget:self action:@selector(readText) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnReadText];
        
        UIButton *btnReadFont = [[UIButton alloc] initWithFrame:CGRectMake(180, 70, 160, 40)];
        [btnReadFont setTitle:@"查看修改字体公告" forState:UIControlStateNormal];
        btnReadFont.backgroundColor = [UIColor lightGrayColor];
        [btnReadFont addTarget:self action:@selector(readFont) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnReadFont];
    }
    return self;
}

- (void)readText
{
    __weak typeof(self) weakSelf = self;
    [self readBulletinName:UPDATE_LABEL_TEXT_BULLETIN execution:^(EMTXBulletin * _Nonnull bulletin) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSString *name = bulletin.name;
        NSDictionary *usrInfo = bulletin.userInfo;
        id object = bulletin.object;
        strongSelf.lblText.text = name;
        NSLog(@"readText");
    }];
    [self readBulletinName:UPDATE_LABEL_TEXT_BULLETIN selector:@selector(didReadText:)];
}

- (void)readFont
{
//    __weak typeof(self) weakSelf = self;
//    [self readBulletinName:UPDATE_LABEL_FONT_BULLETIN execution:^(EMTXBulletin * _Nonnull bulletin) {
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        NSString *name = bulletin.name;
//        NSDictionary *usrInfo = bulletin.userInfo;
//        id object = bulletin.object;
//        [strongSelf updateLabelFont:bulletin];
//        NSLog(@"readFont");
//    }];
    [self readBulletinName:UPDATE_LABEL_FONT_BULLETIN selector:@selector(didReadFont:)];
}

- (void)didReadText:(EMTXBulletin *)bulletin
{
    NSString *name = bulletin.name;
    NSDictionary *usrInfo = bulletin.userInfo;
    id object = bulletin.object;
    self.lblText.text = name;
    NSLog(@"readText");
}

- (void)didReadFont:(EMTXBulletin *)bulletin
{
    NSString *name = bulletin.name;
    NSDictionary *usrInfo = bulletin.userInfo;
    id object = bulletin.object;
    [self updateLabelFont:bulletin];
    NSLog(@"readFont");
}

- (void)updateLabelFont:(EMTXBulletin *)message
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
@end
