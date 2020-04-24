//
//  People+CoreDataProperties.m
//  objc_development_hw6
//
//  Created by Aleksei Kanatev on 13.11.2019.
//  Copyright © 2019 Aleksei Kanatev. All rights reserved.
//
//

#import "People+CoreDataProperties.h"

@implementation People (CoreDataProperties)

+ (NSFetchRequest<People *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"People"];
}

@dynamic name;
@dynamic phone;
@dynamic birthDate;

@end
