//
//  CodeDataView.h
//  GPSCllector
//
//  Created by 图软 on 2017/9/1.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTextField.h"

@interface CodeDataView : UIView

//设备维修记录
@property (nonatomic, strong) UIButton *recordBtn;
//关闭按钮
@property (nonatomic, strong) UIButton *closeBtn;
//设备名字
@property (nonatomic, strong) UILabel *deviceNameLb;
//序列号
@property (nonatomic, strong) UILabel *listNumLb;
//生产日期
@property (nonatomic, strong) UILabel *dateLb;
//车牌号
@property (nonatomic, strong) MainTextField *vehNumTf;
//故障原因
@property (nonatomic, strong) MainTextField *reasonTf;
//维修结果
@property (nonatomic, strong) MainTextField *resultTf;
//材料费
@property (nonatomic, strong) MainTextField *mateCostTf;
//维修费
@property (nonatomic, strong) MainTextField *maintCostTf;

//提交按钮
@property (nonatomic, strong) UIButton *submitBtn;

@end
