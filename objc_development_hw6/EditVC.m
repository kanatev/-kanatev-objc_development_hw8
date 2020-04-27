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
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemClose target:self action:@selector(backButtonTapped)];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    [self.nameField setText:self.ourPerson.name];
    if(self.ourPerson.phone != nil){
        NSString *maskedNumber = [self maskedNumberFromNumber:self.ourPerson.phone];
//        NSString *tempStr = [NSString stringWithFormat:@"%@", self.ourPerson.phone];
        [self.phoneField setText:maskedNumber];
        NSLog(@"maskedNumber %lu", (unsigned long)maskedNumber.length);
        NSLog(@"phoneField %lu", (unsigned long)self.phoneField.text.length);

    }
    if(self.ourPerson.birthDate != nil){
        [self.birthDate setText:self.ourPerson.birthDate];
    }
    self.phoneField.delegate=self;
    self.nameField.delegate=nil;
    
}

-(void)backButtonTapped {
        [self.navigationController popViewControllerAnimated:true];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.phoneField.text = @"";
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
        [strippedString setString: [NSString stringWithFormat: @"tel: %@", self.ourPerson.phone]];
    }

    if (self.nameField.hasText && (!self.phoneField.hasText || strippedString.length == 11 || self.phoneField.text.length == 17)) {
        
        // в случае очистки неполного номера по alert'у чистим strippedString
        // иначе будет сохраняться неполный номер
        if(strippedString.length <11){
            [strippedString setString:@""];
        }
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * myNumber = [f numberFromString:strippedString];
        
        //---------------------------------------------------------------
        // если поле пустое, сохраняем пустое значение телефона
        if(myNumber == nil){
//            myNumber = [f numberFromString:self.phoneField.text];
            if (self.phoneField.text.length == 17) {
                myNumber = self.ourPerson.phone;
            } else {
                myNumber = [f numberFromString:@""];
            }
            
            
        }
                
        // запись в core data
        [[CoreDataService sharedInstance] editPeopleNamed:self.ourPerson withName:self.nameField.text withPhone:myNumber withBirthDate:self.birthDate.text];
        
        [self.navigationController popViewControllerAnimated:false];
        
    } else if (!self.nameField.hasText) {
        [self presentViewController:self.emptyName animated:YES completion:nil];
    } else if (strippedString.length > 0 || strippedString.length < 11) {
        [self presentViewController:self.wrongNumber animated:YES completion:nil];
    }
}

- (NSString*)maskedNumberFromNumber:(NSNumber *)numberToMask {
    
    NSString *numberString = [NSString stringWithFormat:@"%@", numberToMask];
    NSString *maskedNumberString = @"";
    
    NSUInteger len = [numberString length];
    unichar buffer[len+1];
    
    [numberString getCharacters:buffer range:NSMakeRange(0, len)];
    
    NSLog(@"getCharacters:range: with unichar buffer");
    for(int i = 0; i < len; i++) {
        
        NSString *tmpStr = [NSString stringWithFormat:@"%C", buffer[i]];
        NSLog(@"%@", tmpStr);
        
        if (i == 0){
            maskedNumberString = [maskedNumberString stringByAppendingString: tmpStr];
        } else if (i == 1) {
            maskedNumberString = [maskedNumberString stringByAppendingFormat:@"%@%@", @" (", tmpStr];
        } else if (i == 2) {
            maskedNumberString = [maskedNumberString stringByAppendingString: tmpStr];
        } else if (i == 3) {
            maskedNumberString = [maskedNumberString stringByAppendingString: tmpStr];
        } else if (i == 4) {
            maskedNumberString = [maskedNumberString stringByAppendingFormat:@"%@%@", @") ", tmpStr];
        } else if (i == 5) {
            maskedNumberString = [maskedNumberString stringByAppendingString: tmpStr];
        } else if (i == 6) {
            maskedNumberString = [maskedNumberString stringByAppendingString: tmpStr];
        } else if (i == 7) {
            maskedNumberString = [maskedNumberString stringByAppendingFormat:@"%@%@", @"-", tmpStr];
        } else if (i == 8) {
            maskedNumberString = [maskedNumberString stringByAppendingString: tmpStr];
        } else if (i == 9) {
            maskedNumberString = [maskedNumberString stringByAppendingFormat:@"%@%@", @"-", tmpStr];
        } else if (i == 10) {
            maskedNumberString = [maskedNumberString stringByAppendingString: tmpStr];
        }
    }
    NSLog(@"maskedString is %@", maskedNumberString);
    return maskedNumberString;
}

@end

