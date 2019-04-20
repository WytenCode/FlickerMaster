//
//  FlickrCollectionViewCell.h
//  LCTUrlProj
//
//  Created by Владимир on 18/04/2019.
//  Copyright © 2019 Владимир. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkServiceProtocol.h"
#import "NetworkService.h"


@interface FlickrCollectionViewCell : UICollectionViewCell <NetworkServiceOutputProtocol>

@property (nonatomic, weak) id<NetworkServiceIntputProtocol> cellDelegate;

-(void)bringPictureWithString:(NSString *)string;
-(UIImage *)giveCellImage;
-(void)setImageWithImage:(UIImage *)image;

@end

