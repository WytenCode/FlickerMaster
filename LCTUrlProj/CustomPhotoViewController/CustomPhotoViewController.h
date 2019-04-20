//
//  CustomPhotoViewController.h
//  LCTUrlProj
//
//  Created by Владимир on 20/04/2019.
//  Copyright © 2019 Владимир. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlProjectProtocols.h"

@interface  MyButtons : UIButton
@property (nonatomic, assign) NSString *filterToUse;
-(void)setFilterToUse:(NSString *)filterToUse;
@end

@interface CustomPhotoViewController : UIViewController

@property (nonatomic, weak) id<CustomPhoto> delegate;

-(void)setupImageViewWithImage:(UIImage *)image;

@end


