//
//  Searches+CoreDataProperties.m
//  LCTUrlProj
//
//  Created by Владимир on 20/04/2019.
//  Copyright © 2019 Владимир. All rights reserved.
//
//

#import "Searches+CoreDataProperties.h"

@implementation Searches (CoreDataProperties)

+ (NSFetchRequest<Searches *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Searches"];
}

@dynamic searchString;

@end
