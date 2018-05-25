//
//  CodeViewController.m
//  GPSCllector
//
//  Created by 图软 on 2017/8/31.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import "CodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "RedView.h"
#import <CoreMotion/CoreMotion.h>
#define WIDTH  [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height
@interface CodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    BOOL lightOn;//电筒状态
    AVCaptureSession * session;//输入输出的中间桥梁
}
@property(nonatomic) CGRect rectOfInterest;
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;
@property(nonatomic)AVCaptureDevice *device;
@property(nonatomic)AVCaptureDevice *lightDevice;//手电筒
@property(nonatomic, strong) UIButton *lightBtn;
@property (nonatomic)UIView *focusView;
@property(nonatomic,strong)NSString *string;
@end

@implementation CodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:0.88f green:0.88f blue:0.88f alpha:1.00f];
    // Do any additional setup after loading the view, typically from a nib.
    //获取摄像设备
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //获取手电筒
    self.lightDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    lightOn = NO;
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [session addInput:input];
    [session addOutput:output];
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    //这里设置有效区
    //    output.rectOfInterest=CGRectMake(0,0,1, 1);
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
    self.previewLayer.frame = CGRectMake(0,0, WIDTH ,HEIGHT);
    
    
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self.view.layer addSublayer:self.previewLayer];
    
    
    RedView *view = [[RedView alloc]initWithFrame:CGRectMake(30, HEIGHT/2,0, 0)];
    
    
    [self.view addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(view.frame)-60, 30, 30)];
    imageView.image = [UIImage imageNamed:@"左上"];
    [self.view addSubview:imageView];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(view.frame)+30, 30, 30)];
    imageView2.image = [UIImage imageNamed:@"左下"];
    [self.view addSubview:imageView2];
    
    UIImageView *imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 55, CGRectGetMaxY(view.frame)-60, 30, 30)];
    imageView3.image = [UIImage imageNamed:@"右上"];
    [self.view addSubview:imageView3];
    
    UIImageView *imageView4 = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 55, CGRectGetMaxY(view.frame)+30, 30, 30)];
    imageView4.image = [UIImage imageNamed:@"右下"];
    [self.view addSubview:imageView4];
    //开始捕获
    [session startRunning];
    
    _focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _focusView.layer.borderWidth = 1.0;
    _focusView.layer.cornerRadius = 40;
    _focusView.layer.borderColor =[UIColor greenColor].CGColor;
    _focusView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_focusView];
    _focusView.hidden = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    
    UILabel *lable = [[UILabel alloc]init];
    lable.frame = CGRectMake(30, 100, [UIScreen mainScreen].bounds.size.width -60, 30);
    lable.text = @"设备条形码";
    lable.textColor = [UIColor redColor];
//    self.blockEmail2 = ^void (NSString *email){
//        lable.text = email;
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//    };
    lable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lable];
    
    _lightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lightBtn.frame = CGRectMake(10, HEIGHT - 50, 100, 35);
    [_lightBtn setTitle:@"打开手电筒" forState:UIControlStateNormal];
    _lightBtn.backgroundColor = UIColorFromRGB(0xf3f3f3);
    [_lightBtn setTitleColor:UIColorFromRGB(0x2c2c2c) forState:UIControlStateNormal];
    _lightBtn.layer.cornerRadius = 6;
    _lightBtn.layer.masksToBounds = YES;
    [_lightBtn addTarget:self action:@selector(openLight) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_lightBtn];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(WIDTH - 65, HEIGHT - 50, 50, 35);
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    backBtn.backgroundColor = UIColorFromRGB(0xf3f3f3);
    [backBtn setTitleColor:UIColorFromRGB(0x2c2c2c) forState:UIControlStateNormal];
    backBtn.layer.cornerRadius = 6;
    backBtn.layer.masksToBounds = YES;
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)openLight
{
    lightOn = !lightOn;
    if (lightOn) {
        [self turnOn];
        [_lightBtn setTitle:@"关闭手电筒" forState:UIControlStateNormal];
    }else
    {
        [self turnOff];
        [_lightBtn setTitle:@"打开手电筒" forState:UIControlStateNormal];
    }
}

-(void)turnOn
{
    [_lightDevice lockForConfiguration:nil];
    
    [_lightDevice setTorchMode:AVCaptureTorchModeOn];
    
    [_lightDevice unlockForConfiguration];
}

-(void)turnOff
{
    [_lightDevice lockForConfiguration:nil];
    
    [_lightDevice setTorchMode:AVCaptureTorchModeOff];
    
    [_lightDevice unlockForConfiguration];
}
- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}
- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.view.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        _focusView.center = point;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _focusView.hidden = YES;
            }];
        }];
    }
    
}
-(void)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects.count>0) {
        //[session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        self.string = metadataObject.stringValue;
        NSLog(@"%@",self.string);
        _blockEmail2(self.string);
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }
}

@end
