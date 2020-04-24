//  MakePeopleVC.m
//  objc_development_hw6
//
//  Created by Aleksei Kanatev on 13.11.2019.
//  Copyright © 2019 Aleksei Kanatev. All rights reserved.
//

#import "MakePeopleVC.h"
#import "NotificationService.h"
#define MAX_LENGTH 11
#define ACCEPTABLE_CHARACTERS @" -()0123456789"



@interface MakePeopleVC ()
{
    UIDatePicker *birthDatePicker;
}

@end

@implementation MakePeopleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSString *locWarning = [NSString localizedStringWithFormat:NSLocalizedString(@"warning", @"")];
    NSString *locEmptyName = [NSString localizedStringWithFormat:NSLocalizedString(@"emptyName", @"")];
    NSString *locIncompleteNumber = [NSString localizedStringWithFormat:NSLocalizedString(@"incompleteNumber", @"")];
    NSString *locWrongFirstDigit = [NSString localizedStringWithFormat:NSLocalizedString(@"wrongFirstDigit", @"")];
    NSString *locPlease = [NSString localizedStringWithFormat:NSLocalizedString(@"please", @"")];
    NSString *locName = [NSString localizedStringWithFormat:NSLocalizedString(@"name", @"")];
    NSString *locBirthDate = [NSString localizedStringWithFormat:NSLocalizedString(@"birthDate", @"")];
    
    
    self.nameField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 50)];
    [self.nameField setPlaceholder:locName];
    [self.nameField setBorderStyle:UITextBorderStyleRoundedRect];
    //    self.nameField.tag = 1;
    [self.nameField setTag:1];
    [self.view addSubview:self.nameField];
    
    self.phoneField = [[MyTextField alloc] initWithFrame:CGRectMake(20, 150, self.view.bounds.size.width - 40, 50)];
    [self.phoneField setPlaceholder:@"8 (999) 999-99-99"];
    [self.phoneField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.phoneField setTag:2];
    self.phoneField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneField.myDelegate = self;
    [self.phoneField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.phoneField];
    
    
    self.birthDate = [[UITextField alloc] initWithFrame:CGRectMake(20, 200, self.view.bounds.size.width - 40, 50)];
    [self.birthDate setPlaceholder:locBirthDate];
    [self.birthDate setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:self.birthDate];
    
    self->birthDatePicker = [UIDatePicker new];
    [self->birthDatePicker setDatePickerMode:UIDatePickerModeDate];
    [self->birthDatePicker setLocale:[NSLocale localeWithLocaleIdentifier:@"ru"]];
    [self->birthDatePicker setMaximumDate:[NSDate date]];
    
    
    [self->birthDatePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    self.birthDate.inputView = self->birthDatePicker;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
    
    NSString *locSaveContact = [NSString localizedStringWithFormat:NSLocalizedString(@"saveContact", @"")];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:locSaveContact style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonTapped)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_phoneField];
    
    
    self.emptyName = [UIAlertController alertControllerWithTitle:locWarning message:locEmptyName preferredStyle:UIAlertControllerStyleAlert];
    [self.emptyName addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // код обработчика кнопки
    }]];
    
    self.wrongNumber = [UIAlertController alertControllerWithTitle:locWarning message:locIncompleteNumber preferredStyle:UIAlertControllerStyleAlert];
    [self.wrongNumber addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // код обработчика кнопки
    }]];
    
    self.wrongFirstDigit = [UIAlertController alertControllerWithTitle:locPlease message:locWrongFirstDigit preferredStyle:UIAlertControllerStyleAlert];
    [self.wrongFirstDigit addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // код обработчика кнопки
    }]];
    
    // Назначаем делегата, иначе textFieldShouldReturn не сработает.
    self.nameField.delegate = self;
    
}
-(void)viewTapped: (UITapGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:true];
}

-(void)dateChanged:(UIDatePicker *)datePicker {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd.MM.yyyy";
    self.birthDate.text = [dateFormatter stringFromDate:datePicker.date];
}

-(BOOL)textFieldShouldReturn:(MyTextField*)textField {
    
    if (textField == self.nameField) {
        [textField resignFirstResponder];
        [self.phoneField becomeFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

//MyTextField Delegate
- (void)textFieldDidDelete {
    NSLog(@"delete");
    if([self.phoneField.text length] >0) {
        
        if([self.phoneField.text length] == 1){
            self.phoneField.text = [self.phoneField.text substringWithRange:NSMakeRange(0, [self.phoneField.text length] - 1)];
        } else if([self.phoneField.text length] == 4){
            NSString *lastTwoChar = [self.phoneField.text substringFromIndex: [self.phoneField.text length]-2];
            NSCharacterSet * setOne = [[NSCharacterSet characterSetWithCharactersInString:@"("] invertedSet];
            if ([lastTwoChar rangeOfCharacterFromSet:setOne].location != NSNotFound) {
                self.phoneField.text = [self.phoneField.text substringWithRange:NSMakeRange(0, [self.phoneField.text length] - 3)];
                self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", self.phoneField.text];
            }
        } else if([self.phoneField.text length] == 9){
            NSString *lastTwoChar = [self.phoneField.text substringFromIndex: [self.phoneField.text length]-2];
            NSCharacterSet * setOne = [[NSCharacterSet characterSetWithCharactersInString:@" "] invertedSet];
            if ([lastTwoChar rangeOfCharacterFromSet:setOne].location != NSNotFound) {
                self.phoneField.text = [self.phoneField.text substringWithRange:NSMakeRange(0, [self.phoneField.text length] - 3)];
                self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", self.phoneField.text];
                NSLog(@"%lu", (unsigned long)[self.phoneField.text length]);
            }
        }else if([self.phoneField.text length] == 13 || [self.phoneField.text length] == 16 ){
            NSString *lastTwoChar = [self.phoneField.text substringFromIndex: [self.phoneField.text length]-2];
            NSCharacterSet * setOne = [[NSCharacterSet characterSetWithCharactersInString:@"-"] invertedSet];
            if ([lastTwoChar rangeOfCharacterFromSet:setOne].location != NSNotFound) {
                self.phoneField.text = [self.phoneField.text substringWithRange:NSMakeRange(0, [self.phoneField.text length] - 2)];
                self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", self.phoneField.text];
                NSLog(@"%lu", (unsigned long)[self.phoneField.text length]);
            }
        }
        else {
            self.phoneField.text = [self.phoneField.text substringWithRange:NSMakeRange(0, [self.phoneField.text length] - 1)];
        }
        
        
    }
}

-(void)textFieldEditingChanged:(UITextField*)sender {
    
}

#pragma mark - Notifications

- (void)textChanged:(NSNotification *)notification
{
    
    int length = [self getLength:self.phoneField.text];
    
    // определяем первый символ в текстовом поле ввода номера
    NSRange rangeFirstChar = NSMakeRange(0, 1);
    NSString *firstChar = [self.phoneField.text substringWithRange:rangeFirstChar];
    
    // если первый символ 8, то идем дальше.
    if ([firstChar isEqualToString: @"8"]){
        
        if (length == 1) {
            NSString *num = self.phoneField.text;
            self.phoneField.text = [NSString stringWithFormat:@"%@",num];
            self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", self.phoneField.text];
            
        } else if(length == 2) {
            NSString *num = [self formatNumber:self.phoneField.text];
            self.phoneField.text = [NSString stringWithFormat:@"%@ (%@",self.previousTextFieldContent,[num substringFromIndex:1]];
            self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", self.phoneField.text];
        } else if(length == 3) {
            self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", self.phoneField.text];
        } else if(length == 4) {
            self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", self.phoneField.text];
            NSLog(@"%lu", (unsigned long)self.phoneField.text.length);
        } else if(length == 5) {
            NSString *num = [self formatNumber:self.phoneField.text];
            self.phoneField.text = [NSString stringWithFormat:@"%@) %@", self.previousTextFieldContent,[num substringFromIndex:4]];
            self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", self.phoneField.text];
        } else if(length == 6) {
            self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", self.phoneField.text];
        } else if(length == 7) {
            self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", self.phoneField.text];
        } else if(length == 8) {
            NSString *num = [self formatNumber:self.phoneField.text];
            self.phoneField.text = [NSString stringWithFormat:@"%@-%@", self.previousTextFieldContent, [num substringFromIndex:7]];
            self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", self.phoneField.text];
        } else if(length == 9) {
            self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", self.phoneField.text];
        } else if(length == 10) {
            NSString *num = [self formatNumber:self.phoneField.text];
            self.phoneField.text = [NSString stringWithFormat:@"%@-%@", self.previousTextFieldContent, [num substringFromIndex:9]];
            self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", self.phoneField.text];
        } else if (length >=11) {
            self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", self.phoneField.text];
            
            NSRange newRange = NSMakeRange(0, 17);
            NSString *newString = [self.previousTextFieldContent substringWithRange:newRange];
            NSLog(@"new string %@", newString);
            self.phoneField.text = newString;
            self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", newString];
            NSLog(@"number is %@", self.previousTextFieldContent);
            
            NSString *holderString = [self.phoneField.text stringByReplacingCharactersInRange:newRange withString:newString];
            self.phoneField.text = holderString;
            
        }
    } else {
        // Если первый символ не 8 - выводим alert и удаляем введенный символ
        [self presentViewController:self.wrongFirstDigit animated:YES completion:nil];
        [self.phoneField deleteBackward];
    }
}


- (void)textFieldDidBeginEditing:(MyTextField *)textField{
    self.phoneField.text = self.previousTextFieldContent;
    NSLog(@"did begin editing");
}

-(NSString*)formatNumber:(NSString*)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    int length = [mobileNumber length];
    
    if(length > 10) {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
    }
    return mobileNumber;
}
-(int)getLength:(NSString*)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    int length = [mobileNumber length];
    return length;
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
    NSLog(@"formatted number is %@", strippedString);
    NSLog(@"length is %lu", (unsigned long)strippedString.length);
    
    if (self.nameField.hasText && (!self.phoneField.hasText || strippedString.length == 11)) {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * myNumber = [f numberFromString:strippedString];
        
        // запись в core data
        [[CoreDataService sharedInstance] createPeopleWithName:self.nameField.text  withPhone:myNumber withBirthDate:self.birthDate.text];
        
        [self.navigationController popViewControllerAnimated:true];
        
    } else if (!self.nameField.hasText) {
        [self presentViewController:self.emptyName animated:YES completion:nil];
    } else if (strippedString.length > 0 || strippedString.length < 11) {
        [self presentViewController:self.wrongNumber animated:YES completion:nil];
    }
}

@end

