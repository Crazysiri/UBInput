//
//  UIView+InputLayout.h
//  UBInput
//
//  Created by Zero on 2019/1/15.
//  Copyright © 2019年 Zero. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (InputLayout)
- (void)ubInput_layoutToSupViewWithLeading:(CGFloat)leading top:(CGFloat)top trailing:(CGFloat)trailing bottom:(CGFloat)bottom;
@end

NS_ASSUME_NONNULL_END
