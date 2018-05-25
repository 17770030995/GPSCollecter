//
//  OrderView.h
//  GPSCllector
//
//  Created by 图软 on 2017/8/31.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderView : UIView

@property(nonatomic, strong) UIButton *backBtn;
@property(nonatomic, strong) UIButton *chooseBtn;//切换完成与未完成订单
@property(nonatomic, strong) UIImageView *arrowImg;
@property(nonatomic, strong) UIButton *userBtn;//切换账号
@property(nonatomic, strong) UIView  *chooseView;
@property(nonatomic, strong) UIButton *orderBtn;//订单
@property(nonatomic, strong) UIButton *recordBtn;//记录
@property(nonatomic, strong) UIView *dateView;
@property(nonatomic, strong) UIButton *dateBtn;//选择时间
@property(nonatomic, strong) UILabel  *startLb;//起始时间
@property(nonatomic, strong) UILabel  *endLb;//结束时间
@property(nonatomic, strong) UILabel  *countLb;//查询到的数据数量
@property(nonatomic, strong) UIButton *searchBtn;//搜索
@property(nonatomic, strong) UITableView *tableView;

@end
