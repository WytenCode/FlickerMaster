//
//  FlickrCollectionView.m
//  LCTUrlProj
//
//  Created by Владимир on 18/04/2019.
//  Copyright © 2019 Владимир. All rights reserved.
//

#import "FlickrCollectionView.h"
#import "FlickrCollectionViewCell.h"

@interface FlickrCollectionView()

@property (nonatomic, strong) NSArray *dateGrant;
@property (nonatomic, assign) NSInteger testCount;
@property (nonatomic, strong) FlickrCollectionViewCell *curCell;

@end

@implementation FlickrCollectionView

-(void)dealloc
{
    self.dateGrant = nil;
}

-(id)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *myLayout = [[UICollectionViewFlowLayout alloc]init];
    myLayout.itemSize = CGSizeMake(115, 115);
    myLayout.minimumLineSpacing = 5;
    
    self = [super initWithFrame:frame collectionViewLayout:myLayout];
    self.backgroundColor = [UIColor cyanColor];
    self.dataSource = self;
    self.delegate = self;
    self.testCount = 0;
    [self registerClass:[FlickrCollectionViewCell class] forCellWithReuseIdentifier:@"FlickrCollectionViewCell"];
    
    return self;
}

#pragma mark Counting

-(void)setPhotoDataWithArray:(NSArray *)array
{
    self.dateGrant = array;
    [self reloadData];
}

-(void)changeCellImageWithImage:(UIImage *)image
{
    if (self.curCell == nil)
        return;
    [self.curCell setImageWithImage:image];
}

#pragma mark UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dateGrant.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    FlickrCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FlickrCollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor purpleColor];
    NSDictionary *dictionary = [self.dateGrant objectAtIndex:indexPath.row];
    NSString *newString = [self collectUrlTargetWithDict:dictionary];
    [cell bringPictureWithString:newString];
    return cell;
}

-(NSString *)collectUrlTargetWithDict:(NSDictionary *)dict
{
    NSInteger farmId = [[dict valueForKey:@"farm"] integerValue];
    NSString *server = [dict valueForKey:@"server"];
    NSString *locId = [dict valueForKey:@"id"];
    NSString *secret = [dict valueForKey:@"secret"];
    return [NSString stringWithFormat:@"https://farm%ld.staticflickr.com/%@/%@_%@.jpg", farmId, server, locId, secret];
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    FlickrCollectionViewCell *tmpCell = [self cellForItemAtIndexPath:indexPath];
    self.curCell = tmpCell;
    [self.customDelegate runImageOnCustomControllerWithImage:[tmpCell giveCellImage]];
}

- (void)loadingIsDoneWithDataRecieved:(NSData *)dataRecieved
{
    //NSLog(@"FCV got data");
}

- (void)loadingContinuesWithProgress:(double)progress
{
    //NSLog(@" FCV Easy");
}

@end
