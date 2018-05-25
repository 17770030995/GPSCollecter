//
//  LoginView.h
//  GPSCllector
//
//  Created by 图软 on 2017/8/31.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTextField.h"
@interface LoginView : UIView

@property (nonatomic, strong) MainTextField *username;
@property (nonatomic, strong) MainTextField *password;
@property (nonatomic, strong) UIButton *loginBtn;

@end
