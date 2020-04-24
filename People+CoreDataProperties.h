//
//  People+CoreDataProperties.h
//  objc_development_hw6
//
//  Created by Aleksei Kanatev on 13.11.2019.
//  Copyright © 2019 Aleksei Kanatev. All rights reserved.
//
//

#import "People+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface People (CoreDataProperties)

+ (NSFetchRequest<People *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *phone;
@property (nullable, nonatomic, copy) NSString *birthDate;

@end

NS_ASSUME_NONNULL_END
