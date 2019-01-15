//
//  UIView+InputLayout.m
//  UBInput
//
//  Created by Zero on 2019/1/15.
//  Copyright © 2019年 Zero. All rights reserved.
//

#import "UIView+InputLayout.h"

@implementation UIView (InputLayout)
- (void)ubInput_layoutToSupViewWithLeading:(CGFloat)leading top:(CGFloat)top trailing:(CGFloat)trailing bottom:(CGFloat)bottom
{
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //创建约束
    NSLayoutConstraint *leadingCt = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:leading];
    
    NSLayoutConstraint *trailingCt = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:trailing];
    
    NSLayoutConstraint *topCt = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:top];
    
    NSLayoutConstraint *bottomCt = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:bottom];
    
    
    [self.superview addConstraints:@[leadingCt, trailingCt, topCt, bottomCt]];
    
    [self.superview updateConstraintsIfNeeded];
}
@end
