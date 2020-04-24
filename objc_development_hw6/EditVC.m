//
//  EdtiVC.m
//  objc_development_hw6
//
//  Created by Aleksei Kanatev on 16.02.2020.
//  Copyright © 2020 Aleksei Kanatev. All rights reserved.
//

#import "EditVC.h"

@interface EditVC ()

@end

@implementation EditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nameField setText:self.ourPerson.name];
    if(self.ourPerson.phone != nil){
        NSString *tempStr = [NSString stringWithFormat:@"%@", self.ourPerson.phone];
        [self.phoneField setText:tempStr];
    }
    if(self.ourPerson.birthDate != nil){
        [self.birthDate setText:self.ourPerson.birthDate];
    }
    self.phoneField.delegate=self;
    self.nameField.delegate=nil;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.phoneField.text = @"";
    //    NSLog(@"phoneField did begin editing");
}

-(void)saveButtonTapped {
    NSMutableString *strippedString = [NSMutableString
                                       stringWithCapacity:self.previousTextFieldContent.length];
    NSScanner *scanner = [NSScanner scannerWithString:self.previousTextFieldContent];
    NSCharacterSet *numbers = [NSCharacterSet
                               characterSetWithCharactersInString:@"0123456789"];
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    
    if([strippedString isEqual: @""]) {
        //        NSLog(@"number didn't change");
        [strippedString setString: [NSString stringWithFormat: @"tel: %@", self.ourPerson.phone]];
    }
    
    //    NSLog(@"formatted number is %@", strippedString);
    //    NSLog(@"length is %lu", (unsigned long)strippedString.length);
    
    if (self.nameField.hasText && (!self.phoneField.hasText || strippedString.length == 11 || self.phoneField.text.length == 11)) {
        
        // в случае очистки неполного номера по alert'у чистим strippedString
        // иначе будет сохраняться неполный номер
        if(strippedString.length <11){
            //        NSLog(@"!!!!!!!!!!myNumber is %@", self.phoneField.text);
            [strippedString setString:@""];
        }
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * myNumber = [f numberFromString:strippedString];
        
        if(myNumber == nil){
            myNumber = [f numberFromString:self.phoneField.text];
        }
        
        //        NSLog(@"myNumber is %@", myNumber);
        
        // запись в core data
        [[CoreDataService sharedInstance] editPeopleNamed:self.ourPerson withName:self.nameField.text withPhone:myNumber withBirthDate:self.birthDate.text];
        
        [self.navigationController popViewControllerAnimated:false];
        
    } else if (!self.nameField.hasText) {
        [self presentViewController:self.emptyName animated:YES completion:nil];
    } else if (strippedString.length > 0 || strippedString.length < 11) {
        [self presentViewController:self.wrongNumber animated:YES completion:nil];
    }
}

@end

