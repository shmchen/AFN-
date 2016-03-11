//
//  AFHttpTool.m
//  AFNetWorking
//
//  Created by 123456 on 16/3/11.
//  Copyright © 2016年 123456. All rights reserved.
//

#import "AFHttpTool.h"

//最大请求超时时间
#define TIMEOUT 10

//API接口地址
#define KBaseUrl @"http://appdev.1zw.com"

@interface AFHttpTool ()
@property (nonatomic, strong) NSMutableArray *allTasks;
@end

@implementation AFHttpTool
implementationSingleton(AFHttpTool)

- (NSMutableArray *)allTasks
{
    if (_allTasks == nil) {
        _allTasks = [NSMutableArray array];
    }
    return _allTasks;
}

- (NSURLSessionDataTask *)currentDataTask
{
    return (NSURLSessionDataTask *)[[self baseHttpRequest].tasks lastObject];
}

/**
 *  创建一个初始化的请求类
 */
- (AFHTTPSessionManager *)baseHttpRequest
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    return manager;
}

/**
 *  创建一个基于API接口baseUrl地址的请求类
 */
- (AFHTTPSessionManager *)baseHttpRequestWithBaseUrl
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:KBaseUrl] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    return manager;
}

- (BOOL)isConnectionAvailable
{
    AFHTTPSessionManager *manager = [self baseHttpRequest];
    __block NetStatus isExistenceNetwork = -1;
    
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                isExistenceNetwork = NetStatusReachableViaWiFi;
                NSLog(@"WIFI");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                isExistenceNetwork = NetStatusReachableViaWWAN;
                NSLog(@"自带网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                isExistenceNetwork = NetStatusNotReachable;
                NSLog(@"没有网络");
                //没有网络弹窗提示
                if (!isExistenceNetwork) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用,请检查网络连接!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                }
                break;
                
            case AFNetworkReachabilityStatusUnknown:
                isExistenceNetwork = NetStatusReachabilityUnknown;
                NSLog(@"未知网络");
                break;
            default:
                break;
        }
        
    }];
    
    //开始监听
    [manager.reachabilityManager startMonitoring];

    //返回网络枚举值
    return isExistenceNetwork;
}

- (NSURLSessionDataTask *)getWithPath:(NSString *)api params:(NSDictionary *)params successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    AFHTTPSessionManager *manager = [self baseHttpRequestWithBaseUrl];
    NSURLSessionDataTask *currentDataTask = [manager GET:api parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
    
    [self.allTasks addObject:currentDataTask];
    
    return currentDataTask;
}

- (void)postWithPath:(NSString *)api params:(NSDictionary *)params success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    AFHTTPSessionManager *manager = [self baseHttpRequestWithBaseUrl];
    NSURLSessionDataTask *currentDataTask = [manager POST:api parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
    
    [self.allTasks addObject:currentDataTask];
}

- (void)getWithFullPath:(NSString *)api params:(NSDictionary *)params successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock
{
    AFHTTPSessionManager *manager = [self baseHttpRequest];
    NSURLSessionDataTask *currentDataTask = [manager GET:api parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
    
    [self.allTasks addObject:currentDataTask];
}

- (void)postWithFullPath:(NSString *)api params:(NSDictionary *)params success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock
{
    AFHTTPSessionManager *manager = [self baseHttpRequest];
    NSURLSessionDataTask *currentDataTask = [manager POST:api parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
    
    [self.allTasks addObject:currentDataTask];
}

/**
 *  取消所有请求
 */
- (void)cancelAllOperations
{

    [self.allTasks makeObjectsPerformSelector:@selector(cancel)];

}

/**
 *  取消当前网络请求
 */
- (void)cancelCurrentOperation
{
    [[self.allTasks lastObject] cancel];
    
}

/**
 *  对象打包成Json
 */
-(NSString *)jsonStirngWithDic:(NSDictionary *)dictionary
{
    NSError *error=nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error: &error];
    if(!error){
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else {
        return nil;
    }
}

/**
 *  返回完整URL请求地址
 *
 *  @param api 传入基于Api的参数
 *
 *  @return 返回完整URL请求地址
 */
- (NSString *)getFullUrlPath:(NSString *)api
{
    NSMutableString *urlStr = [NSMutableString stringWithString:KBaseUrl];
    
    if (![urlStr hasSuffix:@"/"]) {
        [urlStr appendString:@"/"];
    }
    
    if (api) {
        [urlStr appendFormat:@"%@?",api];
    }
    
    return urlStr;
}
@end
