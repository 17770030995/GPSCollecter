//
//  AddLineViewController.m
//  GPSCllector
//
//  Created by 图软 on 16/8/27.
//  Copyright © 2016年 LCR. All rights reserved.
//

#import "AddLineViewController.h"
#import "MBProgressHUD.h"

@interface AddLineViewController ()
{
    NSInteger type;
    NSString *addedStopName;
    NSInteger insertNum;
}

@property(nonatomic,strong)NSMutableArray *upStops;
@property(nonatomic,strong)NSMutableArray *downStops;

@end

@implementation AddLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    addLineView = [[AddLineView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHE)];
    [self.view addSubview:addLineView];
    addLineView.stopsTableView.delegate = self;
    addLineView.stopsTableView.dataSource = self;
    addLineView.inputTF.delegate = self;
    _upStops = [NSMutableArray array];
    _downStops = [NSMutableArray array];
    type = 1;
    addLineView.titleLb.text = [NSString stringWithFormat:@"编辑站点(%@)",_lineName];
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    NSArray *dataArr = [de objectForKey:@"dataArr"];
    for (NSDictionary *dic in dataArr) {
        if ([[dic objectForKey:@"lineName"] isEqualToString:_lineName]) {
            _upStops = [dic objectForKey:@"upStops"];
            _downStops = [dic objectForKey:@"downStops"];
        }
    }
    NSInteger count= _upStops.count;
    addLineView.kindAndNumLb.text = [NSString stringWithFormat:@"上行%ld个",count];
    addLineView.explainLb.text = [NSString stringWithFormat:@"点击站点改变插入位置(下次插入位置:%ld)",count + 1];
    insertNum = count;
    [self addBtnActions];
}

-(void)addBtnActions
{
    [addLineView.backBtn addTarget:self
                            action:@selector(back)
                  forControlEvents:UIControlEventTouchUpInside];
    [addLineView.saveBtn addTarget:self
                            action:@selector(save)
                  forControlEvents:UIControlEventTouchUpInside];
    [addLineView.changeBtn addTarget:self
                              action:@selector(changeDirection)
                    forControlEvents:UIControlEventTouchUpInside];
}


//按钮响应事件
//返回
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

//保存站点
-(void)save
{
    if (_lineName.length == 0) {
        [self showLabel:@"请先选择线路或添加新的线路!"];
        return;
    }
    //[addLineView.inputTF resignFirstResponder];
    if (addLineView.inputTF.text.length == 0) {
        [self showLabel:@"站点名不能为空!"];
        return;
    }
    addedStopName = addLineView.inputTF.text;
    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
    NSArray *dataArr = [de objectForKey:@"dataArr"];
    NSDictionary *changeLineDic = [NSDictionary dictionary];
    NSInteger num;
    for (NSInteger i = 0;i < dataArr.count;i ++) {
        NSDictionary *dic = dataArr[i];
        if ([[dic objectForKey:@"lineName"] isEqualToString:_lineName]) {
            changeLineDic = dic;
            num = i;
            break;
        }
    }
    NSMutableArray *changeDataArr = [NSMutableArray arrayWithArray:dataArr];
    [changeDataArr removeObjectAtIndex:num];
    if (type == 1) {
        NSMutableArray *changeStopsArr = [NSMutableArray arrayWithArray:_upStops];
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
        NSDictionary *newStopDic = [NSDictionary dictionaryWithObjectsAndKeys:addedStopName,@"stopName",inDic,@"inDic",outDic,@"outDic", nil];
        NSLog(@"%ld",insertNum);
        [changeStopsArr insertObject:newStopDic atIndex:insertNum];
        
        NSDictionary *newLineDic = [NSDictionary dictionaryWithObjectsAndKeys:_lineName,@"lineName",changeStopsArr,@"upStops",[changeLineDic objectForKey:@"downStops"],@"downStops", nil];
        [changeDataArr insertObject:newLineDic atIndex:num];
        [de setObject:changeDataArr forKey:@"dataArr"];
        [de synchronize];
        _upStops = changeStopsArr;
        NSInteger count = _upStops.count;
        addLineView.kindAndNumLb.text = [NSString stringWithFormat:@"上行%ld个",count];
        insertNum++;
        addLineView.explainLb.text = [NSString stringWithFormat:@"点击站点改变插入位置(下次插入位置:%ld)",insertNum + 1];
        [addLineView.stopsTableView reloadData];
    }else
    {
        NSMutableArray *changeStopsArr = [NSMutableArray arrayWithArray:_downStops];
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
        NSDictionary *newStopDic = [NSDictionary dictionaryWithObjectsAndKeys:addedStopName,@"stopName",inDic,@"inDic",outDic,@"outDic", nil];
        [changeStopsArr insertObject:newStopDic atIndex:insertNum];
        
        NSDictionary *newLineDic = [NSDictionary dictionaryWithObjectsAndKeys:_lineName,@"lineName",[changeLineDic objectForKey:@"upStops"],@"upStops",changeStopsArr,@"downStops", nil];
        [changeDataArr insertObject:newLineDic atIndex:num];
        [de setObject:changeDataArr forKey:@"dataArr"];
        [de synchronize];
        _downStops = changeStopsArr;
        NSInteger count = _downStops.count;
        addLineView.kindAndNumLb.text = [NSString stringWithFormat:@"下行%ld个",count];
        insertNum++;
        addLineView.explainLb.text = [NSString stringWithFormat:@"点击站点改变插入位置(下次插入位置:%ld)",insertNum + 1];
        [addLineView.stopsTableView reloadData];
    }
    addLineView.inputTF.text = nil;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshData" object:nil];
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

//切换方向
-(void)changeDirection
{
    [addLineView.inputTF resignFirstResponder];
    if (type == 1) {
        if (_upStops.count > 0 && _downStops.count == 0) {
    
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否根据上行站点自动生成下行站点?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSMutableArray *tempArr = [NSMutableArray array];
                NSInteger count1 = _upStops.count;
                for (NSInteger i = count1 - 1; i >= 0; i --) {
                    NSDictionary *dic = _upStops[i];
                    [tempArr addObject:dic];
                }
                _downStops = tempArr;
                type =2;
                NSInteger count = _downStops.count;
                addLineView.kindAndNumLb.text = [NSString stringWithFormat:@"下行%ld个",count];
                addLineView.explainLb.text = [NSString stringWithFormat:@"点击站点改变插入位置(下次插入位置:%ld)",count + 1];
                insertNum = count;
                [addLineView.stopsTableView reloadData];
                for (NSInteger i = 0; i < count; i ++) {
                    UITableViewCell *cell = [addLineView.stopsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    cell.backgroundColor = [UIColor whiteColor];
                }
                
                //保存在本地(以免后面删除找不到数据)
                NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
                NSArray *dataArr = [de objectForKey:@"dataArr"];
                NSDictionary *changeLineDic = [NSDictionary dictionary];
                NSInteger num;
                for (NSInteger i = 0;i < dataArr.count;i ++) {
                    NSDictionary *dic = dataArr[i];
                    if ([[dic objectForKey:@"lineName"] isEqualToString:_lineName]) {
                        changeLineDic = dic;
                        num = i;
                        break;
                    }
                }
                NSMutableArray *changeDataArr = [NSMutableArray arrayWithArray:dataArr];
                NSDictionary *newLineDic = [NSDictionary dictionaryWithObjectsAndKeys:_lineName,@"lineName",[changeLineDic objectForKey:@"upStops"],@"upStops",_downStops,@"downStops", nil];
                [changeDataArr replaceObjectAtIndex:num withObject:newLineDic];
                [de setObject:changeDataArr forKey:@"dataArr"];
                [de synchronize];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshData" object:nil];
                
                return ;
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                return ;
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        type =2;
        NSInteger count = _downStops.count;
        addLineView.kindAndNumLb.text = [NSString stringWithFormat:@"下行%ld个",count];
        addLineView.explainLb.text = [NSString stringWithFormat:@"点击站点改变插入位置(下次插入位置:%ld)",count + 1];
        insertNum = count;
        [addLineView.stopsTableView reloadData];
        for (NSInteger i = 0; i < count; i ++) {
            UITableViewCell *cell = [addLineView.stopsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.backgroundColor = [UIColor whiteColor];
        }
        
    }else
    {
        if (_upStops.count == 0 && _downStops.count > 0) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否根据下行站点自动生成上行站点?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSMutableArray *tempArr = [NSMutableArray array];
                NSInteger count1 = _downStops.count;
                for (NSInteger i = count1 - 1; i >= 0; i --) {
                    NSDictionary *dic = _downStops[i];
                    [tempArr addObject:dic];
                }
                _upStops = tempArr;
                type =1;
                NSInteger count = _upStops.count;
                addLineView.kindAndNumLb.text = [NSString stringWithFormat:@"上行%ld个",count];
                addLineView.explainLb.text = [NSString stringWithFormat:@"点击站点改变插入位置(下次插入位置:%ld)",count + 1];
                insertNum = count;
                [addLineView.stopsTableView reloadData];
                for (NSInteger i = 0; i < count; i ++) {
                    UITableViewCell *cell = [addLineView.stopsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    cell.backgroundColor = [UIColor whiteColor];
                }
                
                //保存在本地(以免后面删除找不到数据)
                NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
                NSArray *dataArr = [de objectForKey:@"dataArr"];
                NSDictionary *changeLineDic = [NSDictionary dictionary];
                NSInteger num;
                for (NSInteger i = 0;i < dataArr.count;i ++) {
                    NSDictionary *dic = dataArr[i];
                    if ([[dic objectForKey:@"lineName"] isEqualToString:_lineName]) {
                        changeLineDic = dic;
                        num = i;
                        break;
                    }
                }
                NSMutableArray *changeDataArr = [NSMutableArray arrayWithArray:dataArr];
                NSDictionary *newLineDic = [NSDictionary dictionaryWithObjectsAndKeys:_lineName,@"lineName",_upStops,@"upStops",[changeLineDic objectForKey:@"downStops"],@"downStops", nil];
                [changeDataArr replaceObjectAtIndex:num withObject:newLineDic];
                [de setObject:changeDataArr forKey:@"dataArr"];
                [de synchronize];
                NSLog(@"%@",newLineDic);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshData" object:nil];
                return ;
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                return ;
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        type = 1;
        NSInteger count = _upStops.count;
        addLineView.kindAndNumLb.text = [NSString stringWithFormat:@"上行%ld个",count];
        addLineView.explainLb.text = [NSString stringWithFormat:@"点击站点改变插入位置(下次插入位置:%ld)",count + 1];
        insertNum = count;
        [addLineView.stopsTableView reloadData];
        for (NSInteger i = 0; i < count; i ++) {
            UITableViewCell *cell = [addLineView.stopsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.backgroundColor = [UIColor whiteColor];
        }
    }
}

#pragma mark --- UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (type == 1) {
        return _upStops.count;
    }else
    {
        return _downStops.count;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    if (type == 1) {
        NSInteger count = _upStops.count;
        NSInteger index = count - indexPath.row;
        NSDictionary *stopDic = _upStops[index - 1];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
//        if (insertNum != indexPath.row) {
//            cell.backgroundColor = [UIColor whiteColor];
//        }else
//        {
//            cell.backgroundColor = [UIColor yellowColor];
//        }
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.textLabel.text = [NSString stringWithFormat:@"%ld  %@",index,[stopDic objectForKey:@"stopName"]];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = UIColorFromRGB(0x222222);
        return cell;
    }else
    {
        NSInteger count = _downStops.count;
        NSInteger index = count - indexPath.row;
        NSDictionary *stopDic = _downStops[index - 1];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [NSString stringWithFormat:@"%ld  %@",index,[stopDic objectForKey:@"stopName"]];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = UIColorFromRGB(0x222222);
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSInteger count;
    if (type == 1) {
        count = _upStops.count;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor yellowColor];
        for (NSInteger i = 0; i < count; i ++) {
            if (i != indexPath.row) {
                UITableViewCell *cell2 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell2.backgroundColor = [UIColor whiteColor];
            }
        }
    }else
    {
        count = _downStops.count;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor yellowColor];
        for (NSInteger i = 0; i < count; i ++) {
            if (i != indexPath.row) {
                UITableViewCell *cell2 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell2.backgroundColor = [UIColor whiteColor];
            }
        }

    }
    
    NSInteger index = count - indexPath.row;
    insertNum = index;
    NSLog(@"%ld",insertNum);
    addLineView.explainLb.text = [NSString stringWithFormat:@"点击站点改变插入位置(下次插入位置:%ld)",index + 1];
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定删除当前站点数据?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    
        NSInteger num = 0;
        NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
        NSArray *dataArr = [de objectForKey:@"dataArr"];
        NSDictionary * lineDic = [NSDictionary dictionary];
        for (NSInteger i = 0;i < dataArr.count;i++) {
            NSDictionary *Dic = dataArr[i];
            if ([[Dic objectForKey:@"lineName"] isEqualToString:_lineName]) {
                lineDic = Dic;
                num = i;
                break;
            }
        }
        NSMutableArray *changeDataArr = [NSMutableArray arrayWithArray:dataArr];
        if (type == 1) {
            NSInteger count = _upStops.count;
            NSInteger indexth = count - indexPath.row;
            NSDictionary *stopDictionary = _upStops[indexth - 1];
            NSString *stopName = [stopDictionary objectForKey:@"stopName"];
            NSMutableArray *upStops = [NSMutableArray arrayWithArray:[lineDic objectForKey:@"upStops"]];
            NSInteger index;
            for (NSInteger i = 0;i < upStops.count;i ++) {
                NSDictionary *stopDic = upStops[i];
                if ([[stopDic objectForKey:@"stopName"] isEqualToString:stopName]) {
                    index = i;
                    break;
                }
            }
            [upStops removeObjectAtIndex:index];
            NSDictionary *newLineDic = [NSDictionary dictionaryWithObjectsAndKeys:_lineName,@"lineName",upStops,@"upStops",[lineDic objectForKey:@"downStops"],@"downStops", nil];
            [changeDataArr replaceObjectAtIndex:num withObject:newLineDic];
            _upStops = upStops;
            NSInteger count1 = _upStops.count;
            addLineView.explainLb.text = [NSString stringWithFormat:@"点击站点改变插入位置(下次插入位置:%ld)",count1 + 1];
            addLineView.kindAndNumLb.text = [NSString stringWithFormat:@"上行%ld个",count1];
            insertNum = count1;
            [addLineView.stopsTableView reloadData];
            for (NSInteger i = 0; i < count1; i ++) {
                UITableViewCell *cell = [addLineView.stopsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.backgroundColor = [UIColor whiteColor];
            }
        }else
        {
            NSInteger count = _downStops.count;
            NSInteger indexth = count - indexPath.row;
            NSDictionary *stopDictionary = _downStops[indexth - 1];
            NSString *stopName = [stopDictionary objectForKey:@"stopName"];
            NSMutableArray *downStops = [NSMutableArray arrayWithArray:[lineDic objectForKey:@"downStops"]];
            NSInteger index;
            for (NSInteger i = 0;i < downStops.count;i ++) {
                NSDictionary *stopDic = downStops[i];
                if ([[stopDic objectForKey:@"stopName"] isEqualToString:stopName]) {
                    index = i;
                    break;
                }
            }
            [downStops removeObjectAtIndex:index];
            NSDictionary *newLineDic = [NSDictionary dictionaryWithObjectsAndKeys:_lineName,@"lineName",[lineDic objectForKey:@"upStops"],@"upStops",downStops,@"downStops", nil];
            [changeDataArr replaceObjectAtIndex:num withObject:newLineDic];
            _downStops = downStops;
            NSInteger count1 = _downStops.count;
            addLineView.explainLb.text = [NSString stringWithFormat:@"点击站点改变插入位置(下次插入位置:%ld)",count1 + 1];
            addLineView.kindAndNumLb.text = [NSString stringWithFormat:@"下行%ld个",count1];
            insertNum = count1;
            [addLineView.stopsTableView reloadData];
            for (NSInteger i = 0; i < count1; i ++) {
                UITableViewCell *cell = [addLineView.stopsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.backgroundColor = [UIColor whiteColor];
            }
        }
        
        NSArray *data = [NSArray arrayWithArray:changeDataArr];
        [de setObject:data forKey:@"dataArr"];
        [de synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshData2" object:nil];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        return ;
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;

}


#pragma mark --- UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    addedStopName = textField.text;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [addLineView.inputTF resignFirstResponder];
    //addedStopName = textField.text;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [addLineView.inputTF resignFirstResponder];
    return YES;
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
