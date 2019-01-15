# UBInput

1.属性加初始化
@property (nonatomic,strong) DDInput *input;

- (DDInput *)input {
if (!_input) {
_input = [[DDInput alloc]initWithRootView:self.dataView];
}
return _input;
}

2.设置input的view（DDInputContainer 协议）
DDWatchLiveInputContainer *container = [[DDWatchLiveInputContainer alloc]init];
[self.input setContainer:container];
self.input.minToolbarBottomDistance = iPhoneX ? 25 : 5;

3.设置遮罩
//遮罩的背景View（全屏）
UIView *bgView = [[UIView alloc]initWithFrame:CGRectZero];
bgView.backgroundColor = UIColorHexA(0x000000, 0.5);

[self.input setBackgroundView:bgView];



4.回调

//是否允许改变
self.input.shouldChangeText = ^BOOL(NSRange range, NSString *replacementText) {
return YES;
};

//即将发送（键盘上Done按钮）
self.input.willSendMessageText = ^(NSString *text) {

//TODO: send message

[weakSelf.input done];

};
