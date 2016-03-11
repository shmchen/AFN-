//
//  AFHttpTool.h
//  AFNetWorking
//
//  Created by 123456 on 16/3/11.
//  Copyright © 2016年 123456. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "Singleton.h"

typedef enum{
    NetStatusNotReachable,
    NetStatusReachableViaWiFi,
    NetStatusReachableViaWWAN,
    NetStatusReachabilityUnknown
} NetStatus;

typedef void(^SuccessBlock)(id responseObject);
typedef void(^FailureBlock)(NSError *error);

@interface AFHttpTool : NSObject
interfaceSingleton(AFHttpTool);

/**
 *  返回一个初始化的网络请求类
 */
-(AFHTTPSessionManager *)baseHttpRequest;

/**
 *  创建一个基于API接口baseUrl地址的请求类
 */
- (AFHTTPSessionManager *)baseHttpRequestWithBaseUrl;

/**
 *  监测网络是否可用
 */
- (BOOL)isConnectionAvailable;

/**
 *  取消当前网络请求
 */
- (void)cancelCurrentOperation;

/**
 *  取消所有请求
 */
- (void)cancelAllOperations;

/**
 *   传一个基于api相对路径的地址
 */
-(NSURLSessionDataTask *)getWithPath:(NSString *)api params:(NSDictionary *)params successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *   传一个基于api相对路径的地址
 */
-(NSURLSessionDataTask *)postWithPath:(NSString *)api params:(NSDictionary *)params success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

/**
*   传一个绝对路径的网址
 */
-(NSURLSessionDataTask *)getWithFullPath:(NSString *)api params:(NSDictionary *)params successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

/**
 *   传一个绝对路径的网址
 */
-(NSURLSessionDataTask *)postWithFullPath:(NSString *)api params:(NSDictionary *)params success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

/**
 *  把字典转成JSON字符串
 */
-(NSString *)jsonStirngWithDic:(NSDictionary *)dictionary;
@end
