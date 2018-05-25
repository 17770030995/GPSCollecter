//
//  AddOrderView.h
//  GPSCllector
//
//  Created by 图软 on 2017/10/23.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTextField.h"

@interface AddOrderView : UIView
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *finishBtn;
@property (nonatomic, strong) MainTextField *customerTF;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UILabel *connectLb;
@property (nonatomic, strong) UIButton *addDeviceBtn;
@property (nonatomic, strong) UITableView *customerTb;
//@property (nonatomic, strong) UITableView *connectTb;
@property (nonatomic, strong) UITableView *deviceTb;


@end
