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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonTapped)];
    //    [self.myNavController.navigationItem setTitle:@"bla"];
}

//-(void)backButtonTapped {
//    [self.myNavController popToRootViewControllerAnimated:true];
//}

//To customize the presentation or dismissal of the search results controller, assign an object to the search controller’s delegate property. Delegate objects must conform to the UISearchControllerDelegate protocol. You use the methods of that protocol to be notified when the search controller itself is activated and when the search results controller is presented or dismissed.
//Note
//Although a UISearchController object is a view controller, you should never present it directly from your interface. If you want to present the search results interface explicitly, wrap your search controller in a UISearchContainerViewController object and present that object instead.


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
        } else {
            [cell.detailTextLabel setText: [NSString stringWithFormat: @"no data"]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    
    DetailVC *detailVC = [[DetailVC alloc] init];
    detailVC.ourPerson = [self.results objectAtIndex:indexPath.row];
    NSLog(@"%@",detailVC.ourPerson.name);
    
    self.myNavController = [UINavigationController new];
    
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonTapped)];
//    [self.myNavController.navigationItem setBackBarButtonItem:backButton];
    
    [self.myNavController pushViewController:detailVC animated:true];
    [self.myNavController setModalPresentationStyle: UIModalPresentationFullScreen];
    
    [self presentViewController:self.myNavController animated:true completion:nil];
    
}
//    -(void)backButtonTapped {
//        [self.myNavController popToRootViewControllerAnimated:true];
//    }

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:false];
//
//    DetailVC *detailVC = [[DetailVC alloc] init];
//    detailVC.ourPerson = [self.people objectAtIndex:indexPath.row];
//
//    [self.navigationController pushViewController:detailVC animated:true];
//}

@end
