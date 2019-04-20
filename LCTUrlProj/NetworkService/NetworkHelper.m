//
//  NetworkHelper.m
//  LCTUrlProj
//
//  Created by Владимир on 16/04/2019.
//  Copyright © 2019 Владимир. All rights reserved.
//

#import "NetworkHelper.h"

@implementation NetworkHelper

+ (NSString *)URLForSearchString:(NSString *)searchString
{
    NSString *APIKey = @"5553e0626e5d3a905df9a76df1383d98";
    return [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=24&format=json&nojsoncallback=1&page=1", APIKey, searchString];
}

@end
