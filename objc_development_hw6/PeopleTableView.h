//
//  PeopleTableView.h
//  objc_development_hw6
//
//  Created by Aleksei Kanatev on 13.11.2019.
//  Copyright © 2019 Aleksei Kanatev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataService.h"
#import "DetailVC.h"


NS_ASSUME_NONNULL_BEGIN

@interface PeopleTableView : UITableViewController

@property (nonatomic, strong) NSArray *people;
@property (nonatomic, strong) People *myPerson;

@end

NS_ASSUME_NONNULL_END
