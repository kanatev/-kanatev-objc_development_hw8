//
//  MakePeopleVC.h
//  objc_development_hw6
//
//  Created by Aleksei Kanatev on 13.11.2019.
//  Copyright © 2019 Aleksei Kanatev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataService.h"
#import "MyTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface MakePeopleVC : UIViewController <MyTextFieldDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) MyTextField *phoneField;
@property (nonatomic, strong) UITextField *birthDate;

@property (nonatomic, strong) NSMutableString *previousTextFieldContent;
@property (nonatomic, strong) UITextRange *previousSelection;

@property (nonatomic, strong) UIAlertController *emptyName;
@property (nonatomic, strong) UIAlertController *wrongNumber;
@property (nonatomic, strong) UIAlertController *wrongFirstDigit;

@end

NS_ASSUME_NONNULL_END
