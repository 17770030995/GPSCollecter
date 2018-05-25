//
//  AddOrderViewController.m
//  GPSCllector
//
//  Created by 图软 on 2017/10/23.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import "AddOrderViewController.h"
#import "MainTextField.h"
#import "TRRequestTool.h"
#import "AddDeviceCell.h"

@interface AddOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    MainTextField *textField;
}
//客户信息
@property (nonatomic, strong) NSMutableArray *customerData;
//联系人信息
@property (nonatomic, strong) NSMutableArray *connectData;
//设备信息
@property (nonatomic, strong) NSMutableArray *deviceData;

@end

@implementation AddOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    addOrderView = [[AddOrderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHE)];
    [self.view addSubview:addOrderView];
    addOrderView.customerTF.delegate = self;
    addOrderView.customerTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    addOrderView.customerTb.delegate = self;
    addOrderView.customerTb.dataSource = self;
    addOrderView.deviceTb.delegate = self;
    addOrderView.deviceTb.dataSource = self;
    
    addDeviceView = [[AddDeviceView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHE)];
    [self.view addSubview:addDeviceView];
    addDeviceView.hidden = YES;
    addDeviceView.nameTypeTf.delegate = self;
    [addDeviceView.nameTypeTf addTarget:self action:@selector(tfTouch:) forControlEvents:UIControlEventAllEditingEvents];
    addDeviceView.vehicleTf.delegate = self;
    [addDeviceView.vehicleTf addTarget:self action:@selector(tfTouch:) forControlEvents:UIControlEventAllEditingEvents];
    addDeviceView.troubleTf.delegate = self;
    [addDeviceView.troubleTf addTarget:self action:@selector(tfTouch:) forControlEvents:UIControlEventAllEditingEvents];
    
    connectView = [[ConnectDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHE)];
    [self.view addSubview:connectView];
    connectView.hidden = YES;
    connectView.connectTb.delegate = self;
    connectView.connectTb.dataSource = self;
    
    
    _customerData = [NSMutableArray array];
    _connectData = [NSMutableArray array];
    _deviceData = [NSMutableArray array];
    [self addBtnActions];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)addBtnActions
{
    [addOrderView.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [addOrderView.finishBtn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    [addOrderView.searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [addOrderView.addDeviceBtn addTarget:self action:@selector(addDevice) forControlEvents:UIControlEventTouchUpInside];
    [addDeviceView.cancalBtn addTarget:self action:@selector(cancelAddDevice) forControlEvents:UIControlEventTouchUpInside];
    [addDeviceView.sureBtn addTarget:self action:@selector(sureAddDevice) forControlEvents:UIControlEventTouchUpInside];
    [connectView.hideBtn addTarget:self action:@selector(hideConnectView) forControlEvents:UIControlEventTouchUpInside];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)finish
{
    
}

#pragma mark --- 请求客户信息
-(void)search
{
    NSString *searchStr = addOrderView.customerTF.text;
    if (searchStr.length == 0) {
        [self showLabel:@"请输入客户名字关键字"];
        return;
    }
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    p = @{@"FLAG":@"CustomerInfo",@"Customer":searchStr}.mutableCopy;
    NSLog(@"%@",p);
    _md_get_weakSelf();
    TRRequestTool *manager = [TRRequestTool shareManager];
    [manager DataUrl:@"http://60.191.59.10:19000/WebApi/api.aspx" withParameters:p result:^(id data, NSError *error) {
        if (error) {
            [weakSelf showLabel:@"搜索客户信息出错"];
            return ;
        }
        NSMutableString *str = [[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dataDic = arr[0];
        NSLog(@"%@",dataDic);
        if ([[[dataDic objectForKey:@"CustomerId"] stringValue] length] == 0) {
            [weakSelf showLabel:@"未搜索到相应客户信息"];
            return ;
        }
        _customerData = [NSMutableArray arrayWithArray:arr];
        addOrderView.customerTb.hidden = NO;
        addOrderView.customerTb.tag = 1;
        [addOrderView.customerTb reloadData];
        
    }];
}

#pragma mark -- 添加设备

-(void)addDevice
{
    addDeviceView.hidden = NO;
}

-(void)cancelAddDevice
{
    addDeviceView.hidden = YES;
}

-(void)sureAddDevice
{
    NSString *name = addDeviceView.nameTypeTf.text;
    NSString *veh = addDeviceView.vehicleTf.text;
    NSString *trouble = addDeviceView.troubleTf.text;
    if (name.length == 0 || veh.length == 0 || trouble.length == 0) {
        [self showLabel:@"请先填写所有信息"];
        return;
    }
    addDeviceView.hidden = YES;
    NSDictionary *deviceDic = [NSDictionary dictionaryWithObjectsAndKeys:name,@"name",veh,@"veh",trouble,@"trouble", nil];
    [_deviceData addObject:deviceDic];
    addOrderView.deviceTb.tag = 3;
    [addOrderView.deviceTb reloadData];
    
    
}

-(void)hideConnectView
{
    
    connectView.hidden = YES;
}

#pragma mark --- UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        return _customerData.count;
    }else if (tableView.tag == 2)
    {
        return _connectData.count;
    }else
    {
        return _deviceData.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        return 30;
    }else if(tableView.tag == 2)
    {
        return 40;
    }else
    {
        return 70;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        NSString *cellId = [NSString stringWithFormat:@"cell%ld",(long)indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dataDic = _customerData[indexPath.row];
        cell.textLabel.text = [dataDic objectForKey:@"CustomerName"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }else if (tableView.tag == 2)
    {
        NSString *cellId = [NSString stringWithFormat:@"cell1%ld",(long)indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dataDic = _connectData[indexPath.row];
        NSString *name = [dataDic objectForKey:@"contact_name"];
        cell.textLabel.text = [name stringByAppendingString:[NSString stringWithFormat:@"   %@",[dataDic objectForKey:@"contact_phone"]]];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }else
    {
        NSString *cellId = [NSString stringWithFormat:@"cell2%ld",(long)indexPath.row];
        AddDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[AddDeviceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dataDic = _deviceData[indexPath.row];
        cell.nameLb.text = [dataDic objectForKey:@"name"];
        cell.vehLb.text = [dataDic objectForKey:@"veh"];
        cell.troubleLb.text = [dataDic objectForKey:@"trouble"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 3) {
        return;
    }
    if (tableView.tag == 1) {
        addOrderView.customerTb.hidden = YES;
        [addOrderView.customerTF resignFirstResponder];
        NSDictionary *dataDic = _customerData[indexPath.row];
        addOrderView.customerTF.text = [dataDic objectForKey:@"CustomerName"];
        NSArray *connectArr = [NSArray arrayWithArray:[dataDic objectForKey:@"CustomerList"]];
        _connectData = [NSMutableArray arrayWithArray:connectArr];
        connectView.hidden = NO;
        if (_connectData.count == 0) {
            connectView.noConnectLb.hidden = NO;
        }else
        {
            connectView.noConnectLb.hidden = YES;
            connectView.connectTb.tag = 2;
            [connectView.connectTb reloadData];
        }
        
    }else if(tableView.tag == 2)
    {
        connectView.hidden = YES;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        addOrderView.connectLb.text = cell.textLabel.text;
    }
}


#pragma  ---- 输入框

-(void)tfTouch:(MainTextField *)tf
{
    textField = tf;
}

-(void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary *userInfo = noti.userInfo;
    CGFloat keyboardH = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat tfH = textField.frame.origin.y + 150;
    CGFloat h = SCREEN_HEIGHE - tfH;
    CGFloat off = h - keyboardH;
    double duration   = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (off < 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0, off, SCREEN_WIDTH, SCREEN_HEIGHE);
        }];
    }
    [addOrderView.customerTb mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(SCREEN_HEIGHE - keyboardH - 108));
    }];
}

-(void)keyboardWillHide:(NSNotification *)noti
{
    NSDictionary *userInfo = noti.userInfo;
    double duration   = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHE);
    }];
    [addOrderView.customerTb mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(SCREEN_HEIGHE - 116));
    }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [addOrderView.customerTF resignFirstResponder];
    [addDeviceView.nameTypeTf resignFirstResponder];
    [addDeviceView.vehicleTf resignFirstResponder];
    [addDeviceView.troubleTf resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [addOrderView.customerTF resignFirstResponder];
    return YES;
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
