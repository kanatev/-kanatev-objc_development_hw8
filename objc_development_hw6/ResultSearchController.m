//
//  ResultSearchController.m
//  objc_development_hw6
//
//  Created by Aleksei Kanatev on 18.11.2019.
//  Copyright © 2019 Aleksei Kanatev. All rights reserved.
//

#import "ResultSearchController.h"
#import "MyNewCell.h"

@interface ResultSearchController ()

@end

@implementation ResultSearchController

-(void)update {
    [self.tableView reloadData];
    NSLog(@"bla %lu", (unsigned long)[self.results count]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.searchControllerrr setSearchResultsUpdater:self];

}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.results count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyNewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[MyNewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    if (self.results.count != 0) {
        
        People *person = [self.results objectAtIndex:indexPath.row];
        [cell.textLabel setText: person.name];
        
        if (person.phone != nil && person.birthDate.hash != 0) {
            NSString *maskedNumberForCell = [self maskedNumberFromNumber:person.phone];
            [cell.detailTextLabel setText: [NSString stringWithFormat: @"tel: %@, birth date: %@", maskedNumberForCell, person.birthDate]];
        } else if (person.phone != nil && person.birthDate.hash == 0){
            NSString *maskedNumberForCell = [self maskedNumberFromNumber:person.phone];
            [cell.detailTextLabel setText: [NSString stringWithFormat: @"tel: %@", maskedNumberForCell]];
        } else if (person.phone == nil && person.birthDate.hash != 0) {
            [cell.detailTextLabel setText: [NSString stringWithFormat: @"birth date: %@", person.birthDate]];
        } else if (person != nil && person.phone == nil && person.birthDate.hash == 0) {
            [cell.detailTextLabel setText: [NSString stringWithFormat: @"no data"]];
        } else if (person == nil) {
            [self update];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        People *objectToDelete = [self.results objectAtIndex:indexPath.row];
        [[CoreDataService sharedInstance] deletePeopleNamed:objectToDelete];
        [self update]; 
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    
    DetailVC *detailVC = [[DetailVC alloc] init];
    detailVC.ourPerson = [self.results objectAtIndex:indexPath.row];
    NSLog(@"%@",detailVC.ourPerson.name);
    self.myNavController = [UINavigationController new];
    [self.myNavController pushViewController:detailVC animated:true];
    [self.myNavController setModalPresentationStyle: UIModalPresentationFullScreen];
    
    [self presentViewController:self.myNavController animated:true completion:nil];
}

@end
