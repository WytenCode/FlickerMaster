//
//  SomeService.m
//  LCTUrlProj
//
//  Created by Владимир on 16/04/2019.
//  Copyright © 2019 Владимир. All rights reserved.
//

#import "NetworkService.h"
#import "NetworkHelper.h"


@interface NetworkService ()

@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSData *resumeData;

@end

@implementation NetworkService

- (void)configureUrlSessionWithParams:(NSDictionary *)params
{
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // Настравиваем Session Configuration
    [sessionConfiguration setAllowsCellularAccess:YES];
    if (params)
    {
        [sessionConfiguration setHTTPAdditionalHeaders:params];//@{ @"Accept" : @"application/json" }];
    }
    else
    {
        [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
    }
    
    // Создаем сессию
    self.urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
}

- (void)startImageLoading
{
    if (!self.urlSession)
    {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    }
    self.downloadTask = [self.urlSession downloadTaskWithURL:[NSURL URLWithString:@"https://upload.wikimedia.org/wikipedia/commons/4/4e/Pleiades_large.jpg"]];
    /* http://is1.mzstatic.com/image/thumb/Purple2/v4/91/59/e1/9159e1b3-f67c-6c05-0324-d56f4aee156a/source/100x100bb.jpg */
    [self.downloadTask resume];
}

- (void)startImageLoadingWithPath:(NSString *)path
{
    if (!self.urlSession)
    {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    }
    self.downloadTask = [self.urlSession downloadTaskWithURL:[NSURL URLWithString:path]];
    [self.downloadTask resume];
}

- (BOOL)resumeNetworkLoading
{
    if (!self.resumeData)
        return NO;
    
    // Восстанавливаем загрузку с учетом уже загруженных данных
    self.downloadTask = [self.urlSession downloadTaskWithResumeData:self.resumeData];
    [self.downloadTask resume];
    self.resumeData = nil;
    
    return YES;
}

- (void)suspendNetworkLoading
{
    if (!self.downloadTask)
        return;
    
    self.resumeData = nil;
    [self.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
        if (!resumeData)
        {
            return;
        }
        self.resumeData = resumeData;
        [self setDownloadTask:nil];
    }];
}

- (void)findFlickrPhotoWithSearchString:(NSString *)searchSrting
{
    NSString *urlString = [NetworkHelper URLForSearchString:searchSrting];
        
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:15];
    
    NSURLSession *session;
    session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *temp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSArray *arr = [[temp objectForKey:@"photos"] valueForKey:@"photo"];
        //NSDictionary *arrTemp = [arr objectAtIndex:2];
        // Для получение деталей по фото
        // https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
        // example https://farm1.staticflickr.com/2/1418878_1e92283336_m.jpg
        // example https://farm66.staticflickr.com/65535/46898362844_a2dc4b448d.jpg
        // example https://farm66.staticflickr.com/65535/46922203564_e1f4361f77.jpg

        dispatch_async(dispatch_get_main_queue(), ^{
            //NSLog(@"%@",arr);
            [self.output photoInfoReceivedWithArray:arr];
            //[[arr objectAtIndex:4]objectAtIndex:1]// Отсюда отправим сообщение на обновление UI с главного потока
        });
    }];
    [sessionDataTask resume];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSData *data = [NSData dataWithContentsOfURL:location];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionOutput loadingIsDoneWithDataRecieved:data];
    });
    [session finishTasksAndInvalidate];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    double progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionOutput loadingContinuesWithProgress:progress];
    });
}

@end

