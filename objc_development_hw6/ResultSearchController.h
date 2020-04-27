//
//  ResultSearchController.h
//  objc_development_hw6
//
//  Created by Aleksei Kanatev on 18.11.2019.
//  Copyright © 2019 Aleksei Kanatev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeopleTableView.h"
#import "CoreDataService.h"
#import "DetailVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResultSearchController : PeopleTableView

@property (nonatomic, strong) NSMutableArray* results;
@property (nonatomic, strong) UINavigationController *myNavController;

-(void)update;

@end

NS_ASSUME_NONNULL_END
