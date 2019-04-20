//
//  ViewController.h
//  LCTUrlProj
//
//  Created by Владимир on 21/04/2019.
//  Copyright © 2019 Владимир. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPhotoViewController.h"
#import "UrlProjectProtocols.h"


@interface ViewController : UIViewController <UISearchBarDelegate, UITextFieldDelegate, CustomPhoto>

@property (nonatomic, weak) id<Counting> delegate;

@end

