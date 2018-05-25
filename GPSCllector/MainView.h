//
//  MainView.h
//  GPSCllector
//
//  Created by 图软 on 16/8/27.
//  Copyright © 2016年 LCR. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MainView : UIView

@property(nonatomic,strong)UIView  *headerView;
@property(nonatomic,strong)UILabel *lineNameLb;
@property(nonatomic,strong)UIButton *sendBtn;
@property(nonatomic,strong)UIButton *lineListBtn;
@property(nonatomic,strong)UIButton *addLineBtn;
@property(nonatomic,strong)UIButton *loginBtn;
@property(nonatomic,strong)UIView  *whiteBgView;
@property(nonatomic,strong)UILabel *angleLb;
@property(nonatomic,strong)UILabel *latlngLb;
@property(nonatomic,strong)UILabel *wayAndTimeLb;
@property(nonatomic,strong)UIView  *greyBgVIew;
@property(nonatomic,strong)UILabel *kindAndNumLb;
@property(nonatomic,strong)UIButton *changeBtn;
@property(nonatomic,strong)UITableView *stopsTableView;

@end
