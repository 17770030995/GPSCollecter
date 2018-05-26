//
//  ViewController.m
//  GPSCllector
//
//  Created by 图软 on 16/8/27.
//  Copyright © 2016年 LCR. All rights reserved.
//

#import "ViewController.h"
#import "AddLineViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "StopCell.h"
#import <MessageUI/MessageUI.h>
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"
#import <CFNetwork/CFNetwork.h>
#import <math.h>


@interface ViewController ()<CLLocationManagerDelegate,SKPSMTPMessageDelegate,MFMailComposeViewControllerDelegate>
{
    UIView *lineListView;
    UIView *lineAddView;
    UIView *sendMessageView;
    NSInteger type;
    NSTimer *timer;
    CLLocationCoordinate2D lastCoor;
}

@property(nonatomic,strong)CLLocationManager *locMgr;
@property(nonatomic,strong)UIView *listBgView;
@property(nonatomic,strong)UILabel *listTitleLb;
@property(nonatomic,strong)UITableView *lineListTbView;
@property(nonatomic,strong)UIButton *addLineBtn;
@property(nonatomic,strong)UIButton *cancelAddBtn;

@property(nonatomic,strong)UIView *addLineBgView;
@property(nonatomic,strong)UILabel *addLineTitleLb;
@property(nonatomic,strong)MainTextField *textField;
@property(nonatomic,strong)UIButton *sureAddBtn;
@property(nonatomic,strong)UIButton *cancelSureBtn;

@property(nonatomic,strong)UIView *sendBgView;
@property(nonatomic,strong)UILabel *sendTitleLb;
@property(nonatomic,strong)MainTextField *sendTf;
@property(nonatomic,strong)UIButton *sendBtn;
@property(nonatomic,strong)UIButton *cancelSendBtn;

@property(nonatomic,strong)NSMutableArray *lineArr;
@property(nonatomic,strong)NSMutableArray *upStopsArr;
@property(nonatomic,strong)NSMutableArray *downStopsArr;
@property(nonatomic,strong)NSString *selectedLine;
@property(nonatomic,strong)NSString *angle;
@property(nonatomic,strong)NSString *latitute;
@property(nonatomic,strong)NSString *longitute;
@property(nonatomic,strong)NSString *gpsTime;
@property(nonatomic,strong)NSString *toAddress;
@property(nonatomic,strong)NSString *filePath;
@property(nonatomic,strong)NSString *conStr;


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    mainView = [[MainView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHE)];
    [self.view addSubview:mainView];
    
    _locMgr = [[CLLocationManager alloc]init];
    _locMgr.delegate = self;
    _locMgr.distanceFilter = 3.0;
    _locMgr.headingFilter = 1;
    _locMgr.desiredAccuracy = kCLLocationAccuracyBest;
    [_locMgr requestWhenInUseAuthorization];
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *data = [defaults objectForKey:@"dataArr"];
    if (data.count == 0) {
        NSString *inAngle = [NSString string];
        NSString *inLatitude = [NSString string];
        NSString *inLongitude = [NSString string];
        NSString *inGpsTime = [NSString string];
        NSString *outAngle = [NSString string];
        NSString *outLatitude = [NSString string];
        NSString *outLongitude = [NSString string];
        NSString *outGpsTime = [NSString string];
        NSDictionary *inDic = [NSDictionary dictionaryWithObjectsAndKeys:inAngle,@"angle",inLatitude,@"latitude",inLongitude,@"longitude",inGpsTime,@"gpsTime", nil];
        NSDictionary *outDic = [NSDictionary dictionaryWithObjectsAndKeys:outAngle,@"angle",outLatitude,@"latitude",outLongitude,@"longitude",outGpsTime,@"gpsTime", nil];
        NSDictionary *stopDic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"人民医院",@"stopName",inDic,@"inDic",outDic,@"outDic", nil];
        NSDictionary *stopDic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"八一公园",@"stopName",inDic,@"inDic",outDic,@"outDic", nil];
        NSArray *upstops = [NSArray arrayWithObjects:stopDic1, nil];
        NSArray *downStops = [NSArray arrayWithObjects:stopDic2, nil];
        NSString *linename = @"66路";
        NSDictionary *lineDic = [NSDictionary dictionaryWithObjectsAndKeys:linename,@"lineName",upstops,@"upStops",downStops,@"downStops", nil];
        NSArray *dataArr = [NSArray arrayWithObjects:lineDic, nil];
        [defaults setObject:dataArr forKey:@"dataArr"];
        [defaults synchronize];
        NSMutableArray *lineNames = [NSMutableArray array];
        [lineNames addObject:linename];
        _lineArr = [NSMutableArray arrayWithArray:lineNames];
    }else
    {
        NSMutableArray *lineNames = [NSMutableArray array];
        for (NSDictionary *dic in data) {
            NSString *lineName = [dic objectForKey:@"lineName"];
            [lineNames addObject:lineName];
        }
        _lineArr = [NSMutableArray arrayWithArray:lineNames];
    }
    _upStopsArr = [NSMutableArray array];
    _downStopsArr = [NSMutableArray array];
    _angle = @"";
    _gpsTime  = @"";
    _latitute = @"";
    _longitute = @"";
    type = 1;
    
    mainView.stopsTableView.delegate = self;
    mainView.stopsTableView.dataSource = self;
    mainView.stopsTableView.tag = 1;
    
    [self addCoverViews];
    [self addBtnActions];
    [_lineListTbView reloadData];
    NSString *mailAddress = [defaults objectForKey:@"mailAddress"];
    if (mailAddress) {
        _sendTf.text = mailAddress;
        _toAddress = mailAddress;
    }
    
    lineListView.hidden = NO;
    lineAddView.hidden = YES;
    sendMessageView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(refreshData) name:@"refreshData"
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(refreshData) name:@"refreshData2"
                                              object:nil];
    //定位
    [self startLocation];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
}

-(void)refreshData
{
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    NSArray *dataArr = [de objectForKey:@"dataArr"];
    NSDictionary *dataDic = [NSDictionary dictionary];
    for (NSDictionary *dic in dataArr) {
        if ([[dic objectForKey:@"lineName"] isEqualToString:_selectedLine]) {
            dataDic = dic;
            break;
        }
    }
    NSArray *upStops = [dataDic objectForKey:@"upStops"];
    NSArray *downStops = [dataDic objectForKey:@"downStops"];
    _upStopsArr = [NSMutableArray arrayWithArray:upStops];
    _downStopsArr = [NSMutableArray arrayWithArray:downStops];
    mainView.kindAndNumLb.text = [NSString stringWithFormat:@"(上行%ld个) 编号/站名(定位时间)/进站/出站",_upStopsArr.count];
    type = 1;
    [mainView.stopsTableView reloadData];
}
-(void)btnPress:(UIButton *)btn
{
    NSInteger num = 0;
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    NSArray *dataArr = [de objectForKey:@"dataArr"];
    NSDictionary * lineDic = [NSDictionary dictionary];
    for (NSInteger i = 0;i < dataArr.count;i++) {
        NSDictionary *Dic = dataArr[i];
        if ([[Dic objectForKey:@"lineName"] isEqualToString:_selectedLine]) {
            lineDic = Dic;
            num = i;
            break;
        }
    }
    NSMutableArray *changeDataArr = [NSMutableArray arrayWithArray:dataArr];
    NSInteger tag = btn.tag;
    if (tag <20000) {
        
        NSInteger index = tag - 10000;
        NSArray *upStops = [lineDic objectForKey:@"upStops"];
        NSMutableArray *changeStops = [NSMutableArray arrayWithArray:upStops];
        NSDictionary *stopDic = upStops[index];
        if (btn.selected) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定删除当前进站数据?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                btn.selected = NO;
                NSDictionary *inDic = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"angle",@"",@"latitude",@"",@"longitude",@"",@"gpsTime", nil];
                NSDictionary *newStopDic = [NSDictionary dictionaryWithObjectsAndKeys:[stopDic objectForKey:@"stopName"],@"stopName",inDic,@"inDic",[stopDic objectForKey:@"outDic"],@"outDic", nil];
                [changeStops replaceObjectAtIndex:index withObject:newStopDic];
                [_upStopsArr removeAllObjects];
                [_upStopsArr addObjectsFromArray:changeStops];
                [mainView.stopsTableView reloadData];
                NSDictionary *newLineDic = [NSDictionary dictionaryWithObjectsAndKeys:[lineDic objectForKey:@"lineName"],@"lineName",changeStops,@"upStops",[lineDic objectForKey:@"downStops"],@"downStops", nil];
                [changeDataArr replaceObjectAtIndex:num withObject:newLineDic];
                [de setObject:changeDataArr forKey:@"dataArr"];
                [de synchronize];
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                         return ;
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }else
        {
            btn.selected = YES;
            NSDictionary *inDic = [NSDictionary dictionaryWithObjectsAndKeys:_angle,@"angle",_latitute,@"latitude",_longitute,@"longitude",_gpsTime,@"gpsTime", nil];
            NSDictionary *newStopDic = [NSDictionary dictionaryWithObjectsAndKeys:[stopDic objectForKey:@"stopName"],@"stopName",inDic,@"inDic",[stopDic objectForKey:@"outDic"],@"outDic", nil];
            
            NSLog(@"%@",newStopDic);
            [changeStops replaceObjectAtIndex:index withObject:newStopDic];
            [_upStopsArr removeAllObjects];
            [_upStopsArr addObjectsFromArray:changeStops];
            [mainView.stopsTableView reloadData];
            NSDictionary *newLineDic = [NSDictionary dictionaryWithObjectsAndKeys:[lineDic objectForKey:@"lineName"],@"lineName",changeStops,@"upStops",[lineDic objectForKey:@"downStops"],@"downStops", nil];
            [changeDataArr replaceObjectAtIndex:num withObject:newLineDic];
            [de setObject:changeDataArr forKey:@"dataArr"];
            [de synchronize];
        }
        
    }else if (tag >= 20000 && tag < 30000) {
        
        NSInteger index = tag - 20000;
        NSArray *upStops = [lineDic objectForKey:@"upStops"];
        NSMutableArray *changeStops = [NSMutableArray arrayWithArray:upStops];
        NSDictionary *stopDic = upStops[index];
        if (btn.selected) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定删除当前出站数据?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                btn.selected = NO;
                NSDictionary *outDic = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"angle",@"",@"latitude",@"",@"longitude",@"",@"gpsTime", nil];
                NSDictionary *newStopDic = [NSDictionary dictionaryWithObjectsAndKeys:[stopDic objectForKey:@"stopName"],@"stopName",[stopDic objectForKey:@"inDic"],@"inDic",outDic,@"outDic", nil];
                [changeStops replaceObjectAtIndex:index withObject:newStopDic];
                NSDictionary *newLineDic = [NSDictionary dictionaryWithObjectsAndKeys:[lineDic objectForKey:@"lineName"],@"lineName",changeStops,@"upStops",[lineDic objectForKey:@"downStops"],@"downStops", nil];
                [changeDataArr replaceObjectAtIndex:num withObject:newLineDic];
                [de setObject:changeDataArr forKey:@"dataArr"];
                [de synchronize];
                [_upStopsArr removeAllObjects];
                [_upStopsArr addObjectsFromArray:changeStops];
                [mainView.stopsTableView reloadData];

            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                return ;
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];

        }else
        {
            btn.selected = YES;
            NSDictionary *outDic = [NSDictionary dictionaryWithObjectsAndKeys:_angle,@"angle",_latitute,@"latitude",_longitute,@"longitude",_gpsTime,@"gpsTime", nil];
            NSDictionary *newStopDic = [NSDictionary dictionaryWithObjectsAndKeys:[stopDic objectForKey:@"stopName"],@"stopName",[stopDic objectForKey:@"inDic"],@"inDic",outDic,@"outDic", nil];
            [changeStops replaceObjectAtIndex:index withObject:newStopDic];
            NSDictionary *newLineDic = [NSDictionary dictionaryWithObjectsAndKeys:[lineDic objectForKey:@"lineName"],@"lineName",changeStops,@"upStops",[lineDic objectForKey:@"downStops"],@"downStops", nil];
            [changeDataArr replaceObjectAtIndex:num withObject:newLineDic];
            [de setObject:changeDataArr forKey:@"dataArr"];
            [de synchronize];
            [_upStopsArr removeAllObjects];
            [_upStopsArr addObjectsFromArray:changeStops];
            [mainView.stopsTableView reloadData];

        }
    }else if(tag >= 30000 && tag < 40000){
        
        NSInteger index = tag - 30000;
        NSArray *downStops = [lineDic objectForKey:@"downStops"];
        NSMutableArray *changeStops = [NSMutableArray arrayWithArray:downStops];
        NSDictionary *stopDic = downStops[index];
        if (btn.selected) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定删除当前进站数据?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                btn.selected = NO;
                NSDictionary *inDic = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"angle",@"",@"latitude",@"",@"longitude",@"",@"gpsTime", nil];
                NSDictionary *newStopDic = [NSDictionary dictionaryWithObjectsAndKeys:[stopDic objectForKey:@"stopName"],@"stopName",inDic,@"inDic",[stopDic objectForKey:@"outDic"],@"outDic", nil];
                [changeStops replaceObjectAtIndex:index withObject:newStopDic];
                NSDictionary *newLineDic = [NSDictionary dictionaryWithObjectsAndKeys:[lineDic objectForKey:@"lineName"],@"lineName",[lineDic objectForKey:@"upStops"],@"upStops",changeStops,@"downStops", nil];
                [changeDataArr replaceObjectAtIndex:num withObject:newLineDic];
                [de setObject:changeDataArr forKey:@"dataArr"];
                [de synchronize];
                [_downStopsArr removeAllObjects];
                [_downStopsArr addObjectsFromArray:changeStops];
                [mainView.stopsTableView reloadData];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                return ;
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }else
        {
            btn.selected = YES;
            NSDictionary *inDic = [NSDictionary dictionaryWithObjectsAndKeys:_angle,@"angle",_latitute,@"latitude",_longitute,@"longitude",_gpsTime,@"gpsTime", nil];
            NSDictionary *newStopDic = [NSDictionary dictionaryWithObjectsAndKeys:[stopDic objectForKey:@"stopName"],@"stopName",inDic,@"inDic",[stopDic objectForKey:@"outDic"],@"outDic", nil];
            [changeStops replaceObjectAtIndex:index withObject:newStopDic];
            NSDictionary *newLineDic = [NSDictionary dictionaryWithObjectsAndKeys:[lineDic objectForKey:@"lineName"],@"lineName",[lineDic objectForKey:@"upStops"],@"upStops",changeStops,@"downStops", nil];
            [changeDataArr replaceObjectAtIndex:num withObject:newLineDic];
            [de setObject:changeDataArr forKey:@"dataArr"];
            [de synchronize];
            [_downStopsArr removeAllObjects];
            [_downStopsArr addObjectsFromArray:changeStops];
            [mainView.stopsTableView reloadData];
        }
    }else
    {
        
        NSInteger index = tag - 40000;
        NSArray *downStops = [lineDic objectForKey:@"downStops"];
        NSMutableArray *changeStops = [NSMutableArray arrayWithArray:downStops];
        NSDictionary *stopDic = downStops[index];
        if (btn.selected) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定删除当前出站数据?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                btn.selected = NO;
                NSDictionary *outDic = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"angle",@"",@"latitude",@"",@"longitude",@"",@"gpsTime", nil];
                NSDictionary *newStopDic = [NSDictionary dictionaryWithObjectsAndKeys:[stopDic objectForKey:@"stopName"],@"stopName",[stopDic objectForKey:@"inDic"],@"inDic",outDic,@"outDic", nil];
                [changeStops replaceObjectAtIndex:index withObject:newStopDic];
                NSDictionary *newLineDic = [NSDictionary dictionaryWithObjectsAndKeys:[lineDic objectForKey:@"lineName"],@"lineName",[lineDic objectForKey:@"upStops"],@"upStops",changeStops,@"downStops", nil];
                [changeDataArr replaceObjectAtIndex:num withObject:newLineDic];
                [de setObject:changeDataArr forKey:@"dataArr"];
                [de synchronize];
                [_downStopsArr removeAllObjects];
                [_downStopsArr addObjectsFromArray:changeStops];
                [mainView.stopsTableView reloadData];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                return ;
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }else
        {
            btn.selected = YES;
            NSDictionary *outDic = [NSDictionary dictionaryWithObjectsAndKeys:_angle,@"angle",_latitute,@"latitude",_longitute,@"longitude",_gpsTime,@"gpsTime", nil];
            NSDictionary *newStopDic = [NSDictionary dictionaryWithObjectsAndKeys:[stopDic objectForKey:@"stopName"],@"stopName",[stopDic objectForKey:@"inDic"],@"inDic",outDic,@"outDic", nil];
            [changeStops replaceObjectAtIndex:index withObject:newStopDic];
            NSDictionary *newLineDic = [NSDictionary dictionaryWithObjectsAndKeys:[lineDic objectForKey:@"lineName"],@"lineName",[lineDic objectForKey:@"upStops"],@"upStops",changeStops,@"downStops", nil];
            [changeDataArr replaceObjectAtIndex:num withObject:newLineDic];
            [de setObject:changeDataArr forKey:@"dataArr"];
            [de synchronize];
            [_downStopsArr removeAllObjects];
            [_downStopsArr addObjectsFromArray:changeStops];
            [mainView.stopsTableView reloadData];
        }
    }
}


-(void)addBtnActions
{
    [mainView.sendBtn addTarget:self action:@selector(sendMassage) forControlEvents:UIControlEventTouchUpInside];
    [mainView.lineListBtn addTarget:self action:@selector(toLineList) forControlEvents:UIControlEventTouchUpInside];
    [mainView.addLineBtn addTarget:self action:@selector(addLineAndStops) forControlEvents:UIControlEventTouchUpInside];
    [mainView.changeBtn addTarget:self action:@selector(changeDirection) forControlEvents:UIControlEventTouchUpInside];
    [_addLineBtn addTarget:self action:@selector(addLine) forControlEvents:UIControlEventTouchUpInside];
    [_cancelAddBtn addTarget:self action:@selector(cancelAddLine) forControlEvents:UIControlEventTouchUpInside];
    [_sureAddBtn addTarget:self action:@selector(makesureAddLine) forControlEvents:UIControlEventTouchUpInside];
    [_cancelSureBtn addTarget:self action:@selector(cancelMakesureAddLine) forControlEvents:UIControlEventTouchUpInside];
    [_sendBtn addTarget:self action:@selector(sendMail) forControlEvents:UIControlEventTouchUpInside];
    [_cancelSendBtn addTarget:self action:@selector(cancelSendMail) forControlEvents:UIControlEventTouchUpInside];
}

//响应按钮事件
//邮件图标按钮
-(void)sendMassage
{
    NSString *routeName = [NSString stringWithFormat:@"%@\n",_selectedLine];
    NSString *addStopStr =[routeName stringByAppendingString:@"\n上行站点名称     纬度     经度     方位角     定位时间\n"];
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    NSArray *dataArr = [de objectForKey:@"dataArr"];
    NSDictionary * lineDic = [NSDictionary dictionary];
    for (NSInteger i = 0;i < dataArr.count;i++) {
        NSDictionary *Dic = dataArr[i];
        if ([[Dic objectForKey:@"lineName"] isEqualToString:_selectedLine]) {
            lineDic = Dic;
            break;
        }
    }
    NSArray *upStops = [lineDic objectForKey:@"upStops"];
    for (NSDictionary *stopDic in upStops) {
        NSString *inStopName = [[stopDic objectForKey:@"stopName"] stringByAppendingString:@"进站"];
        NSString *outStopName = [[stopDic objectForKey:@"stopName"]stringByAppendingString:@"出站"];
        NSDictionary *inDic = [stopDic objectForKey:@"inDic"];
        NSDictionary *outDic = [stopDic objectForKey:@"outDic"];
        NSString *inAngle = [inDic objectForKey:@"angle"];
        NSString *inLat = [inDic objectForKey:@"latitude"];
        NSString *inLon = [inDic objectForKey:@"longitude"];
        NSString *inGps = [inDic objectForKey:@"gpsTime"];
        NSString *outAngle = [outDic objectForKey:@"angle"];
        NSString *outLat = [outDic objectForKey:@"latitude"];
        NSString *outLon = [outDic objectForKey:@"longitude"];
        NSString *outGps = [outDic objectForKey:@"gpsTime"];
        NSString *addStr = [inStopName stringByAppendingString:[NSString stringWithFormat:@"  %@  %@  %@  %@\n%@  %@  %@  %@  %@\n",inLat,inLon,inAngle,inGps,outStopName,outLat,outLon,outAngle,outGps]];
        addStopStr = [addStopStr stringByAppendingString:addStr];
    }
    addStopStr = [addStopStr stringByAppendingString:@"\n下行站点名称     纬度     经度     方位角     定位时间\n"];
    NSArray *downStops = [lineDic objectForKey:@"downStops"];
    for (NSDictionary *stopDic in downStops) {
        NSString *outStopName = [[stopDic objectForKey:@"stopName"] stringByAppendingString:@"出站"];
        NSString *inStopName = [[stopDic objectForKey:@"stopName"] stringByAppendingString:@"进站"];
        NSDictionary *inDic = [stopDic objectForKey:@"inDic"];
        NSDictionary *outDic = [stopDic objectForKey:@"outDic"];
        NSString *inAngle = [inDic objectForKey:@"angle"];
        NSString *inLat = [inDic objectForKey:@"latitude"];
        NSString *inLon = [inDic objectForKey:@"longitude"];
        NSString *inGps = [inDic objectForKey:@"gpsTime"];
        NSString *outAngle = [outDic objectForKey:@"angle"];
        NSString *outLat = [outDic objectForKey:@"latitude"];
        NSString *outLon = [outDic objectForKey:@"longitude"];
        NSString *outGps = [outDic objectForKey:@"gpsTime"];
        NSString *addStr = [inStopName stringByAppendingString:[NSString stringWithFormat:@"  %@  %@  %@  %@\n%@  %@  %@  %@  %@\n",inLat,inLon,inAngle,inGps,outStopName,outLat,outLon,outAngle,outGps]];
        addStopStr = [addStopStr stringByAppendingString:addStr];
    }
    
    _conStr = addStopStr;
    
    //写入文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];
    _filePath= [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",[_selectedLine stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    NSData *fileData = [addStopStr dataUsingEncoding:NSUTF8StringEncoding];
    [fileManager createFileAtPath:_filePath contents:fileData attributes:nil];
    
    sendMessageView.hidden = NO;
    
    //系统邮件发送
//    if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
//        [self sendEmailAction]; // 调用发送邮件的代码
//    }else
//    {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"邮箱账户未绑定,请前往设置界面进行绑定!" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        [alertController addAction:okAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//    }

}

//点击发送邮件按钮
-(void)sendMail
{
    
    [_sendTf resignFirstResponder];
    if (_sendTf.text.length == 0) {
        [self showLabel:@"邮箱地址不能为空"];
        return;
    }
    SKPSMTPMessage *mail = [[SKPSMTPMessage alloc] init];
    [mail setSubject:[NSString stringWithFormat:@"%@",_selectedLine]]; // 设置邮件主题
    [mail setToEmail:_toAddress]; // 目标邮箱
    [mail setFromEmail:@"17770030995@163.com"]; // 发送者邮箱
    [mail setRelayHost:@"smtp.163.com"]; // 发送邮件代理服务器
    [mail setRequiresAuth:YES];
    [mail setLogin:@"17770030995@163.com"]; // 发送者邮箱账号
    [mail setPass:@"lcr201120360223"]; // 发送者邮箱密码
    //[mail setCcEmail:@"362175212@qq.com"];
    //[mail setBccEmail:@"2668526904@qq.com"];
    [mail setWantsSecure:YES];  // 需要加密
    [mail setDelegate:self];
    
    //设置邮件正文内容：
    
    NSString *content = _conStr;
    NSDictionary *plainPart = @{kSKPSMTPPartContentTypeKey : @"text/plain", kSKPSMTPPartMessageKey : content, kSKPSMTPPartContentTransferEncodingKey : @"8bit"};
    NSData *vcfData = [NSData dataWithContentsOfFile:_filePath];
    NSString *str1 =[NSString stringWithFormat:@"text/txt;\r\n\tx-unix-mode=0644;\r\n\tname=\"%@.txt\"",_selectedLine];
    NSString *str2 = [NSString stringWithFormat:@"attachment;\r\n\tfilename=\"%@.txt\"",_selectedLine];
    NSDictionary *vcfPart = [NSDictionary dictionaryWithObjectsAndKeys:str1,kSKPSMTPPartContentTypeKey,str2,kSKPSMTPPartContentDispositionKey,[vcfData encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
    
    //执行发送邮件代码：
    [mail setParts:[NSArray arrayWithObjects:plainPart,vcfPart, nil]]; // 邮件首部字段、邮件内容格式和传输编码
    [mail send];
    
    sendMessageView.hidden = YES;
}

//点击取消发送邮件按钮
-(void)cancelSendMail
{
    sendMessageView.hidden = YES;
    [_sendTf resignFirstResponder];
}

- (void)messageSent:(SKPSMTPMessage *)message
{
    NSLog(@"%@", message);
    [self showLabel:@"邮件发送成功"];
}
- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error
{
    NSLog(@"message - %@\nerror - %@", message, error);
    [self showLabel:@"邮件发送失败"];
}

//系统邮件方法
-(void)sendEmailAction
{
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    
    // 设置邮件主题
    [mailCompose setSubject:_selectedLine];
    
    // 设置收件人
    [mailCompose setToRecipients:@[@"2748964930@qq.com"]];
    // 设置抄送人
    [mailCompose setCcRecipients:@[@"362175212@qq.com"]];
    // 设置密抄送
    [mailCompose setBccRecipients:@[@"smtp@qq.com"]];
    
    /**
     *  设置邮件的正文内容
     */
    NSString *emailContent = @"线路数据采集";
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO];
    // 如使用HTML格式，则为以下代码
    //    [mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    
    /**
     *  添加附件
     */
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath= [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",_selectedLine]];
    //NSString *file = [[NSBundle mainBundle] pathForResource:_selectedLine ofType:@"txt"];
    NSData *pdf = [NSData dataWithContentsOfFile:filePath];
    [mailCompose addAttachmentData:pdf mimeType:@"txt" fileName:[NSString stringWithFormat:@"%@.txt",_selectedLine]];
    
    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
}



//MFMailComposeViewControllerDelegate的代理方法：

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent: // 用户点击发送
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
    }
    
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}


//线路列表
-(void)toLineList
{
    lineListView.hidden = NO;
}

//改变线路站点按钮(带加号的按钮最右侧)
-(void)addLineAndStops
{
    AddLineViewController *vc = [[AddLineViewController alloc]init];
    vc.lineName = _selectedLine;
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

//切换上下行
-(void)changeDirection
{
    if (type == 1) {
        type = 2;
        mainView.kindAndNumLb.text = [NSString stringWithFormat:@"(下行%ld个) 编号/站名(定位时间)/进站/出站",_downStopsArr.count];
        [mainView.stopsTableView reloadData];
    }else
    {
        type = 1;
        mainView.kindAndNumLb.text = [NSString stringWithFormat:@"(上行%ld个) 编号/站名(定位时间)/进站/出站",_upStopsArr.count];
        [mainView.stopsTableView reloadData];
    }
}

//新增线路按钮响应事件
-(void)addLine
{
    lineListView.hidden = YES;
    lineAddView.hidden = NO;
    
}

//取消新增线路
-(void)cancelAddLine
{
    lineListView.hidden = YES;
}

//确定添加线路
-(void)makesureAddLine
{
    if (_textField.text.length == 0) {
        [self showLabel:@"请输入线路名"];
        return;
    }
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    NSArray *dataArr = [de objectForKey:@"dataArr"];
    for (NSDictionary *dict in dataArr) {
        if ([[dict objectForKey:@"lineName"]isEqualToString:_selectedLine]) {
            [self showLabel:@"无法添加,此线路名已存在"];
            return;
        }
    }
    [_textField resignFirstResponder];
    lineAddView.hidden = YES;
    mainView.lineNameLb.text = _selectedLine;
    mainView.kindAndNumLb.text = @"(上行0个) 编号/站名(定位时间)/进站/出站";
    [_lineArr addObject:_selectedLine];
    NSInteger count = _lineArr.count;
    CGFloat heigth;
    if (count <= 5) {
        heigth = count * 40;
    }else
    {
        heigth = 160;
    }
    [_listBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineListView.mas_top).offset(190);
        make.left.equalTo(lineListView.mas_left).offset(20);
        make.right.equalTo(lineListView.mas_right).offset(-20);
        make.height.equalTo(@(heigth + 110));
    }];
    [_lineListTbView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_listTitleLb.mas_bottom).offset(10);
        make.left.equalTo(_listTitleLb.mas_left);
        make.right.equalTo(_listTitleLb.mas_right);
        make.height.equalTo(@(heigth));
    }];
    [_lineListTbView reloadData];

    NSMutableArray *changeDataArr = [NSMutableArray arrayWithArray:dataArr];
    NSArray *upStops = [NSArray array];
    NSArray *downStops = [NSArray array];
    NSDictionary *newLineDic = [NSDictionary dictionaryWithObjectsAndKeys:_selectedLine,@"lineName",upStops,@"upStops",downStops,@"downStops", nil];
    [changeDataArr addObject:newLineDic];
    [de setObject:changeDataArr forKey:@"dataArr"];
    [de synchronize];
    AddLineViewController *vc = [[AddLineViewController alloc]init];
    vc.lineName = _selectedLine;
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

//取消确定
-(void)cancelMakesureAddLine
{
    [_textField resignFirstResponder];
    lineAddView.hidden = YES;
}

//添加悬浮窗口
-(void)addCoverViews
{
    //线路列表悬浮窗口
    lineListView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHE)];
    lineListView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:lineListView];
    NSInteger count = _lineArr.count;
    CGFloat heigth;
    if (count < 5) {
        heigth = _lineArr.count * 40.0;
    }else
    {
        heigth = 160;
    }
    _listBgView = [[UIView alloc]init];
    _listBgView.layer.cornerRadius = 4;
    _listBgView.layer.masksToBounds = YES;
    _listBgView.backgroundColor = [UIColor whiteColor];
    [lineListView addSubview:_listBgView];
    [_listBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineListView.mas_top).offset(190);
        make.left.equalTo(lineListView.mas_left).offset(20);
        make.right.equalTo(lineListView.mas_right).offset(-20);
        make.height.equalTo(@(heigth + 110));
    }];
    _listTitleLb = [[UILabel alloc]init];
    _listTitleLb.font = MAINLINENAMEFONT(16);
    _listTitleLb.textAlignment = NSTextAlignmentCenter;
    _listTitleLb.text = @"线路列表";
    _listTitleLb.textColor = UIColorFromRGB(0x666666);
    [_listBgView addSubview:_listTitleLb];
    [_listTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_listBgView.mas_top);
        make.left.equalTo(_listBgView.mas_left);
        make.right.equalTo(_listBgView.mas_right);
        make.height.equalTo(@30);
    }];
    _lineListTbView = [[UITableView alloc]init];
    _lineListTbView.delegate = self;
    _lineListTbView.dataSource = self;
    _lineListTbView.tag = 2;
    _lineListTbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_listBgView addSubview:_lineListTbView];
    [_lineListTbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_listTitleLb.mas_bottom).offset(10);
        make.left.equalTo(_listTitleLb.mas_left);
        make.right.equalTo(_listTitleLb.mas_right);
        make.height.equalTo(@(heigth));
    }];
    _addLineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addLineBtn setBackgroundImage:CIWC(UIColorFromRGB(0xffffff)) forState:UIControlStateNormal];
    [_addLineBtn setBackgroundImage:CIWC(MAINHEADERCOLOR) forState:UIControlStateHighlighted];
    [_addLineBtn setTitle:@"新增线路" forState:UIControlStateNormal];
    [_addLineBtn setTitle:@"新增线路" forState:UIControlStateHighlighted];
    [_addLineBtn setTitleColor:UIColorFromRGB(0x777777) forState:UIControlStateNormal];
    [_addLineBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateHighlighted];
    _addLineBtn.layer.cornerRadius = 3;
    _addLineBtn.layer.masksToBounds = YES;
    _addLineBtn.layer.borderColor = UIColorFromRGB(0xe6e6e6).CGColor;
    _addLineBtn.layer.borderWidth = 0.7;
    _addLineBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [_listBgView addSubview:_addLineBtn];
    [_addLineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineListTbView.mas_bottom).offset(20);
        make.left.equalTo(_listBgView.mas_left).offset(10);
        make.width.equalTo(@120);
        make.height.equalTo(@40);
    }];
    _cancelAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelAddBtn setBackgroundImage:CIWC(UIColorFromRGB(0xffffff)) forState:UIControlStateNormal];
    [_cancelAddBtn setBackgroundImage:CIWC(MAINHEADERCOLOR) forState:UIControlStateHighlighted];
    [_cancelAddBtn setTitle:@"取  消" forState:UIControlStateNormal];
    [_cancelAddBtn setTitle:@"取  消" forState:UIControlStateHighlighted];
    [_cancelAddBtn setTitleColor:UIColorFromRGB(0x777777) forState:UIControlStateNormal];
    [_cancelAddBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateHighlighted];
    _cancelAddBtn.layer.cornerRadius = 3;
    _cancelAddBtn.layer.masksToBounds = YES;
    _cancelAddBtn.layer.borderColor = UIColorFromRGB(0xe6e6e6).CGColor;
    _cancelAddBtn.layer.borderWidth = 0.7;
    _cancelAddBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [_listBgView addSubview:_cancelAddBtn];
    [_cancelAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addLineBtn.mas_top);
        make.right.equalTo(_listBgView.mas_right).offset(-10);
        make.width.equalTo(_addLineBtn.mas_width);
        make.height.equalTo(_addLineBtn.mas_height);
    }];
    
    //添加线路悬浮窗口
    lineAddView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHE)];
    lineAddView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:lineAddView];
    
    _addLineBgView = [[UIView alloc]init];
    _addLineBgView.layer.cornerRadius = 4;
    _addLineBgView.layer.masksToBounds = YES;
    _addLineBgView.backgroundColor = [UIColor whiteColor];
    [lineAddView addSubview:_addLineBgView];
    [_addLineBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineAddView.mas_top).offset(190);
        make.left.equalTo(lineAddView.mas_left).offset(20);
        make.right.equalTo(lineAddView.mas_right).offset(-20);
        make.height.equalTo(@140);
    }];
    _addLineTitleLb = [[UILabel alloc]init];
    _addLineTitleLb.text = @"新增线路";
    _addLineTitleLb.font = MAINLINENAMEFONT(16);
    _addLineTitleLb.textAlignment = NSTextAlignmentCenter;
    [_addLineBgView addSubview:_addLineTitleLb];
    [_addLineTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addLineBgView.mas_top).offset(5);
        make.left.equalTo(_addLineBgView.mas_left);
        make.right.equalTo(_addLineBgView.mas_right);
        make.height.equalTo(@30);
    }];
    _textField = [[MainTextField alloc]init];
    _textField.tag = 1;
    _textField.placeholder = @"请输入线路名";
    _textField.layer.cornerRadius = 3;
    _textField.layer.masksToBounds = YES;
    _textField.layer.borderWidth = 1;
    _textField.layer.borderColor = MAINHEADERCOLOR.CGColor;
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.delegate = self;
    [_addLineBgView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addLineBgView.mas_left).offset(10);
        make.right.equalTo(_addLineBgView.mas_right).offset(-5);
        make.height.equalTo(@35);
        make.top.equalTo(_addLineTitleLb.mas_bottom).offset(10);
    }];
    _sureAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureAddBtn setBackgroundImage:CIWC(UIColorFromRGB(0xffffff)) forState:UIControlStateNormal];
    [_sureAddBtn setBackgroundImage:CIWC(MAINHEADERCOLOR) forState:UIControlStateHighlighted];
    [_sureAddBtn setTitle:@"确  认" forState:UIControlStateNormal];
    [_sureAddBtn setTitle:@"确  认" forState:UIControlStateHighlighted];
    [_sureAddBtn setTitleColor:UIColorFromRGB(0x777777) forState:UIControlStateNormal];
    [_sureAddBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateHighlighted];
    _sureAddBtn.layer.cornerRadius = 3;
    _sureAddBtn.layer.masksToBounds = YES;
    _sureAddBtn.layer.borderColor = UIColorFromRGB(0xe6e6e6).CGColor;
    _sureAddBtn.layer.borderWidth = 0.7;
    _sureAddBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [_addLineBgView addSubview:_sureAddBtn];
    [_sureAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textField.mas_bottom).offset(10);
        make.left.equalTo(_textField.mas_left);
        make.width.equalTo(@120);
        make.height.equalTo(@40);
    }];
    _cancelSureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelSureBtn setBackgroundImage:CIWC(UIColorFromRGB(0xffffff)) forState:UIControlStateNormal];
    [_cancelSureBtn setBackgroundImage:CIWC(MAINHEADERCOLOR) forState:UIControlStateHighlighted];
    [_cancelSureBtn setTitle:@"取  消" forState:UIControlStateNormal];
    [_cancelSureBtn setTitle:@"取  消" forState:UIControlStateHighlighted];
    [_cancelSureBtn setTitleColor:UIColorFromRGB(0x777777) forState:UIControlStateNormal];
    [_cancelSureBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateHighlighted];
    _cancelSureBtn.layer.cornerRadius = 3;
    _cancelSureBtn.layer.masksToBounds = YES;
    _cancelSureBtn.layer.borderColor = UIColorFromRGB(0xe6e6e6).CGColor;
    _cancelSureBtn.layer.borderWidth = 0.7;
    _cancelSureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [_addLineBgView addSubview:_cancelSureBtn];
    [_cancelSureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sureAddBtn.mas_top);
        make.right.equalTo(_textField.mas_right);
        make.width.equalTo(_sureAddBtn.mas_width);
        make.height.equalTo(_sureAddBtn.mas_height);
    }];
    
    //添加邮件发送悬浮窗口
    sendMessageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHE)];
    sendMessageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:sendMessageView];
    
    _sendBgView = [[UIView alloc]init];
    _sendBgView.layer.cornerRadius = 6;
    _sendBgView.layer.masksToBounds = YES;
    _sendBgView.backgroundColor = [UIColor whiteColor];
    [sendMessageView addSubview:_sendBgView];
    [_sendBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sendMessageView.mas_top).offset(200);
        make.left.equalTo(sendMessageView.mas_left).offset(20);
        make.right.equalTo(sendMessageView.mas_right).offset(-20);
        make.height.equalTo(@145);
    }];
    _sendTitleLb= [[UILabel alloc]init];
    _sendTitleLb.text = @"接收邮箱地址";
    _sendTitleLb.font = MAINLINENAMEFONT(16);
    _sendTitleLb.textColor = UIColorFromRGB(0x666666);
    _sendTitleLb.textAlignment = NSTextAlignmentCenter;
    [_sendBgView addSubview:_sendTitleLb];
    [_sendTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sendBgView.mas_top).offset(10);
        make.left.equalTo(_sendBgView.mas_left);
        make.right.equalTo(_sendBgView.mas_right);
        make.height.equalTo(@30);
    }];
    _sendTf = [[MainTextField alloc]init];
    _sendTf.tag = 2;
    _sendTf.placeholder = @"请输入接收者邮箱";
    _sendTf.layer.cornerRadius = 3;
    _sendTf.layer.masksToBounds = YES;
    _sendTf.layer.borderWidth = 1;
    _sendTf.layer.borderColor = MAINHEADERCOLOR.CGColor;
    _sendTf.font = [UIFont systemFontOfSize:15];
    _sendTf.delegate = self;
    [_sendBgView addSubview:_sendTf];
    [_sendTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_sendBgView.mas_left).offset(10);
        make.right.equalTo(_sendBgView.mas_right).offset(-10);
        make.height.equalTo(@35);
        make.top.equalTo(_sendTitleLb.mas_bottom).offset(10);
    }];
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendBtn setBackgroundImage:CIWC(UIColorFromRGB(0xffffff)) forState:UIControlStateNormal];
    [_sendBtn setBackgroundImage:CIWC(MAINHEADERCOLOR) forState:UIControlStateHighlighted];
    [_sendBtn setTitle:@"发  送" forState:UIControlStateNormal];
    [_sendBtn setTitle:@"发  送" forState:UIControlStateHighlighted];
    [_sendBtn setTitleColor:UIColorFromRGB(0x777777) forState:UIControlStateNormal];
    [_sendBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateHighlighted];
    _sendBtn.layer.cornerRadius = 3;
    _sendBtn.layer.masksToBounds = YES;
    _sendBtn.layer.borderColor = UIColorFromRGB(0xe6e6e6).CGColor;
    _sendBtn.layer.borderWidth = 0.7;
    _sendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [_sendBgView addSubview:_sendBtn];
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sendTf.mas_bottom).offset(10);
        make.left.equalTo(_sendTf.mas_left);
        make.width.equalTo(@120);
        make.height.equalTo(@40);
    }];
    _cancelSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelSendBtn setBackgroundImage:CIWC(UIColorFromRGB(0xffffff)) forState:UIControlStateNormal];
    [_cancelSendBtn setBackgroundImage:CIWC(MAINHEADERCOLOR) forState:UIControlStateHighlighted];
    [_cancelSendBtn setTitle:@"取  消" forState:UIControlStateNormal];
    [_cancelSendBtn setTitle:@"取  消" forState:UIControlStateHighlighted];
    [_cancelSendBtn setTitleColor:UIColorFromRGB(0x777777) forState:UIControlStateNormal];
    [_cancelSendBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateHighlighted];
    _cancelSendBtn.layer.cornerRadius = 3;
    _cancelSendBtn.layer.masksToBounds = YES;
    _cancelSendBtn.layer.borderColor = UIColorFromRGB(0xe6e6e6).CGColor;
    _cancelSendBtn.layer.borderWidth = 0.7;
    _cancelSendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [_sendBgView addSubview:_cancelSendBtn];
    [_cancelSendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sendBtn.mas_top);
        make.right.equalTo(_sendTf.mas_right);
        make.width.equalTo(_sendBtn.mas_width);
        make.height.equalTo(_sendBtn.mas_height);
    }];
}


#pragma mark --- 刷新定位时间

-(void)refreshTime
{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"HH:mm:ss"];
    NSString *time = [date stringFromDate:[NSDate date]];
    NSString *wayAndTime = [NSString stringWithFormat:@"定位方式: GPS 时间:%@",time];
    mainView.wayAndTimeLb.text = wayAndTime;
    _gpsTime = time;
}

#pragma mark --- UITableVIewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        if (type == 1) {
            return _upStopsArr.count;
        }else
        {
            return _downStopsArr.count;
        }
        
    }else
    {
        return _lineArr.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == 1) {
        NSString *identifier = [NSString stringWithFormat:@"cell%ld",indexPath.row];
        if (type == 1) {
            NSDictionary *stopDic = _upStopsArr[indexPath.row];
            StopCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[StopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.inBtn.tag = 10000+indexPath.row;
            cell.outBtn.tag = 20000+indexPath.row;
            [cell.inBtn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
            [cell.outBtn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
            NSString *stopName = stopDic[@"stopName"];
            NSDictionary *inDic = stopDic[@"inDic"];
            NSDictionary *outDic = stopDic[@"outDic"];
            if ([[inDic objectForKey:@"gpsTime"] length] > 0) {
                
                cell.numAndNameAndGpsTimeLb.text = [NSString stringWithFormat:@"%ld %@(%@)",indexPath.row + 1,stopName,[inDic objectForKey:@"gpsTime"]];
                cell.inBtn.selected = YES;
                [cell.inBtn setImage:[UIImage imageNamed:@"点击"] forState:UIControlStateNormal];
            }else
            {
                if ([[outDic objectForKey:@"gpsTime"] length] > 0) {
                    cell.numAndNameAndGpsTimeLb.text = [NSString stringWithFormat:@"%ld %@(%@)",indexPath.row + 1,stopName,[outDic objectForKey:@"gpsTime"]];
                }else
                {
                    cell.numAndNameAndGpsTimeLb.text = [NSString stringWithFormat:@"%ld %@",indexPath.row + 1,stopName];
                }
                
                cell.inBtn.selected = NO;
                [cell.inBtn setImage:[UIImage imageNamed:@"未点击"] forState:UIControlStateNormal];
            }
            if ([[outDic objectForKey:@"gpsTime"] length] > 0) {
                cell.numAndNameAndGpsTimeLb.text = [NSString stringWithFormat:@"%ld %@(%@)",indexPath.row + 1,stopName,[outDic objectForKey:@"gpsTime"]];
                cell.outBtn.selected = YES;
                [cell.outBtn setImage:[UIImage imageNamed:@"点击"] forState:UIControlStateNormal];
            }else
            {
                if ([[inDic objectForKey:@"gpsTime"] length] > 0) {
                    cell.numAndNameAndGpsTimeLb.text = [NSString stringWithFormat:@"%ld %@(%@)",indexPath.row + 1,stopName,[inDic objectForKey:@"gpsTime"]];
                }else
                {
                    cell.numAndNameAndGpsTimeLb.text = [NSString stringWithFormat:@"%ld %@",indexPath.row + 1,stopName];
                }
                
                cell.outBtn.selected = NO;
                [cell.outBtn setImage:[UIImage imageNamed:@"未点击"] forState:UIControlStateNormal];
            }
            return cell;
        }else
        {
            NSDictionary *stopDic = _downStopsArr[indexPath.row];
            StopCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[StopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.inBtn.tag = 30000+indexPath.row;
            cell.outBtn.tag = 40000+indexPath.row;
            [cell.inBtn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
            [cell.outBtn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
            NSString *stopName = stopDic[@"stopName"];
            NSDictionary *inDic = stopDic[@"inDic"];
            NSDictionary *outDic = stopDic[@"outDic"];
            if ([[inDic objectForKey:@"gpsTime"] length] > 0) {
                cell.numAndNameAndGpsTimeLb.text = [NSString stringWithFormat:@"%ld %@(%@)",indexPath.row+1,stopName,[inDic objectForKey:@"gpsTime"]];
                cell.inBtn.selected = YES;
                [cell.inBtn setImage:[UIImage imageNamed:@"点击"] forState:UIControlStateNormal];
            }else
            {
                if ([[outDic objectForKey:@"gpsTime"] length] > 0) {
                    cell.numAndNameAndGpsTimeLb.text = [NSString stringWithFormat:@"%ld %@(%@)",indexPath.row +1,stopName,[outDic objectForKey:@"gpsTime"]];
                }else
                {
                    cell.numAndNameAndGpsTimeLb.text = [NSString stringWithFormat:@"%ld %@",indexPath.row + 1,stopName];
                }
                
                cell.inBtn.selected =NO;
                [cell.inBtn setImage:[UIImage imageNamed:@"未点击"] forState:UIControlStateNormal];
            }
            if ([[outDic objectForKey:@"gpsTime"] length] > 0) {
                cell.numAndNameAndGpsTimeLb.text = [NSString stringWithFormat:@"%ld %@(%@)",indexPath.row +1,stopName,[outDic objectForKey:@"gpsTime"]];
                cell.outBtn.selected = YES;
                [cell.outBtn setImage:[UIImage imageNamed:@"点击"] forState:UIControlStateNormal];
            }else
            {
                if ([[inDic objectForKey:@"gpsTime"] length] > 0) {
                    cell.numAndNameAndGpsTimeLb.text = [NSString stringWithFormat:@"%ld %@(%@)",indexPath.row+1,stopName,[inDic objectForKey:@"gpsTime"]];
                }else
                {
                    cell.numAndNameAndGpsTimeLb.text = [NSString stringWithFormat:@"%ld %@",indexPath.row + 1,stopName];
                }
                
                cell.outBtn.selected =NO;
                [cell.outBtn setImage:[UIImage imageNamed:@"未点击"] forState:UIControlStateNormal];
            }
            return cell;
        }
    }else
    {
        NSString *idetifier = [NSString stringWithFormat:@"cell%ld",indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idetifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idetifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.textLabel.text = _lineArr[indexPath.row];
        cell.textLabel.textColor = UIColorFromRGB(0x666666);
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView.tag == 2) {
        lineListView.hidden = YES;
        mainView.lineNameLb.text = _lineArr[indexPath.row];
        _selectedLine = _lineArr[indexPath.row];
        type = 1;
        NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
        NSArray *dataArr = [de objectForKey:@"dataArr"];
        NSDictionary *dataDic = dataArr[indexPath.row];
        NSArray *upStops = [dataDic objectForKey:@"upStops"];
        NSArray *downStops = [dataDic objectForKey:@"downStops"];
        _upStopsArr = [NSMutableArray arrayWithArray:upStops];
        _downStopsArr = [NSMutableArray arrayWithArray:downStops];
        mainView.kindAndNumLb.text = [NSString stringWithFormat:@"(上行%ld个) 编号/站名(定位时间)/进站/出站",_upStopsArr.count];
        [mainView.stopsTableView reloadData];
    }
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 2) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定删除当前线路数据?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSString *lineName = _lineArr[indexPath.row];
            
            NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
            NSArray *dataArr = [de objectForKey:@"dataArr"];
            NSMutableArray *changeDataArr = [NSMutableArray arrayWithArray:dataArr];
            NSLog(@"%ld",changeDataArr.count);
            for (NSDictionary *dic in changeDataArr) {
                if ([[dic objectForKey:@"lineName"] isEqualToString:lineName]) {
                    [changeDataArr removeObject:dic];
                    break;
                }
            }
            NSLog(@"%ld",changeDataArr.count);
            NSArray *data = [NSArray arrayWithArray:changeDataArr];
            [de setObject:data forKey:@"dataArr"];
            [de synchronize];
            NSMutableArray *lineNames = [NSMutableArray array];
            for (NSDictionary *dic in data) {
                NSString *lineName = [dic objectForKey:@"lineName"];
                [lineNames addObject:lineName];
            }
            _lineArr = [NSMutableArray arrayWithArray:lineNames];
            NSInteger count = _lineArr.count;
            CGFloat heigth;
            if (count <= 5) {
                heigth = count * 40;
            }else
            {
                heigth = 160;
            }
            [_listBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lineListView.mas_top).offset(190);
                make.left.equalTo(lineListView.mas_left).offset(20);
                make.right.equalTo(lineListView.mas_right).offset(-20);
                make.height.equalTo(@(heigth + 85));
            }];
            [_lineListTbView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_listTitleLb.mas_bottom).offset(10);
                make.left.equalTo(_listTitleLb.mas_left);
                make.right.equalTo(_listTitleLb.mas_right);
                make.height.equalTo(@(heigth));
            }];
            [_lineListTbView reloadData];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            return ;
        }];
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else
    {
        return;
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 2) {
        return UITableViewCellEditingStyleDelete;
    }else
    {
        return UITableViewCellEditingStyleNone;
    }
    
}


#pragma mark -- UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 1) {
        [_textField resignFirstResponder];
        _selectedLine = textField.text;
    }else
    {
        [_sendTf resignFirstResponder];
        _toAddress = textField.text;
        NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
        [de setObject:_toAddress forKey:@"mailAddress"];
        [de synchronize];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_sendTf resignFirstResponder];
    [_textField resignFirstResponder];
    return YES;
}

#pragma mark --- 定位功能

-(void)startLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        [_locMgr startUpdatingLocation];
        if ([CLLocationManager headingAvailable]) {
            [_locMgr startUpdatingHeading];
        }
        
    }else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位服务未开启,请前往设置中隐私权限进行设置!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}


//第一次进入车速小于10时方位角取手机指南针方位角
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    if (_angle.length == 0) {
        _angle = [NSString stringWithFormat:@"%d",(int)newHeading.trueHeading];
    }
}

//定位成功后调用此方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *loc = [locations lastObject];
    NSString *latLng = [NSString stringWithFormat:@"%f  %f",loc.coordinate.latitude,loc.coordinate.longitude];
    mainView.latlngLb.text = latLng;
    NSInteger lat = loc.coordinate.latitude * 3600000;
    NSInteger lon = loc.coordinate.longitude * 3600000;
    _latitute = [NSString stringWithFormat:@"%ld",lat];
    _longitute = [NSString stringWithFormat:@"%ld",lon];

//    [self veverseGeLocation:loc completion:^(BOOL sucess, id content) {
//
//        if (sucess) {
//            NSLog(@"成功");
//        }
//
//    }];
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(lat, lon);
    
    CLLocationSpeed speed = loc.speed;
    NSLog(@"速度%lf",speed);
    
    if (lastCoor.latitude > 0 && (speed*3.6) >= 10.) {
        [self getHeadingAngleWith:lastCoor andWith:coor];
    }
    if ((speed*3.6) >= 10.) {
        lastCoor = coor;
    }
    
}

- (void)veverseGeLocation:(CLLocation *)location completion:(void(^)(BOOL sucess, id content)) completion{
    
    CLGeocoder *coder = [[CLGeocoder alloc]init];
    
    //逆编码方法,后台线程执行
    
    [coder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        BOOL sucess;
        
        id content = nil ;
        
        if (error) {
            
            sucess = NO;
            
            content = error.localizedDescription;
            
        }
        else{
            
            sucess = YES;
            
            CLPlacemark *placeMark = placemarks.firstObject;
            
            content = placeMark.addressDictionary;
            
        }
        
        completion(sucess,content);
        
    }];
    
}

-(void)getHeadingAngleWith:(CLLocationCoordinate2D)lastCoo andWith:(CLLocationCoordinate2D)coor
{
    //处理第一个点
    double Rc = 6378137; // 赤道半径
    double Rj = 6356725; // 极半径
    
    double m_LoDeg, m_LoMin, m_LoSec; // longtitude 经度
    double m_LaDeg, m_LaMin, m_LaSec;
    double m_Longitude, m_Latitude;
    double m_RadLo, m_RadLa;
    double m_Ec;
    double m_Ed;
    
    m_LoDeg = (int)lastCoo.longitude;
    m_LoMin = (int)((lastCoo.longitude - m_LoDeg)*60);
    m_LoSec = (lastCoo.longitude - m_LoDeg - m_LoMin/60.)*3600;
    
    m_LaDeg = (int)(lastCoo.latitude);
    m_LaMin = (int)((lastCoo.latitude - m_LaDeg)*60);
    m_LaSec = (lastCoo.latitude - m_LaDeg - m_LaMin/60.)*3600;
    
    m_Longitude = lastCoo.longitude;
    m_Latitude = lastCoo.latitude;
    m_RadLo = lastCoo.longitude * 3.14159265/180.;
    m_RadLa = lastCoo.latitude * 3.14159265/180.;
    m_Ec = Rj + (Rc - Rj) * (90.0-m_Latitude) / 90.;
    m_Ed = m_Ec * cos(m_RadLa);
    
    //处理第二个点
    double n_LoDeg, n_LoMin, n_LoSec; // longtitude 经度
    double n_LaDeg, n_LaMin, n_LaSec;
    double n_Longitude, n_Latitude;
    double n_RadLo, n_RadLa;
    double n_Ec;
    double n_Ed;
    
    n_LoDeg = (int)coor.longitude;
    n_LoMin = (int)((coor.longitude - n_LoDeg)*60);
    n_LoSec = (coor.longitude - n_LoDeg - n_LoMin/60.)*3600;
    
    n_LaDeg = (int)(coor.latitude);
    n_LaMin = (int)((coor.latitude - n_LaDeg)*60);
    n_LaSec = (coor.latitude - n_LaDeg - n_LaMin/60.)*3600;
    
    n_Longitude = coor.longitude;
    n_Latitude = coor.latitude;
    n_RadLo = coor.longitude * 3.14159265/180.;
    n_RadLa = coor.latitude * 3.14159265/180.;
    n_Ec = Rj + (Rc - Rj) * (90.0-n_Latitude) / 90.;
    n_Ed = n_Ec * cos(n_RadLa);
    
    double angle1;
    double dx = (n_RadLo - m_RadLo) * m_Ed;
    double dy = (n_RadLa - m_RadLa) * m_Ec;
    //double out1 = sqrt(dx * dx + dy * dy);
    
    angle1 = atan(fabs(dx/dy)) * 180./3.14159265;
    //判断象限
    double dlo = n_Longitude - m_Longitude;
    double dla = n_Latitude - m_Latitude;
    
    if (dlo > 0 && dla <= 0) {
        angle1 = (90.0 - angle1) + 90.;
    }else if (dlo <= 0 &&  dla < 0)
    {
        angle1 = angle1 + 180.;
    }else if(dlo < 0 && dla >= 0)
    {
        angle1 = (90.0 - angle1) + 270.;
    }
    
    NSString *angleStr = [NSString stringWithFormat:@"%d",(int)angle1];
    NSString *angleStr1 = [NSString stringWithFormat:@"方位角(%@)",angleStr];
    mainView.angleLb.text = angleStr1;
    _angle = angleStr;
    NSLog(@"%@",angleStr);
    
    
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

@end
