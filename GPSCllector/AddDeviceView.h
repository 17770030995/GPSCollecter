//
//  AddDeviceView.h
//  GPSCllector
//
//  Created by 图软 on 2017/10/23.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTextField.h"

@interface AddDeviceView : UIView

@property (nonatomic, strong) MainTextField *nameTypeTf;

@property (nonatomic, strong) MainTextField *vehicleTf;

@property (nonatomic, strong) MainTextField *troubleTf;

@property (nonatomic, strong) UIButton *cancalBtn;

@property (nonatomic, strong) UIButton *sureBtn;

@end
