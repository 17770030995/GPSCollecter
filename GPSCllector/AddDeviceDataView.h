//
//  AddDeviceDataView.h
//  GPSCllector
//
//  Created by 图软 on 2017/9/25.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTextField.h"

@interface AddDeviceDataView : UIView

//关闭按钮
@property (nonatomic, strong) UIButton *closeBtn;
//序列号
@property (nonatomic, strong) UILabel *listNumLb;
//客户名
@property (nonatomic, strong) UILabel *customerLb;
//产品类型
@property (nonatomic, strong) MainTextField *typeTf;
//产品名
@property (nonatomic, strong) MainTextField *nameTf;
//车牌号
@property (nonatomic, strong) MainTextField *vehNumTf;
//备注
@property (nonatomic, strong) MainTextField *textTf;


//提交按钮
@property (nonatomic, strong) UIButton *submitBtn;

@end
