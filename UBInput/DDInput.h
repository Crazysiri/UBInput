
//  DDInput.h
//  Xiandanjia
//
//  Created by qiuyoubo on 2018/7/7.
//  Copyright © 2018年 DD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol DDInputContainer <NSObject>
- (void)addTextView:(UITextView *)textView;
@end

@interface DDInput : NSObject

@property (readonly, nonatomic) UITextView *inputTextView;


//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
@property (nonatomic,copy) BOOL (^shouldChangeText)(NSRange range,NSString *replacementText);

@property (copy, nonatomic) void (^willSendMessageText)(NSString *text);

@property (nonatomic,copy) void (^inputRectChanged)(CGFloat height,CGFloat bottom);

@property (nonatomic, strong) UIView *backgroundView;

- (id)initWithRootView:(UIView *)rootView;

/**
 *  输入toolbar的高度
 */
@property (assign, nonatomic) CGFloat inputToolBarHeight;
/**
 *  输入toolbar 最高的高度 不设置高度限制为0.0
 */
@property (assign, nonatomic) CGFloat maxInputToolBarHeight;

//距离底部的最小值
@property (assign, nonatomic) CGFloat minToolbarBottomDistance;

@property (weak, nonatomic) UIView <DDInputContainer> *container;

- (BOOL)sendTextMessage;

- (void)done;
@end
