//
//  RecordViewController.m
//  GPSCllector
//
//  Created by 图软 on 2017/9/13.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import "RecordViewController.h"
#import <AFNetworking.h>
#import "RecordCell.h"
#import "TRRequestTool.h"

@interface RecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    recordView = [[RecordView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHE)];
    [self.view addSubview:recordView];
    
    recordView.tableView.delegate = self;
    recordView.tableView.dataSource = self;
    
    [recordView.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    _dataArr = [NSMutableArray array];
    
    [self getData];
    
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getData
{
    [_dataArr removeAllObjects];
    
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    if (self.deviceNum.length > 0) {
        p = @{@"FLAG":@"Record",@"List":self.deviceNum}.mutableCopy;
    }
    _md_get_weakSelf();
    NSLog(@"%@",p);
    TRRequestTool *manager = [TRRequestTool shareManager];
    [manager DataUrl:@"http://60.191.59.10:19000/WebApi/api.aspx" withParameters:p result:^(id data, NSError *error) {
        NSMutableString *str = [[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",arr);
        NSDictionary *dataDic = arr[0];
        if ([[[dataDic objectForKey:@"maintlaborid"] stringValue] length] == 0) {
            [weakSelf showLabel:@"此设备暂无维修记录"];
            [recordView.tableView reloadData];
            return ;
        }
        _dataArr = [NSMutableArray arrayWithArray:arr];
        recordView.titleLb.text = [@"维修记录" stringByAppendingString:[NSString stringWithFormat:@"(共%ld次)",_dataArr.count]];
        [recordView.tableView reloadData];
    }];
    
}

#pragma  mark -- UITableVIewDeelagte

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 265;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIden = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (cell == nil) {
        cell = [[RecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    }
    NSDictionary *dic = _dataArr[indexPath.row];
    cell.orderId.text = [@"订单号: " stringByAppendingString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"maintlaborid"]]];
    if (![[dic objectForKey:@"vehcode"] isEqual:[NSNull null]]) {
        cell.vehNumLb.text = [@"车牌号: " stringByAppendingString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"vehcode"]]];
    }
    if (![[dic objectForKey:@"faultcause"] isEqual:[NSNull null]]) {
        cell.reasonLb.text = [@"故障原因: " stringByAppendingString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"faultcause"]]];
    }
    
    if (![[dic objectForKey:@"maintresult"] isEqual:[NSNull null]]) {
        cell.resultLb.text = [@"维修结果: " stringByAppendingString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"maintresult"]]];
    }
    
    if (![[dic objectForKey:@"materialcost"] isEqual:[NSNull null]]) {
        cell.mateCost.text = [@"材料费: " stringByAppendingString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"materialcost"]]];
    }
    
    if (![[dic objectForKey:@"maintcost"] isEqual:[NSNull null]]) {
        cell.maintCost.text = [@"维修费: " stringByAppendingString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"maintcost"]]];
    }
    
    if (![[dic objectForKey:@"maintengineer"] isEqual:[NSNull null]]) {
        cell.engineerLb.text = [@"维修人员: " stringByAppendingString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"maintengineer"]]];
    }
    
    if (![[dic objectForKey:@"mainttime"] isEqual:[NSNull null]]) {
        cell.timeLb.text = [@"维修日期: " stringByAppendingString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"mainttime"]]];
    }
    
    if (![[dic objectForKey:@"customer"] isEqual:[NSNull null]]) {
        cell.addressLb.text = [@"客户地址: " stringByAppendingString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"customer"]]];
    }
    
    return cell;
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
