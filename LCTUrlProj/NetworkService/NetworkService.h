//
//  SomeService.h
//  LCTUrlProj
//
//  Created by Владимир on 16/04/2019.
//  Copyright © 2019 Владимир. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkServiceProtocol.h"


@interface NetworkService : NSObject<NetworkServiceIntputProtocol, NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@property (nonatomic, weak) id<NetworkServiceOutputProtocol> output; /**< Делегат внешних событий */
@property (nonatomic, weak) id<NetworkServiceOutputProtocol> collectionOutput; /**< Делегат внешних событий */

@end
