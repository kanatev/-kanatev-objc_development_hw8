//
//  PeopleTableView.m
//  objc_development_hw6
//
//  Created by Aleksei Kanatev on 13.11.2019.
//  Copyright © 2019 Aleksei Kanatev. All rights reserved.
//

#import "PeopleTableView.h"
#import "MakePeopleVC.h"
#import "CoreDataService.h"
#import "ResultSearchController.h"
#import "FirstViewController.h"
#import "NotificationService.h"
#import "MyNewCell.h"

@interface PeopleTableView () <UISearchResultsUpdating>

@property (nonatomic, strong) UISearchController* searchController;
@property (nonatomic, strong) ResultSearchController* resultController;


@end

@implementation PeopleTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self maskedNumberFromNumber];
    
    self.resultController = [[ResultSearchController alloc] init];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultController];
    [self.searchController setSearchResultsUpdater:self];
    [self.navigationItem setSearchController:self.searchController];
    
    NSString *locAddNewContact = [NSString localizedStringWithFormat:NSLocalizedString(@"addNewContact", @"")];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:locAddNewContact style:UIBarButtonItemStylePlain target:self action:@selector(addButtonTapped)];
    [self.navigationItem setRightBarButtonItem:addButton];
    
    self.people = [[CoreDataService sharedInstance] getAllPeople];
    
    [self update];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:NSManagedObjectContextDidSaveNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self presentFirstViewControllerIfNeeded];
}

-(void)presentFirstViewControllerIfNeeded {
    BOOL isFirstStart = [[NSUserDefaults standardUserDefaults] boolForKey:@"first_start"];
    if (!isFirstStart) {
        FirstViewController *firstViewController = [[FirstViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        [firstViewController setModalPresentationStyle:UIModalPresentationFullScreen];
        [self presentViewController:firstViewController animated:YES completion:nil];
    }
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (searchController.searchBar.text) {
        NSMutableArray* resultArray = [NSMutableArray new];
        
        for (People *p in self.people) {
            if ([p.name.lowercaseString containsString:searchController.searchBar.text.lowercaseString]) {
                [resultArray addObject: p];
            }
        }
        self.resultController.results = resultArray;
        [self.resultController update];
    }
}

-(void)addButtonTapped {
    MakePeopleVC *vc = [[MakePeopleVC alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

-(void)update{
    self.people = [[CoreDataService sharedInstance] getAllPeople];
    [self.tableView reloadData];
    
    for (People *p in self.people) {
        
        if (p.birthDate.hash != 0) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd.MM.yyyy"];
            NSDate *birthDateAsDate = [dateFormatter dateFromString:p.birthDate];
            NSDate *currentDate = [NSDate date];
            NSLog(@"birth %@", birthDateAsDate);
            NSLog(@"current %@", currentDate);
            
            NSString *birthDateString = [dateFormatter stringFromDate:birthDateAsDate];
            NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
            
            NSMutableString *birthDateStringShort = [NSMutableString stringWithFormat:@"%@", birthDateString];
            NSMutableString *currentDateStringShort = [NSMutableString stringWithFormat:@"%@", currentDateString];
            [birthDateStringShort deleteCharactersInRange: NSMakeRange(5, 5)];
            [currentDateStringShort deleteCharactersInRange: NSMakeRange(5, 5)];
            NSLog(@"birth %@", birthDateStringShort);
            NSLog(@"current %@", currentDateStringShort);
            
            if ([birthDateStringShort isEqualToString:currentDateStringShort]) {
                NSString *congrats = [NSString stringWithFormat: @"Поздравьте контакт '%@' с днем рождения", p.name];
                [[NotificationService sharedInstance] sendNotification:NotificationMake(@"Уведомление", congrats, [[NSDate new] dateByAddingTimeInterval: 5], [NSURL URLWithString:@"reload"])];
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.people count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyNewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[MyNewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    cell.buttonInCell.button_indexPath = indexPath;
    
    People *person = [self.people objectAtIndex:indexPath.row];
    [cell.textLabel setText: person.name];
    
    if (person.phone != nil && person.birthDate.hash != 0) {
        [cell.detailTextLabel setText: [NSString stringWithFormat: @"tel: %@, birth date: %@", person.phone, person.birthDate]];
        //        print(@"%@",person.birthDate.);
    } else if (person.phone != nil && person.birthDate.hash == 0){
        [cell.detailTextLabel setText: [NSString stringWithFormat: @"tel: %@", person.phone]];
    } else if (person.phone == nil && person.birthDate.hash != 0) {
        [cell.detailTextLabel setText: [NSString stringWithFormat: @"birth date: %@", person.birthDate]];
    } else {
        [cell.detailTextLabel setText: [NSString stringWithFormat: @"no data"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        People *objectToDelete = [self.people objectAtIndex:indexPath.row];
        [[CoreDataService sharedInstance] deletePeopleNamed:objectToDelete];
        [self update];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    
    DetailVC *detailVC = [[DetailVC alloc] init];
    detailVC.ourPerson = [self.people objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detailVC animated:true];
}

//- (void)maskedNumberFromNumber:(NSNumber *)numberrr {
- (void)maskedNumberFromNumber{

    NSNumber *testNumber = [NSNumber numberWithLong: 89191234455];
    
    NSString *numberString = [NSString stringWithFormat:@"%@", testNumber];
    NSString *maskedNumberString = @"";
    
    //  первый путь
    //    NSString *someString = ...
    //
    //    unsigned int len = [someString length];
    //    char buffer[len];
    //
    //    //This way:
    //    strncpy(buffer, [someString UTF8String]);
    //
    //    //Or this way (preferred):
    //
    //    [someString getCharacters:buffer range:NSMakeRange(0, len)];
    //
    //    for(int i = 0; i < len; ++i) {
    //       char current = buffer[i];
    //       //do something with current...
    //    }
    
    // второй путь
    NSUInteger len = [numberString length];
    unichar buffer[len+1];
    
    [numberString getCharacters:buffer range:NSMakeRange(0, len)];
    
    NSLog(@"getCharacters:range: with unichar buffer");
    for(int i = 0; i < len; i++) {
        
        NSString *tmpStr = [NSString stringWithFormat:@"%C", buffer[i]];
        NSLog(@"%@", tmpStr);

        maskedNumberString = [maskedNumberString stringByAppendingString: tmpStr];
        
    }
    NSLog(@"maskedString is %@", maskedNumberString);

    
    //    for ( i in numberString) {
    //
    //    }
    
    //    NSMutableString *strippedString = [NSMutableString
    //                                       stringWithCapacity:self.previousTextFieldContent.length];
    //    NSScanner *scanner = [NSScanner scannerWithString:self.previousTextFieldContent];
    //    NSCharacterSet *numbers = [NSCharacterSet
    //                               characterSetWithCharactersInString:@"0123456789"];
    //    while ([scanner isAtEnd] == NO) {
    //        NSString *buffer;
    //        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
    //            [strippedString appendString:buffer];
    //        } else {
    //            [scanner setScanLocation:([scanner scanLocation] + 1)];
    //        }
    //    }
    
    
    //
    //    int length = [self getLength:self.phoneField.text];
    //
    //    // определяем первый символ в текстовом поле ввода номера
    //    NSRange rangeFirstChar = NSMakeRange(0, 1);
    //    NSString *firstChar = [self.phoneField.text substringWithRange:rangeFirstChar];
    //
    //    // если первый символ 8, то идем дальше.
    //    if ([firstChar isEqualToString: @"8"]){
    //
    //        if (length == 1) {
    //            NSString *num = self.phoneField.text;
    //            self.phoneField.text = [NSString stringWithFormat:@"%@",num];
    //            self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", self.phoneField.text];
    //
    //        } else if(length == 2) {
    //            NSString *num = [self formatNumber:self.phoneField.text];
    //            self.phoneField.text = [NSString stringWithFormat:@"%@ (%@",self.previousTextFieldContent,[num substringFromIndex:1]];
    //            self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", self.phoneField.text];
    //        } else if(length == 3) {
    //            self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", self.phoneField.text];
    //        } else if(length == 4) {
    //            self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", self.phoneField.text];
    //            NSLog(@"%lu", (unsigned long)self.phoneField.text.length);
    //        } else if(length == 5) {
    //            NSString *num = [self formatNumber:self.phoneField.text];
    //            self.phoneField.text = [NSString stringWithFormat:@"%@) %@", self.previousTextFieldContent,[num substringFromIndex:4]];
    //            self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", self.phoneField.text];
    //        } else if(length == 6) {
    //            self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", self.phoneField.text];
    //        } else if(length == 7) {
    //            self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", self.phoneField.text];
    //        } else if(length == 8) {
    //            NSString *num = [self formatNumber:self.phoneField.text];
    //            self.phoneField.text = [NSString stringWithFormat:@"%@-%@", self.previousTextFieldContent, [num substringFromIndex:7]];
    //            self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", self.phoneField.text];
    //        } else if(length == 9) {
    //            self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", self.phoneField.text];
    //        } else if(length == 10) {
    //            NSString *num = [self formatNumber:self.phoneField.text];
    //            self.phoneField.text = [NSString stringWithFormat:@"%@-%@", self.previousTextFieldContent, [num substringFromIndex:9]];
    //            self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", self.phoneField.text];
    //        } else if (length >=11) {
    //            self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", self.phoneField.text];
    //
    //            NSRange newRange = NSMakeRange(0, 17);
    //            NSString *newString = [self.previousTextFieldContent substringWithRange:newRange];
    //            NSLog(@"new string %@", newString);
    //            self.phoneField.text = newString;
    //            self.previousTextFieldContent = [NSMutableString stringWithFormat:@"%@", newString];
    //            NSLog(@"number is %@", self.previousTextFieldContent);
    //
    //            NSString *holderString = [self.phoneField.text stringByReplacingCharactersInRange:newRange withString:newString];
    //            self.phoneField.text = holderString;
    
}

@end


