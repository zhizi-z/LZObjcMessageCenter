//
//  TestMOC_ViewB.m
//  ObjcMessageCenter
//
//  Created by zhizi on 2019/4/24.
//  Copyright © 2019 zlh. All rights reserved.
//

#import "TestMOC_ViewB.h"
#import "TestMOC_Messages.h"
#import "EMTXMessageObserverCenter.h"

@interface TestMOC_ViewB()

@property (nonatomic, strong) UILabel *lblText;
@end

@implementation TestMOC_ViewB

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
        //添加消息方法
        [self addMessageSelector];
        //添加消息块
//        [self addMessageBlock];
    }
    return self;
}

- (void)addMessageSelector
{
    //添加修改文本的消息观察者
    [[EMTXMessageObserverCenter defaultCenter] addObserver:self selector:@selector(updateLabelText:) name:UPDATE_LABEL_TEXT_MSG];
    [[EMTXMessageObserverCenter defaultCenter] addObserver:self selector:@selector(updateLabelText:) name:UPDATE_LABEL_TEXT_MSG];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabelText:) name:UPDATE_LABEL_TEXT_MSG object:nil];
    //添加修改字体的消息观察者
//    [[EMTXMessageObserverCenter defaultCenter] addObserver:self selector:@selector(updateLabelFont:) name:UPDATE_LABEL_FONT_MSG];
}

- (void)addMessageBlock
{
    __weak typeof(self) weakSelf = self;
    void(^block)(EMTXMessage *) = ^(EMTXMessage *message){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf updateLabelText:message];
    };
    //添加修改文本的消息块
//    [[EMTXMessageObserverCenter defaultCenter] addObserver:self execution:^(EMTXMessage * _Nonnull message) {
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        [strongSelf updateLabelText:message];
//    } name:UPDATE_LABEL_TEXT_MSG];
    [[EMTXMessageObserverCenter defaultCenter] addObserver:self execution:block name:UPDATE_LABEL_TEXT_MSG];
    //添加修改字体的消块
    [[EMTXMessageObserverCenter defaultCenter] addObserver:self execution:^(EMTXMessage * _Nonnull message) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf updateLabelFont:message];
    } name:UPDATE_LABEL_FONT_MSG];
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateLabelText
{
    self.lblText.text = @"没有参数的方法被调用了";
}

- (void)updateLabelText:(EMTXMessage *)message
{
    NSDictionary *userInfo = message.userInfo;
    id object1 = message.object;
    id object2 = userInfo[@"object"];
    self.lblText.text = [NSString stringWithFormat:@"欢迎 %@", userInfo[@"text"]];
}

- (void)updateLabelFont:(EMTXMessage *)message
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
    [[EMTXMessageObserverCenter defaultCenter] removeObserver:self];
}

- (void)removeTextMessage
{
    [[EMTXMessageObserverCenter defaultCenter] removeObserver:self name:UPDATE_LABEL_TEXT_MSG];
}
@end
