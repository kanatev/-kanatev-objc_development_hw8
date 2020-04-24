//
//  EdtiVC.h
//  objc_development_hw6
//
//  Created by Aleksei Kanatev on 16.02.2020.
//  Copyright © 2020 Aleksei Kanatev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataService.h"
#import "MyTextField.h"
#import "MakePeopleVC.h"

NS_ASSUME_NONNULL_BEGIN
@interface EditVC : MakePeopleVC

@property (nonatomic, strong, nonnull) People *ourPerson;

@end

NS_ASSUME_NONNULL_END
