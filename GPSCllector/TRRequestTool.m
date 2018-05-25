//
//  TRRequestTool.m
//  GPSCllector
//
//  Created by 图软 on 2017/9/25.
//  Copyright © 2017年 LCR. All rights reserved.
//

#import "TRRequestTool.h"
#import <AFNetworking.h>
#import "AFNetworking.h"

@implementation TRRequestTool
{
    AFHTTPSessionManager *manager;
}

+(TRRequestTool *)shareManager
{
    static TRRequestTool *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TRRequestTool alloc]init];
    });
    return manager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer     = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSMutableSet *contentTypes    = [[NSMutableSet alloc]initWithSet:manager.responseSerializer.acceptableContentTypes];
        [contentTypes addObject:@"text/html"];
        [contentTypes addObject:@"application/json"];
        [contentTypes addObject:@"charset=utf-8"];
        [contentTypes addObject:@"text/json"];
        [contentTypes addObject:@"text/javascript"];
        manager.responseSerializer.acceptableContentTypes = contentTypes;
    }
    return self;
}

-(void)DataUrl:(NSString *)url withParameters:(NSDictionary *)parameters result:(void (^)(id, NSError *))cb
{
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];//监听网络
    
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //  未知网络
        if (status == -1) {
            //[self showWarnView:@"网络连接失败"];
            return ;
        }
        //  无连接
        if (status == 0) {
            //[self showWarnView:@"网络连接失败"];
            return;
        }
        //  手机网络
        if (status == 1 || status == 2) {
            
            [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (responseObject) {
                    cb(responseObject,nil);
                }else
                {
                    return ;
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSString *errStr = [NSString stringWithFormat:@"%@",error];
                NSLog(@"%@",errStr);
                cb(nil,error);
            }];
        }
    }];
    
}


@end
