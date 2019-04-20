//
//  UrlProjectProtocols.h
//  LCTUrlProj
//
//  Created by Владимир on 21/04/2019.
//  Copyright © 2019 Владимир. All rights reserved.
//

#ifndef UrlProjectProtocols_h
#define UrlProjectProtocols_h

@protocol Counting <NSObject>
-(void)setPhotoDataWithArray:(NSArray *)array;
-(void)changeCellImageWithImage:(UIImage *)image;
@end

@protocol CustomPhoto <NSObject>
-(void)runImageOnCustomControllerWithImage:(UIImage *)image;
-(void)getResultPhotoWithImage:(UIImage *)image;
@end

#endif /* UrlProjectProtocols_h */
