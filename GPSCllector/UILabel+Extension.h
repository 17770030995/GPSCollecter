//
//  UILabel+Extension.h
//  SchedulingSystem
//
//  Created by 图软 on 2016/12/21.
//  Copyright © 2016年 LCR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

+ (UILabel *)labelWithFont:(CGFloat)size
                      Text:(NSString *)text
                 Alignment:(NSTextAlignment)alignment
                 textColor:(UIColor *)color;

@end
