//
//  UILabel+Extension.m
//  SchedulingSystem
//
//  Created by 图软 on 2016/12/21.
//  Copyright © 2016年 LCR. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

+ (UILabel *)labelWithFont:(CGFloat)size
                      Text:(NSString *)text
                 Alignment:(NSTextAlignment)alignment
                 textColor:(UIColor *)color
{
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:size];
    label.text = text;
    label.textAlignment = alignment;
    label.textColor = color;
    return label;
}

@end
