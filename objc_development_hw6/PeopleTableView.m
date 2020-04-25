//
//  PeopleTableView.m
//  objc_development_hw6
//
//  Created by Aleksei Kanatev on 13.11.2019.
//  Copyright © 2019 Aleksei Kanatev. All rights reserved.
//

#import "PeopleTableView.h"
#import "DetailVC.h"
#import "MakePeopleVC.h"
#import "FirstViewController.h"
#import "NotificationService.h"
#import "MyNewCell.h"
#import "ResultSearchController.h"


@interface PeopleTableView () <UISearchResultsUpdating>

//@property (nonatomic, strong) UISearchController* searchController;
@property (nonatomic, strong) ResultSearchController* resultController;


@end

@implementation PeopleTableView

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.resultController = [[ResultSearchController alloc] init];
    self.searchControllerrr = [[UISearchController alloc] initWithSearchResultsController:self.resultController];
    [self.searchControllerrr setSearchResultsUpdater:self];
    [self.navigationItem setSearchController:self.searchControllerrr];
    
//    self.searchController.active = false;
    
    
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
        
    People *person = [self.people objectAtIndex:indexPath.row];
    [cell.textLabel setText: person.name];
    
    if (person.phone != nil && person.birthDate.hash != 0) {
        NSString *maskedNumberForCell = [self maskedNumberFromNumber:person.phone];
        [cell.detailTextLabel setText: [NSString stringWithFormat: @"tel: %@, birth date: %@", maskedNumberForCell, person.birthDate]];
        
    } else if (person.phone != nil && person.birthDate.hash == 0){
        NSString *maskedNumberForCell = [self maskedNumberFromNumber:person.phone];
        [cell.detailTextLabel setText: [NSString stringWithFormat: @"tel: %@", maskedNumberForCell]];

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

//    - (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//        [super searchBarCancelButtonClicked:searchBar];
//    }

@end
