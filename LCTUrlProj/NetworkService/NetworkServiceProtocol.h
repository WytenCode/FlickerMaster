//
//  ProtocolsTest.h
//  LCTUrlProj
//
//  Created by Владимир on 16/04/2019.
//  Copyright © 2019 Владимир. All rights reserved.
//

@protocol NetworkServiceOutputProtocol <NSObject>
@optional

- (void)loadingContinuesWithProgress:(double)progress;
- (void)loadingIsDoneWithDataRecieved:(NSData *)dataRecieved;
- (void)photoInfoReceivedWithArray:(NSArray *)array;

@end

@protocol NetworkServiceIntputProtocol <NSObject>
@optional

- (void)configureUrlSessionWithParams:(NSDictionary *)params;
- (void)startImageLoading;
- (void)startImageLoadingWithPath:(NSString *)path;

// Next Step
- (BOOL)resumeNetworkLoading;
- (void)suspendNetworkLoading;

- (void)findFlickrPhotoWithSearchString:(NSString *)searcSrting;

@end

