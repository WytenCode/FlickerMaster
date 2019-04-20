//
//  FlickrCollectionViewCell.m
//  LCTUrlProj
//
//  Created by Владимир on 18/04/2019.
//  Copyright © 2019 Владимир. All rights reserved.
//

#import "FlickrCollectionViewCell.h"

@interface  FlickrCollectionViewCell()

@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) NetworkService *networkService;

@end

@implementation FlickrCollectionViewCell

-(void)dealloc
{
    [self.cellImageView removeFromSuperview];
    self.cellImageView = nil;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.cellImageView = [UIImageView new];
    [self addSubview:self.cellImageView];
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.cellImageView.frame = self.contentView.frame;
}

-(void)bringPictureWithString:(NSString *)string
{
    self.networkService = [NetworkService new];
    self.networkService.collectionOutput = self;
    [self.networkService configureUrlSessionWithParams:nil];
    self.cellDelegate = self.networkService;
    [self.cellDelegate startImageLoadingWithPath:string];
}

-(UIImage *)giveCellImage
{
    return self.cellImageView.image;
}

-(void)setImageWithImage:(UIImage *)image
{
    [self.cellImageView setImage:image];
    //NSLog(@"got new photo");
}


#pragma mark - NetworkOutputProtocol
- (void)loadingIsDoneWithDataRecieved:(NSData *)dataRecieved
{
    self.cellImageView.image = nil;
    [self.cellImageView setImage:[UIImage imageWithData:dataRecieved]];
    //NSLog(@"cell got picture");
}

- (void)loadingContinuesWithProgress:(double)progress
{
    //NSLog(@" cell Easy");
}

@end
