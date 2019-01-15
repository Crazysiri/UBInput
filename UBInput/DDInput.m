//
//  DDInput.m
//  Xiandanjia
//
//  Created by qiuyoubo on 2018/7/7.
//  Copyright © 2018年 DD. All rights reserved.
//

#import "DDInput.h"

#import "DDInputTextView.h"

#import "UIView+InputLayout.h"

static void *kMIMTextViewContentSizeContext = &kMIMTextViewContentSizeContext;


@interface DDInput () <UITextViewDelegate> {
    CGFloat _textViewTopAndBottom;
    
    BOOL _isEditing;
}

@property (weak, nonatomic) UIView *rootView;

@property (strong, nonatomic) DDInputTextView *inputTextView;


/*
 最下面 toolbbar的约束（输入）
 */
@property (weak, nonatomic) NSLayoutConstraint *toolbarHeightConstraint;
@property (weak, nonatomic) NSLayoutConstraint *toolbarBottomConstraint;
@end

@implementation DDInput

- (id)initWithRootView:(UIView *)rootView {
    self = [super init];
    if (self) {
        self.inputToolBarHeight = 44;
        self.rootView = rootView;
        [self setup];
    }
    return self;
}

- (void)setBackgroundView:(UIView *)backgroundView {
    if (backgroundView != _backgroundView) {
        _backgroundView = backgroundView;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundViewTapped:)];
        [_backgroundView addGestureRecognizer:tap];
    }
}

- (void)backgroundViewTapped:(UITapGestureRecognizer *)gesture {
    [self done];
}


- (void)setContainer:(UIView <DDInputContainer> *)container {
    [self.rootView addSubview:container];
    [self layoutContainer:container];
    _container = container;
    [container addTextView:self.inputTextView];
}

- (void)setMinToolbarBottomDistance:(CGFloat)minToolbarBottomDistance {
    _minToolbarBottomDistance = minToolbarBottomDistance;
    [self updateToolbarBottomDistance:_minToolbarBottomDistance animated:NO];
}

- (void)dealloc {
    [self removeKeyboardNotifications];
    [self removeInputTextViewContentSizeChangedObserver];
}

- (void)setup {
    [self registerForKeyboardNotifications];
    [self addInputTextViewContentSizeChangedObserver];
}

- (void)done {
    [self.backgroundView removeFromSuperview];
    [self.inputTextView resignFirstResponder];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
#pragma mark - toolbar layout reset -
- (void)updateToolbarBottomDistance:(CGFloat )height animated:(BOOL)animated
{
    if (self.inputRectChanged) {
        self.inputRectChanged(self.toolbarHeightConstraint.constant,height);
    }
    if(!animated){
        self.toolbarBottomConstraint.constant = -height;
        [self.rootView layoutSubviews];
//        [self scrollToBottomAnimated:NO];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:height?0.35f:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.toolbarBottomConstraint.constant = -height;
        [weakSelf.rootView layoutSubviews];
//        [weakSelf scrollToBottomAnimated:NO];
        
    } completion:nil];
}

- (void)updateToolbarTextViewHeight:(CGFloat)height
{

    if (self.maxInputToolBarHeight && self.maxInputToolBarHeight < height) {
        height = self.maxInputToolBarHeight;
    }
    
    if (_textViewTopAndBottom == 0.0) {
        _textViewTopAndBottom = self.toolbarHeightConstraint.constant - self.inputTextView.bounds.size.height;
    }
    if (height + _textViewTopAndBottom <= self.inputToolBarHeight) {
        self.toolbarHeightConstraint.constant = self.inputToolBarHeight;
    } else {
        self.toolbarHeightConstraint.constant = height + _textViewTopAndBottom;
    }
    
    [self.container updateConstraintsIfNeeded];
    
    if (self.inputRectChanged) {
        self.inputRectChanged(self.toolbarHeightConstraint.constant,fabs(self.toolbarBottomConstraint.constant));
    }
}

#pragma mark - textViewDelegate -

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        
        return [self sendTextMessage];
    }
    
    if (self.shouldChangeText) {
        return self.shouldChangeText(range,text);
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self updateToolbarTextViewHeight:textView.contentSize.height];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _isEditing = NO;
    [self updateToolbarBottomDistance:_minToolbarBottomDistance animated:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _isEditing = YES;
}

- (BOOL)sendTextMessage
{
    NSString * textString = [self.inputTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([textString isEqualToString:@""]) {//只是空格不允许发送
        return NO;
    }
    //发送文字
    if (self.willSendMessageText) {
        self.willSendMessageText(self.inputTextView.text);
    }
    self.inputTextView.text = @"";
    return NO;
}

#pragma mark - observe -

- (void)addInputTextViewContentSizeChangedObserver {
    [self.inputTextView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize)) options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:kMIMTextViewContentSizeContext];
    
}

- (void)removeInputTextViewContentSizeChangedObserver {
    [self.inputTextView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize)) context:kMIMTextViewContentSizeContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kMIMTextViewContentSizeContext) {
        if (object == self.inputTextView && [keyPath isEqualToString:NSStringFromSelector(@selector(contentSize))]) {
            
            CGSize oldContentSize = [[change objectForKey:NSKeyValueChangeOldKey] CGSizeValue];
            CGSize newContentSize = [[change objectForKey:NSKeyValueChangeNewKey] CGSizeValue];
            if (oldContentSize.height != newContentSize.height) {
                [self updateToolbarTextViewHeight:newContentSize.height];
            }
        }
    }
}

#pragma mark - keyboard -
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)removeKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    if (![self.inputTextView isFirstResponder]) return;
    
    NSDictionary *info = [noti userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if ([self.inputTextView isFirstResponder]) {
        [self updateToolbarBottomDistance:kbSize.height animated:YES];
    }
    if (self.backgroundView) {
        [self.container.superview addSubview:self.backgroundView];
        [self.backgroundView ubInput_layoutToSupViewWithLeading:0 top:0 trailing:0 bottom:0];
        [self.container.superview bringSubviewToFront:self.container];
    }
}


- (void)layoutContainer:(UIView *)toolbar {
    toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    NSLayoutConstraint *leadingCt = [NSLayoutConstraint constraintWithItem:toolbar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:toolbar.superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    
    NSLayoutConstraint *trailingCt = [NSLayoutConstraint constraintWithItem:toolbar attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:toolbar.superview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    
    NSLayoutConstraint *heightCt = [NSLayoutConstraint constraintWithItem:toolbar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.inputToolBarHeight];
    self.toolbarHeightConstraint = heightCt;
    
    NSLayoutConstraint *bottomCt = [NSLayoutConstraint constraintWithItem:toolbar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:toolbar.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    self.toolbarBottomConstraint = bottomCt;
    
    [toolbar.superview addConstraints:@[leadingCt,trailingCt,heightCt,bottomCt]];
    
}


- (DDInputTextView *)inputTextView
{
    if (!_inputTextView) {
        //坐标用来设置上下左右留出距离  长宽会自适应
        _inputTextView = [[DDInputTextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        //        _textView.layer.cornerRadius = 17.0f;
        _inputTextView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        _inputTextView.returnKeyType = UIReturnKeySend;
        
        //        _textView.layer.borderWidth = 0.5f;
        //        _textView.layer.borderColor = [UIColor grayColor].CGColor;
        _inputTextView.textAlignment = NSTextAlignmentNatural;
        _inputTextView.contentMode = UIViewContentModeRedraw;
        _inputTextView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        [_inputTextView setFont:[UIFont systemFontOfSize:15.0f]];
        
        _inputTextView.enablesReturnKeyAutomatically = YES;
        
        _inputTextView.delegate = self;

    }
    return _inputTextView;
}

@end
