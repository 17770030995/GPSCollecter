//
//  MainTextField.m
//  GPSCllector
//
//  Created by 图软 on 16/8/27.
//  Copyright © 2016年 LCR. All rights reserved.
//

#import "MainTextField.h"

@implementation MainTextField

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.returnKeyType=UIReturnKeyDone;
        self.backgroundColor = [UIColor whiteColor];
        [self setValue:MAINPLACEHOLDER forKeyPath:@"_placeholderLabel.textColor"];
        [self setValue:MAINPLACEFONT(15) forKeyPath:@"_placeholderLabel.font"];
        self.font = [UIFont systemFontOfSize:16];
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 0);
}


@end
