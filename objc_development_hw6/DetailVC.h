//
//  DetailVC.h
//  objc_development_hw6
//
//  Created by Aleksei Kanatev on 22.12.2019.
//  Copyright © 2019 Aleksei Kanatev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataService.h"
#import "EditVC.h"
#import "MakePeopleVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailVC : UIViewController

@property (nonatomic, strong, nonnull) People *ourPerson;


@end

NS_ASSUME_NONNULL_END
