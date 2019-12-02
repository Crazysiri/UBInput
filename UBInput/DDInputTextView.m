//
//  DDInputTextView.m
//  Xiandanjia
//
//  Created by qiuyoubo on 2018/7/7.
//  Copyright © 2018年 DD. All rights reserved.
//

#import "DDInputTextView.h"

@interface DDInputTextView ()
@property (weak, nonatomic) UILabel *placeholderLabel;
@end


@implementation DDInputTextView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.placeholderLabel.hidden = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self showOrHideLabel];
}

- (void)showOrHideLabel {
    BOOL hidden = self.text.length == 0 ? NO : YES;
    
    if (_placeholderLabel.hidden != hidden) {
        _placeholderLabel.hidden = hidden;
    }
}

- (void)textDidChange:(NSNotification *)noti {
    [self showOrHideLabel];
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, 200, 20)];
        placeHolderLabel.textColor =  [UIColor lightGrayColor];
        placeHolderLabel.textAlignment = NSTextAlignmentLeft;
        placeHolderLabel.font = [UIFont systemFontOfSize:15];
        placeHolderLabel.text = @"有爱评论，说点好听的";
        [self addSubview:placeHolderLabel];
        _placeholderLabel = placeHolderLabel;
    }
    return _placeholderLabel;
}


@end
