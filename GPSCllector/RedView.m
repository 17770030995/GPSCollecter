//
//  RedView.m
//  huibam
//
//  Created by Apple on 2016/11/23.
//  Copyright © 2016年 huibam. All rights reserved.
//

#import "RedView.h"

@implementation RedView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-60, 2)];
        view.backgroundColor = [UIColor redColor];
        [self addSubview:view];
        
    }
    return self;
}

@end
