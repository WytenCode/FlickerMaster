//
//  Searches+CoreDataProperties.h
//  LCTUrlProj
//
//  Created by Владимир on 20/04/2019.
//  Copyright © 2019 Владимир. All rights reserved.
//
//

#import "Searches+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Searches (CoreDataProperties)

+ (NSFetchRequest<Searches *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *searchString;

@end

NS_ASSUME_NONNULL_END
