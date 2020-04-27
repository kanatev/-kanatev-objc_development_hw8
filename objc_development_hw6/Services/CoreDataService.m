//
//  CoreDataService.m
//  objc_development_hw6
//
//  Created by Aleksei Kanatev on 13.11.2019.
//  Copyright © 2019 Aleksei Kanatev. All rights reserved.
//

#import "CoreDataService.h"

@interface CoreDataService()

@property (nonatomic, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation CoreDataService

+(instancetype)sharedInstance {
    static CoreDataService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CoreDataService alloc] init];
        [instance setup];
        
    });
    return instance;
}

-(void)setup {
    self.persistentContainer = [[NSPersistentContainer alloc] initWithName:@"BDCD"];
    [self.persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *description, NSError *error) {
        if (error != nil) {
            NSLog(@"Core data init error");
//            abort();
        }
        self.context = self.persistentContainer.viewContext;
        
    }];
}

-(void)createPeopleWithName:(NSString*)name withPhone:(NSNumber*)phone withBirthDate:(NSString *)birthDate{
    People *newPeople = [NSEntityDescription insertNewObjectForEntityForName:@"People" inManagedObjectContext:self.context];
    [newPeople setValue:name forKey:@"name"];
    [newPeople setValue:phone forKey:@"phone"];
    [newPeople setValue:birthDate forKey:@"birthDate"];
    [self save];
}

-(void)editPeopleNamed:(People*)editPeople withName:(NSString*)name withPhone:(NSNumber*)phone withBirthDate:(NSString *)birthDate {
    [editPeople setValue:name forKey:@"name"];
    [editPeople setValue:phone forKey:@"phone"];
    [editPeople setValue:birthDate forKey:@"birthDate"];
    [self save];
}

-(void)deletePeopleNamed:(People*)delPeople {
    [self.context deleteObject:delPeople];
    [self save];
}

-(NSMutableArray*)getAllPeople{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"People"];
    NSError *error;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
//    NSMutableArray *mutableResults = [results mutableCopy];
    NSMutableArray *mutableResults  = [NSMutableArray arrayWithArray:results];

    if (error && !results) {
        NSLog(@"Error fetching.");
    }
    return mutableResults;
}


-(void)save{
    NSError *error;
    if (![self.context save: &error]) {
        NSAssert(false, @"Error context save.");
    }
}

@end
