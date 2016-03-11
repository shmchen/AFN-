//
//  ViewController.m
//  AFNetWorking
//
//  Created by 123456 on 16/2/16.
//  Copyright © 2016年 123456. All rights reserved.
//

#import "ViewController.h"
#import "AFHttpTool.h"

@interface ViewController () <NSXMLParserDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSDictionary *dict = @{@"act":@"index",@"label":@"jkj",@"op":@"index",@"limit":@"20",@"page":@"1"};
    
    NSURLSessionDataTask *task = [[AFHttpTool shareAFHttpTool] getWithPath:@"index/catlist.html" params:dict successBlock:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    NSLog(@"外部 = %@",task);
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
//    [manager GET:@"http://appdev.1zw.com/index/catlist.html" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];

    [[AFHttpTool shareAFHttpTool] cancelCurrentOperation];
    
}

@end
