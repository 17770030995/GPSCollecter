//
//  ProductsViewController.m
//  GPSCllector
//
//  Created by 图软 on 2017/9/19.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import "ProductsViewController.h"
#import "ProductCell.h"
#import "RecordProCell.h"

@interface ProductsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    [self initUI];
    if (self.dataArr.count == 0) {
        if (_isRecord) {
            [self showLabel:@"当前订单记录没有维修过的设备"];
            return;
        }
        [self showLabel:@"当前订单暂无设备需要维修"];
        return;
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView reloadData];
    
}

-(void)initUI
{
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    UIView * headerView = [[UIView alloc]init];
    headerView.backgroundColor = MAINHEADERCOLOR;
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@64);
    }];
    UILabel * titleLb = [[UILabel alloc]init];
    titleLb.font = [UIFont systemFontOfSize:17];
    titleLb.text = @"订单设备";
    titleLb.textColor = UIColorFromRGB(0xffffff);
    titleLb.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(27);
        make.centerX.equalTo(headerView.mas_centerX);
        make.width.equalTo(@150);
        make.height.equalTo(@30);
    }];
    UIButton * _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [_backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateSelected];
    _backBtn.backgroundColor = [UIColor clearColor];
    [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_backBtn];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_top);
        make.height.equalTo(titleLb.mas_height);
        make.left.equalTo(headerView.mas_left).offset(12);
        make.width.equalTo(@40);
    }];
    
    _tableView = [[UITableView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---- UITableVIewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataArr[indexPath.row];
    CGFloat height = 0.0;
    if (![[dic objectForKey:@"faultdescription"] isEqual:[NSNull null]]) {
        NSString *str = [dic objectForKey:@"faultdescription"];
        height = [self textHeight:str];
    }
    NSLog(@"%f",height);
    if (height < 30) {
        if (_isRecord) {
            return 210;
        }else
        {
            return 120;
        }
        
    }else
    {
        if (_isRecord) {
            return height + 180;
        }else
        {
            return height + 90;
        }
        
    }
}

-(CGFloat)textHeight:(NSString *)str
{
    CGFloat width = SCREEN_WIDTH - 120;
    CGRect rect =[str boundingRectWithSize:CGSizeMake(width, 19999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];//计算字符串所占的矩形区域的大小
    return rect.size.height;//返回高度
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIden = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    if (!_isRecord) {
        ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
        if (cell == nil) {
            cell = [[ProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
        }
        NSDictionary *dic = self.dataArr[indexPath.row];
        if (![[dic objectForKey:@"productname"] isEqual:[NSNull null]]) {
            cell.nameLb.text = [dic objectForKey:@"productname"];
        }
        if (![[dic objectForKey:@"vehcode"] isEqual:[NSNull null]]) {
            cell.vehcodeLb.text = [dic objectForKey:@"vehcode"];
        }
        if (![[dic objectForKey:@"faultdescription"] isEqual:[NSNull null]]) {
            cell.reasonLb.text = [dic objectForKey:@"faultdescription"];
            CGFloat txtHeight = [self textHeight:[dic objectForKey:@"faultdescription"]];
            if (txtHeight > 30) {
                [cell.reasonLb mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(txtHeight));
                }];
            }
        }
        return cell;
    }else
    {
        RecordProCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
        if (cell == nil) {
            cell = [[RecordProCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
        }
        NSDictionary *dic = self.dataArr[indexPath.row];
        if (![[dic objectForKey:@"productname"] isEqual:[NSNull null]]) {
            cell.nameLb.text = [dic objectForKey:@"productname"];
        }
        if (![[dic objectForKey:@"vehcode"] isEqual:[NSNull null]]) {
            cell.vehcodeLb.text = [dic objectForKey:@"vehcode"];
        }
        if (![[dic objectForKey:@"faultdescription"] isEqual:[NSNull null]]) {
            cell.reasonLb.text = [dic objectForKey:@"faultdescription"];
            CGFloat txtHeight = [self textHeight:[dic objectForKey:@"faultdescription"]];
            if (txtHeight > 30) {
                [cell.reasonLb mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(txtHeight));
                }];
            }
        }
        if (![[dic objectForKey:@"productlist"] isEqual:[NSNull null]]) {
            cell.codeLb.text = [dic objectForKey:@"productlist"];
        }
        if (![[dic objectForKey:@"maintresult"] isEqual:[NSNull null]]) {
            cell.resultLb.text = [dic objectForKey:@"maintresult"];
        }
        if (![[dic objectForKey:@"materialcost"] isEqual:[NSNull null]]) {
            cell.mateCostLb.text = [dic objectForKey:@"materialcost"];
        }
        if (![[dic objectForKey:@"maintenancecost"] isEqual:[NSNull null]]) {
            cell.maintCostLb.text = [dic objectForKey:@"maintenancecost"];
        }
        return cell;
    }
    
    
    
    
    
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
