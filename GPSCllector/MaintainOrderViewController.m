//
//  MaintainOrderViewController.m
//  GPSCllector
//
//  Created by 图软 on 2017/8/31.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import "MaintainOrderViewController.h"
#import "NSString+Hashing.h"
#import <AFNetworking.h>
#import "OrderCell.h"
#import "CodeViewController.h"
#import "RecordViewController.h"
#import "ProductsViewController.h"
#import "AddOrderViewController.h"
#import "MainTextField.h"
#import "TRRequestTool.h"
#import "XHDatePickerView.h"
#import "NSDate+XHExtension.h"
#import "OrderRecordCell.h"
#import "AFNetworking.h"

@interface MaintainOrderViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSString *realname;//真实名字
    NSString *account;//账号
    NSString *userId;
    NSString *custName;//用户名
    NSString *custId;//用户 ID
    NSInteger orderIndex;//扫码时候哪个订单
    NSString *orderCode;//所有提交需要的订单号(包括添加与维修)
    NSString *productName;//设备产品名
    NSString *deviceNum;//产品序列号
    MainTextField *textfield;
}
@property (nonatomic, strong) NSString *deviceCode;
@property (nonatomic, strong) NSString *deviceData;
@property (nonatomic, strong) NSMutableArray *dataArr;//订单数据
@property (nonatomic, strong) NSMutableArray *recordArr;//维修记录

@property (nonatomic, strong) UIButton *addBtn;//添加临时维修单

@end

@implementation MaintainOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    orderView = [[OrderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHE)];
    [self.view addSubview:orderView];
    orderView.tableView.tag = 1;
    orderView.tableView.delegate = self;
    orderView.tableView.dataSource = self;
    
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn.backgroundColor = MAINHEADERCOLOR;
    _addBtn.layer.cornerRadius = 35;
    _addBtn.layer.masksToBounds = YES;
    [_addBtn setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
    [_addBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
//    [_addBtn setTitle:@"添加\n临时维修单" forState:UIControlStateNormal];
//    _addBtn.titleLabel.textColor = UIColorFromRGB(0xffffff);
//    _addBtn.titleLabel.numberOfLines = 0;
//    _addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    _addBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_addBtn addTarget:self action:@selector(addOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addBtn];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.width.height.equalTo(@70);
    }];
    [self.view bringSubviewToFront:_addBtn];
    
    loginView = [[LoginView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHE)];
    [self.view addSubview:loginView];
    loginView.username.delegate = self;
    loginView.password.delegate = self;
    
    
    
    dataView = [[CodeDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHE)];
    [self.view addSubview:dataView];
    dataView.hidden = YES;
    dataView.vehNumTf.delegate= self;
    [dataView.vehNumTf addTarget:self action:@selector(tfTouch:) forControlEvents:UIControlEventAllEditingEvents];
    dataView.reasonTf.delegate = self;
    [dataView.reasonTf addTarget:self action:@selector(tfTouch:) forControlEvents:UIControlEventAllEditingEvents];
    dataView.resultTf.delegate = self;
    [dataView.resultTf addTarget:self action:@selector(tfTouch:) forControlEvents:UIControlEventAllEditingEvents];
    dataView.mateCostTf.delegate = self;
    [dataView.mateCostTf addTarget:self action:@selector(tfTouch:) forControlEvents:UIControlEventAllEditingEvents];
    dataView.maintCostTf.delegate = self;
    [dataView.maintCostTf addTarget:self action:@selector(tfTouch:) forControlEvents:UIControlEventAllEditingEvents];
    
    addView = [[AddDeviceDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHE)];
    [self.view addSubview:addView];
    addView.hidden = YES;
    addView.nameTf.delegate = self;
    [addView.nameTf addTarget:self action:@selector(tfTouch:) forControlEvents:UIControlEventAllEditingEvents];
    addView.typeTf.delegate = self;
    [addView.typeTf addTarget:self action:@selector(tfTouch:) forControlEvents:UIControlEventAllEditingEvents];
    addView.vehNumTf.delegate = self;
    [addView.vehNumTf addTarget:self action:@selector(tfTouch:) forControlEvents:UIControlEventAllEditingEvents];
    addView.textTf.delegate = self;
    [addView.textTf addTarget:self action:@selector(tfTouch:) forControlEvents:UIControlEventAllEditingEvents];
    
    _dataArr = [NSMutableArray array];
    _recordArr = [NSMutableArray array];
    
    [self addActions];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLoginBackView:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [loginView addGestureRecognizer:tap];
    
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    NSString *username = [de objectForKey:@"username"];
    if (username.length > 0) {
        loginView.hidden = YES;
        account = username;
        NSString *real = [de objectForKey:@"realname"];
        userId = [de objectForKey:@"userid"];
        realname = real;
        loginView.username.text = account;
        loginView.password.text = [de objectForKey:@"password"];
        
        [self getOrdersData];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)addActions
{
    [orderView.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [orderView.userBtn addTarget:self action:@selector(goLogin) forControlEvents:UIControlEventTouchUpInside];
    [loginView.loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [dataView.closeBtn addTarget:self action:@selector(closeDataView) forControlEvents:UIControlEventTouchUpInside];
    [dataView.submitBtn addTarget:self action:@selector(submitMaintData) forControlEvents:UIControlEventTouchUpInside];
    [dataView.recordBtn addTarget:self action:@selector(record) forControlEvents:UIControlEventTouchUpInside];
    [addView.submitBtn addTarget:self action:@selector(submitNewData) forControlEvents:UIControlEventTouchUpInside];
    [addView.closeBtn addTarget:self action:@selector(closeAddView) forControlEvents:UIControlEventTouchUpInside];
    [orderView.chooseBtn addTarget:self action:@selector(chooseStatus) forControlEvents:UIControlEventTouchUpInside];
    [orderView.orderBtn addTarget:self action:@selector(chooseOrders) forControlEvents:UIControlEventTouchUpInside];
    [orderView.recordBtn addTarget:self action:@selector(chooseRecord) forControlEvents:UIControlEventTouchUpInside];
    [orderView.dateBtn addTarget:self action:@selector(chooseDate) forControlEvents:UIControlEventTouchUpInside];
    [orderView.searchBtn addTarget:self action:@selector(searchData) forControlEvents:UIControlEventTouchUpInside];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)goLogin
{
    loginView.hidden = NO;

}

-(void)handleDeviceCode
{
    if ((self.deviceCode.length <= 16) || !([[self.deviceCode substringToIndex:2]isEqualToString:@"01"] || [[self.deviceCode substringToIndex:2]isEqualToString:@"02"] || [[self.deviceCode substringToIndex:2]isEqualToString:@"B0"])) {
        [self showLabel:@"此条形码非本公司设备所有"];
        return;
    }
    if ([[self.deviceCode substringToIndex:2]isEqualToString:@"B0"]) {
        [self addDeviceData];
        return;
    }
    
    [self maintainDevice];
    
}

-(void)maintainDevice
{
    NSString *str1 = [self.deviceCode substringToIndex:2];
    NSString *str2 = [self.deviceCode substringWithRange:NSMakeRange(2, 2)];
    NSString *str3 = [self.deviceCode substringWithRange:NSMakeRange(4, 2)];
    NSString *str4_1 = [self.deviceCode substringWithRange:NSMakeRange(6, 1)];
    NSString *str4_2 = [self.deviceCode substringWithRange:NSMakeRange(7, 1)];
    NSString *str5 = [self.deviceCode substringWithRange:NSMakeRange(8, 1)];
    NSString *str6 = [self.deviceCode substringWithRange:NSMakeRange(9, 5)];
    //NSString *str7 = [self.deviceCode substringWithRange:NSMakeRange(14, 2)];
    //NSString *str8 = [self.deviceCode substringWithRange:NSMakeRange(16, 2)];
    NSDictionary *brandDic = [NSDictionary dictionaryWithObjectsAndKeys:@"图岳",@"01",@"图软",@"02", nil];
    NSDictionary *productDic = [NSDictionary dictionaryWithObjectsAndKeys:@"电子路牌",@"01",@"GPS 外设",@"02",@"LCD 车内导乘屏",@"03",@"车联网适配器",@"04",@"语音提示器",@"05",@"电脑报站器",@"06",@"智能公交一体机",@"07",@"中门监视器",@"08",@"路牌控制器",@"09",@"GPS监控车载终端",@"10",@"硬盘视频终端",@"11",@"行车记录仪",@"12",@"液晶电视",@"13",@"硬盘播放器",@"14",@"公交海螺摄像头",@"15",@"公交倒车防水摄像头",@"16",@"公交投币机",@"17",@"调度屏",@"18",@"银护卫",@"19",@"红外摄像机（飞碟型）",@"20", nil];
    NSDictionary *smallTypeDic = [NSDictionary dictionaryWithObjectsAndKeys:@"P7",@"A0",@"P8",@"A1",@"P8.5",@"A2",@"P9",@"A3",@"P10.2",@"A4",@"P8.2T",@"A5",@"P9T",@"A6",@"P10T",@"A7",@"P8.2Y",@"A8",@"P7.6*6",@"A9",@"DK888",@"AA",@"小K888",@"AB",@"雪花888",@"AC",@"888",@"AD",@"28.5",@"B0",@"36.6",@"B1",@"37",@"B2",@"38",@"B3",@"外形 A(甲天行)",@"C0",@"外形 B(鲲博7寸)",@"C1",@"外形 C(海康)",@"C2",@"通讯方式232",@"D0",@"通讯方式232+485",@"D1",@"外形 A(宿迁)",@"E0",@"外形 B(武汉蓝台)",@"E1",@"外形 C(赛威)",@"E2",@"一代",@"F0",@"二代",@"F1",@"三代",@"F2",@"四代",@"F3",@"8字",@"G0",@"12字",@"G1",@"液晶电视",@"H0",@"车载电视一体机",@"H1",@"海康",@"I0",@"大华",@"I1",@"一代",@"J0", nil];
    NSDictionary *yearDic = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"A",@"1",@"B",@"2",@"C",@"3",@"D",@"4",@"E",@"5",@"F",@"6",@"G",@"7",@"H",@"8",@"I",@"9",@"J", nil];
    NSDictionary *monthDic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"A",@"2",@"B",@"3",@"C",@"4",@"D",@"5",@"E",@"6",@"F",@"7",@"G",@"8",@"H",@"9",@"I",@"10",@"J",@"11",@"K",@"12",@"L", nil];
    NSString *brand = [brandDic objectForKey:str1];
    NSString *product =[brand stringByAppendingString:[productDic objectForKey:str2]];
    productName = [productDic objectForKey:str2];
    NSString *type = [NSString string];
    if ([str3 isEqualToString:@"00"]) {
        type = product;
    }else
    {
        type =[product stringByAppendingString:[smallTypeDic objectForKey:str3]];
    }
    
    NSString *yaer1 = [yearDic objectForKey:str4_1];
    NSString *year2 = [yearDic objectForKey:str4_2];
    NSString *year = [[yaer1 stringByAppendingString:year2] stringByAppendingString:@"年"];
    NSString *month =[[year stringByAppendingString:[monthDic objectForKey:str5]] stringByAppendingString:@"月"];
    NSLog(@"%@",month);
    dataView.deviceNameLb.text = type;
    dataView.listNumLb.text = str6;
    deviceNum = str6;
    dataView.dateLb.text = [@"20" stringByAppendingString:month];
    dataView.hidden = NO;
}

#pragma mark -- 选择展示内容(记录或订单)

-(void)chooseStatus
{
    orderView.dateView.hidden = YES;
    orderView.chooseBtn.selected = !orderView.chooseBtn.selected;
    if (orderView.chooseBtn.selected) {
        [UIView animateWithDuration:0.3 animations:^{
            [orderView.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(orderView.mas_top).offset(144);
            }];
            orderView.arrowImg.transform = CGAffineTransformRotate(orderView.arrowImg.transform, M_PI);
        }];
    }else
    {
        [UIView animateWithDuration:0.3 animations:^{
            [orderView.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(orderView.mas_top).offset(64);
            }];
            orderView.arrowImg.transform = CGAffineTransformRotate(orderView.arrowImg.transform, M_PI);
        }];
    }
}

-(void)chooseOrders
{
    
    [orderView.chooseBtn setTitle:@"维修订单" forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        [orderView.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(orderView.mas_top).offset(64);
        }];
        orderView.arrowImg.transform = CGAffineTransformRotate(orderView.arrowImg.transform, M_PI);
    }];
    orderView.chooseBtn.selected = !orderView.chooseBtn.selected;
    [self getOrdersData];//重新获取所有订单数据
}

-(void)chooseRecord
{
    orderView.dateView.hidden = NO;
    [orderView.chooseBtn setTitle:@"维修记录" forState:UIControlStateNormal];
    if (_recordArr.count > 0) {
        orderView.countLb.text = [NSString stringWithFormat:@"%ld条记录",_recordArr.count];
    }
    
    orderView.tableView.tag = 2;
    [orderView.tableView reloadData];
}

-(void)chooseDate
{
    NSString *format = @"yyyy-MM-dd";
    XHDatePickerView *datepicker = [[XHDatePickerView alloc] initWithCurrentDate:[NSDate date] CompleteBlock:^(NSDate *startDate, NSDate *endDate) {
        if (startDate) {
            orderView.startLb.text = [startDate stringWithFormat:format];
        }
        if (endDate) {
            orderView.endLb.text = [endDate stringWithFormat:format];
        }
    }];
    datepicker.datePickerStyle = DateStyleShowYearMonthDay;
    datepicker.dateType = DateTypeStartDate;
    datepicker.minLimitDate = [NSDate date:@"2010-2-28 12:22" WithFormat:@"yyyy-MM-dd HH:mm"];
    datepicker.maxLimitDate = [NSDate date:@"2030-2-28 12:12" WithFormat:@"yyyy-MM-dd HH:mm"];
    [datepicker show];
}

-(void)searchData
{
    [_recordArr removeAllObjects];
    NSString *startStr = orderView.startLb.text;
    NSString *endStr = orderView.endLb.text;
    if ([startStr isEqualToString:@"开始时间"] || [endStr isEqualToString:@"结束时间"]) {
        startStr = @"0";
        endStr = @"0";
        //[self showLabel:@"暂未选择时间,即将返回当月维修记录"];
    }else
    {//也可用字符串大小比较时间大小
        NSString * str = [self intervalFromTime:startStr toTheTime:endStr];
        if (str) {
            [self showLabel:str];
            return;
        }
    }
    
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    p = @{@"FLAG":@"OldOrder",@"Account":account,@"UserId":userId,@"FirstDay":startStr,@"LastDay":endStr}.mutableCopy;
    _md_get_weakSelf();
    TRRequestTool *manager = [TRRequestTool shareManager];
    [manager DataUrl:@"http://60.191.59.10:19000/WebApi/api.aspx" withParameters:p result:^(id data, NSError *error) {
        NSMutableString *str = [[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",arr);
        NSDictionary *dataDic = arr[0];
        if ([[[dataDic objectForKey:@"code"] stringValue] length] == 0) {
            [weakSelf showLabel:@"此时间段内无维修记录"];
            orderView.countLb.text = @"0条记录";
            orderView.tableView.tag = 2;
            [orderView.tableView reloadData];
            return ;
        }
        orderView.countLb.text = [NSString stringWithFormat:@"%ld条记录",arr.count];
        _recordArr = [NSMutableArray arrayWithArray:arr];
        orderView.tableView.tag = 2;
        [orderView.tableView reloadData];
    }];
    
    
    
    
}

-(NSString *)GetBeforeThirtyDays
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    [components setDay:([components day] - 30)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy-MM-dd"];
    return [dateday stringFromDate:beginningOfWeek];
}

//比较查询的时间间隔

-(NSString *)intervalFromTime:(NSString *)dateStr1 toTheTime:(NSString *)dateStr2
{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd"];
    NSDate *d1 = [date dateFromString:dateStr1];
    NSTimeInterval date1 = [d1 timeIntervalSince1970]*1;
    NSDate *d2 = [date dateFromString:dateStr2];
    NSTimeInterval date2 = [d2 timeIntervalSince1970]*1;
    NSTimeInterval cha = date2 - date1;
    if (cha <= 0) {
        NSString *str = @"请更正查询的前后日期";
        return str;
    }else
    {
        return nil;
    }
}


#pragma mark --- 添加设备序列号

-(void)addDeviceData
{
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    p = @{@"FLAG":@"ProductInfo",@"Pro_List":self.deviceCode}.mutableCopy;
    NSLog(@"%@",p);
    TRRequestTool *manager = [TRRequestTool shareManager];
    [manager DataUrl:@"http://60.191.59.10:19000/WebApi/api.aspx" withParameters:p result:^(id data, NSError *error) {
        NSMutableString *str = [[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",arr);
        NSDictionary *dataDic = arr[0];
        if ([[[dataDic objectForKey:@"ordercode"] stringValue] length] == 0) {
            addView.listNumLb.text = self.deviceCode;
            deviceNum = self.deviceCode;
            addView.customerLb.text = custName;
            addView.hidden = NO;
        }else
        {
            deviceNum = self.deviceCode;
            dataView.deviceNameLb.text = [dataDic objectForKey:@"productname"];
            productName = [dataDic objectForKey:@"productname"];
            dataView.listNumLb.text = [dataDic objectForKey:@"productlist"];
            dataView.dateLb.text = [dataDic objectForKey:@"creattime"];
            dataView.hidden = NO;
            
        }
        
    }];
}

-(void)closeAddView
{
    addView.hidden = YES;
}

-(void)submitNewData
{
    NSString *proName = addView.nameTf.text;
    NSString *proType = addView.typeTf.text;
    NSString *vehCode = addView.vehNumTf.text;
    NSString *remark = addView.textTf.text;
    if (proName.length == 0 || proType.length == 0 || vehCode.length == 0) {
        [self showLabel:@"为保证信息完整性,请填写所需信息"];
        return;
    }
    
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    p = @{@"FLAG":@"Supplement",@"Code":orderCode,@"Pro_Name":proName,@"Pro_Type":proType,@"Pro_List":self.deviceCode,@"VehCode":vehCode,@"C_Id":custId,@"C_Name":custName,@"Creat_Name":realname,@"Creat_Id":userId,@"Remark":remark}.mutableCopy;
    NSLog(@"%@",p);
    TRRequestTool *manager = [[TRRequestTool alloc]init];
    [manager DataUrl:@"http://60.191.59.10:19000/WebApi/api.aspx" withParameters:p result:^(id data, NSError *error) {
        NSMutableString *str = [[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",arr);
        NSDictionary *dataDic = arr[0];
        if ([[dataDic objectForKey:@"statu"] isEqualToString:@"true"]) {
            [self showLabel:@"设备序列号补录成功"];
            addView.hidden = YES;
        }else
        {
            [self showLabel:@"补录失败"];
        }
        
    }];
}

#pragma mark ---- 登录

-(void)login
{
    NSString *username = loginView.username.text;
    NSString *password = loginView.password.text;
    if (username.length == 0) {
        [self showLabel:@"账号为空!"];
        return;
    }
    if (password.length == 0) {
        [self showLabel:@"密码为空!"];
        return;
    }
    NSString *md5Psword = [[password MD5Hash] substringWithRange:NSMakeRange(8, 16)];
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    p = @{@"FLAG":@"Login",@"Account":username,@"PWD":md5Psword}.mutableCopy;
    NSLog(@"%@",p);
    _md_get_weakSelf();
    TRRequestTool *manager = [TRRequestTool shareManager];
    [manager DataUrl:@"http://60.191.59.10:19000/WebApi/api.aspx" withParameters:p result:^(id data, NSError *error) {
        NSMutableString *str = [[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",arr);
        NSDictionary *dataDic = arr[0];
        if ([[dataDic objectForKey:@"iname"] length] != 0) {
            loginView.hidden = YES;
            [weakSelf showLabel:@"登录成功!"];
            NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
            realname = [dataDic objectForKey:@"Name"];
            account = [dataDic objectForKey:@"iname"];
            userId = [dataDic objectForKey:@"UserId"];
            [de setObject:account forKey:@"username"];
            [de setObject:password forKey:@"password"];
            [de setObject:realname forKey:@"realname"];
            [de setObject:[dataDic objectForKey:@"UserId"] forKey:@"userid"];
            [de synchronize];
            if (orderView.tableView.tag == 1) {
                [weakSelf getOrdersData];
            }
            if (_recordArr.count > 0 && orderView.tableView.tag == 2) {
                [_recordArr removeAllObjects];
                [orderView.tableView reloadData];
                orderView.countLb.text = @"";
            }
            
        }
    }];
    
}


-(void)closeDataView
{
    dataView.hidden = YES;
}

#pragma mark -- 提交维修具体情况
-(void)submitMaintData
{
    NSString *vehicle = dataView.vehNumTf.text;
    NSString *reason = dataView.reasonTf.text;
    NSString *result = dataView.resultTf.text;
    NSString *m1 = dataView.mateCostTf.text;
    NSString *m2 = dataView.maintCostTf.text;
    NSString *list = dataView.listNumLb.text;
    if (vehicle.length == 0 || reason.length == 0 || result.length == 0 || m1.length == 0 || m2.length == 0) {
        [self showLabel:@"为保证信息完整性,请填写所有信息"];
        return;
    }
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    p = @{@"FLAG":@"ResultInfo",@"Code":orderCode,@"Pro_Name":productName,@"VehCode":vehicle,@"Faultcause":reason,@"MaintResult":result,@"MaterialCost":m1,@"MaintenanceCost":m2,@"List":list,@"Name":realname}.mutableCopy;
    _md_get_weakSelf();
    NSLog(@"%@",p);
    TRRequestTool *manager = [[TRRequestTool alloc]init];
    [manager DataUrl:@"http://60.191.59.10:19000/WebApi/api.aspx" withParameters:p result:^(id data, NSError *error) {
        NSMutableString *str = [[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",arr);
        NSDictionary *dataDic = arr[0];
        NSString *status = [dataDic objectForKey:@"statu"];
        if ([status isEqualToString:@"true"]) {
            dataView.hidden = YES;
            [weakSelf showLabel:@"提交成功"];
        }else
        {
            [weakSelf showLabel:@"提交失败"];
        }
    }];
    
}

-(void)record
{
    RecordViewController *vc = [[RecordViewController alloc]init];
    vc.deviceNum = deviceNum;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark --- 获取维修订单

-(void)getOrdersData
{
    [_dataArr removeAllObjects];
   
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    p = @{@"FLAG":@"OrderInfo",@"Account":account,@"UserId":userId}.mutableCopy;
    _md_get_weakSelf();
    NSLog(@"%@",p);
    TRRequestTool *manager = [TRRequestTool shareManager];
    [manager DataUrl:@"http://60.191.59.10:19000/WebApi/api.aspx" withParameters:p result:^(id data, NSError *error) {
        if (error) {
            [weakSelf showLabel:@"获取订单数据出错"];
            orderView.tableView.tag = 1;
            [orderView.tableView reloadData];
            return ;
        }
        NSMutableString *str = [[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",arr);
        NSDictionary *dataDic = arr[0];
        if ([[[dataDic objectForKey:@"code"] stringValue] length] == 0) {
            [weakSelf showLabel:@"暂无订单需要处理"];
            orderView.tableView.tag = 1;
            [orderView.tableView reloadData];
            return ;
        }
        _dataArr = [NSMutableArray arrayWithArray:arr];
        orderView.tableView.tag = 1;
        [orderView.tableView reloadData];
    }];
    
}

#pragma mark --- 添加维修订单

-(void)addOrder
{
    AddOrderViewController *vc = [[AddOrderViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma  mark ==== UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        return _dataArr.count;
    }else
    {
        return _recordArr.count;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdent1 = [NSString stringWithFormat:@"orderCell%ld",indexPath.row];
    if (tableView.tag == 1) {
        OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent1];
        if (cell == nil) {
            cell = [[OrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent1];
        }
        NSDictionary *dataDic = [NSDictionary dictionary];
        dataDic = _dataArr[indexPath.row];
        if (![[dataDic objectForKey:@"code"] isEqual:[NSNull null]]) {
            cell.orderNumLb.text = [[dataDic objectForKey:@"code"] stringValue];
        }
        if (![[dataDic objectForKey:@"singledate"] isEqual:[NSNull null]]) {
            NSArray *arr1 = [[dataDic objectForKey:@"singledate"] componentsSeparatedByString:@" "];
            cell.dateLb.text = arr1[0];
        }
        if (![[dataDic objectForKey:@"uname"] isEqual:[NSNull null]]) {
            cell.clientLb.text = [dataDic objectForKey:@"uname"];
        }
        if (![[dataDic objectForKey:@"contactname"] isEqual:[NSNull null]]) {
            cell.linkmanLb.text = [dataDic objectForKey:@"contactname"];
        }
        if (![[dataDic objectForKey:@"address"] isEqual:[NSNull null]]) {
            cell.addressLb.text = [dataDic objectForKey:@"address"];
        }
        if (![[dataDic objectForKey:@"contactphone"] isEqual:[NSNull null]]) {
            cell.phoneLb.text = [dataDic objectForKey:@"contactphone"];
        }
        if (tableView.tag == 2) {
            [cell.dateLb mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView.mas_right).offset(-10);
            }];
            cell.completeBtn.hidden = YES;
            cell.codeBtn.hidden = YES;
        }
        
        cell.completeBtn.tag = 1000+indexPath.row;
        cell.codeBtn.tag = 2000+indexPath.row;
        [cell.completeBtn addTarget:self action:@selector(orderComplete:) forControlEvents:UIControlEventTouchUpInside];
        [cell.codeBtn addTarget:self action:@selector(orderCode:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else
    {
        NSString *cellIdent2 = [NSString stringWithFormat:@"orderRecordCell%ld",indexPath.row];
        OrderRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent2];
        if (cell == nil) {
            cell = [[OrderRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent2];
        }
        NSDictionary *dataDic = [NSDictionary dictionary];
        dataDic = _recordArr[indexPath.row];
        if (![[dataDic objectForKey:@"code"] isEqual:[NSNull null]]) {
            cell.orderNumLb.text = [[dataDic objectForKey:@"code"] stringValue];
        }
        if (![[dataDic objectForKey:@"singledate"] isEqual:[NSNull null]]) {
            NSArray *arr1 = [[dataDic objectForKey:@"singledate"] componentsSeparatedByString:@" "];
            cell.dateLb.text = arr1[0];
        }
        if (![[dataDic objectForKey:@"uname"] isEqual:[NSNull null]]) {
            cell.clientLb.text = [dataDic objectForKey:@"uname"];
        }
        if (![[dataDic objectForKey:@"contactname"] isEqual:[NSNull null]]) {
            cell.linkmanLb.text = [dataDic objectForKey:@"contactname"];
        }
        if (![[dataDic objectForKey:@"address"] isEqual:[NSNull null]]) {
            cell.addressLb.text = [dataDic objectForKey:@"address"];
        }
        if (![[dataDic objectForKey:@"contactphone"] isEqual:[NSNull null]]) {
            cell.phoneLb.text = [dataDic objectForKey:@"contactphone"];
        }
        return cell;
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductsViewController *vc= [[ProductsViewController alloc]init];
    NSDictionary *dataDic = [NSDictionary dictionary];
    if (tableView.tag == 1) {
        dataDic = _dataArr[indexPath.row];
        vc.isRecord = NO;
    }else
    {
        dataDic = _recordArr[indexPath.row];
        vc.isRecord = YES;
    }
    NSArray *dataArr = [dataDic objectForKey:@"product"];
    vc.dataArr = dataArr;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)orderComplete:(UIButton *)btn
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请确认已经完成此订单,点击继续完成并关闭此订单" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        return ;
    }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        NSInteger index = btn.tag - 1000;
        NSDictionary *dataDic = _dataArr[index];
        NSString *ordercode = [[dataDic objectForKey:@"code"] stringValue];
        NSMutableDictionary *p = [NSMutableDictionary dictionary];
        p = @{@"FLAG":@"Complete",@"Code":ordercode,@"Name":realname}.mutableCopy;
        NSLog(@"%@",p);
        TRRequestTool *manager = [[TRRequestTool alloc]init];
        [manager DataUrl:@"http://60.191.59.10:19000/WebApi/api.aspx" withParameters:p result:^(id data, NSError *error) {
            NSMutableString *str = [[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",arr);
            NSDictionary *dataDic = arr[0];
            NSString *complete = [dataDic objectForKey:@"complete"];
            if ([complete isEqualToString:@"true"]) {
                [self showLabel:@"完成并关闭订单成功"];
            }else
            {
                [self showLabel:@"完成并关闭订单失败"];
            }
        }];
    }];
    [alert addAction:cancel];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)orderCode:(UIButton *)btn
{
    dataView.vehNumTf.text = @"";
    dataView.reasonTf.text = @"";
    dataView.resultTf.text = @"";
    dataView.mateCostTf.text = @"";
    dataView.maintCostTf.text = @"";
    addView.vehNumTf.text = @"";
    addView.nameTf.text = @"";
    addView.typeTf.text = @"";
    addView.textTf.text = @"";
    NSInteger index = btn.tag - 2000;
    orderIndex = index;
    NSDictionary *dataDic = _dataArr[index];
    custName = [dataDic objectForKey:@"uname"];
    custId = [dataDic objectForKey:@"customer_id"];
    orderCode = [[dataDic objectForKey:@"code"] stringValue];
    CodeViewController *vc = [[CodeViewController alloc]init];
    _md_get_weakSelf();
    vc.blockEmail2 = ^void(NSString *emailString) {
        self.deviceCode = emailString;
        NSLog(@"%@",self.deviceCode);
        [weakSelf handleDeviceCode];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark --- 键盘操作

-(void)tfTouch:(MainTextField *)tf
{
    textfield = tf;
}

-(void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary *userInfo = noti.userInfo;
    CGFloat keyboardH = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat tfH = textfield.frame.origin.y + 150;
    CGFloat h = SCREEN_HEIGHE - tfH;
    CGFloat off = h - keyboardH;
    double duration   = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (off < 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0, off, SCREEN_WIDTH, SCREEN_HEIGHE);
        }];
    }
    
}

-(void)keyboardWillHide:(NSNotification *)noti
{
    NSDictionary *userInfo = noti.userInfo;
    double duration   = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHE);
    }];
    
}

-(void)tapLoginBackView:(UITapGestureRecognizer *)tap
{
    if ([tap.view isEqual:loginView]) {
        if ([loginView.username isEditing] || [loginView.password isEditing]) {
            [loginView.username resignFirstResponder];
            [loginView.password resignFirstResponder];
        }else
        {
            loginView.hidden = YES;
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [loginView.username resignFirstResponder];
    [loginView.password resignFirstResponder];
    [dataView.vehNumTf resignFirstResponder];
    [dataView.reasonTf resignFirstResponder];
    [dataView.resultTf resignFirstResponder];
    [dataView.mateCostTf resignFirstResponder];
    [dataView.maintCostTf resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [loginView.username resignFirstResponder];
    [loginView.password resignFirstResponder];
    [dataView.vehNumTf resignFirstResponder];
    [dataView.reasonTf resignFirstResponder];
    [dataView.resultTf resignFirstResponder];
    [dataView.mateCostTf resignFirstResponder];
    [dataView.maintCostTf resignFirstResponder];
}

-(void)showLabel:(NSString *)label
{
    if([[NSThread currentThread] isMainThread])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = label;
        [hud setXOffset:0];
        [hud setYOffset:90];
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2.5];
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = label;
            [hud setXOffset:0];
            [hud setYOffset:90];
            hud.margin = 10.0;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2.5];
        });
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
