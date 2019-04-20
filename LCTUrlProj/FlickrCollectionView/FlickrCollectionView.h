//
//  FlickrCollectionView.h
//  LCTUrlProj
//
//  Created by Владимир on 18/04/2019.
//  Copyright © 2019 Владимир. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "NetworkServiceProtocol.h"


@interface FlickrCollectionView : UICollectionView <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, Counting, NetworkServiceOutputProtocol,UICollectionViewDelegate>

@property (nonatomic, weak) id<NetworkServiceIntputProtocol> inpDelegate;
@property (nonatomic ,weak) id<CustomPhoto> customDelegate;

@end

