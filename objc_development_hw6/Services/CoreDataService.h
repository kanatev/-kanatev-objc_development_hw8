//
//  CoreDataService.h
//  objc_development_hw6
//
//  Created by Aleksei Kanatev on 13.11.2019.
//  Copyright © 2019 Aleksei Kanatev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "People+CoreDataProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataService : NSObject

+(instancetype)sharedInstance;

-(void)createPeopleWithName:(NSString*)name withPhone:(NSNumber*)phone withBirthDate:(NSString*)birthDate;

-(NSArray*)getAllPeople;
-(void)deletePeopleNamed:(People*)delPeople;
-(void)editPeopleNamed:(People*)editPeople withName:(NSString*)name withPhone:(NSNumber*)phone withBirthDate:(NSString *)birthDate;
@end

NS_ASSUME_NONNULL_END
