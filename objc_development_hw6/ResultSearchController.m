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
    [self.view setBackgroundColor: [UIColor whiteColor]];
}


#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.results count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyNewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[MyNewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    if (self.results.count != 0) {
        cell.buttonInCell.button_indexPath = indexPath;
        People *person = [self.results objectAtIndex:indexPath.row];
        [cell.textLabel setText: person.name];
        
        if (person.phone != nil && person.birthDate.hash != 0) {
            [cell.detailTextLabel setText: [NSString stringWithFormat: @"tel: %@, birth date: %@", person.phone, person.birthDate]];
        } else if (person.phone != nil && person.birthDate.hash == 0){
            [cell.detailTextLabel setText: [NSString stringWithFormat: @"tel: %@", person.phone]];
        } else if (person.phone == nil && person.birthDate.hash != 0) {
            [cell.detailTextLabel setText: [NSString stringWithFormat: @"birth date: %@", person.birthDate]];
        } else {
            [cell.detailTextLabel setText: [NSString stringWithFormat: @"no data"]];
        }
        
        //    People *person = [self.results objectAtIndex:indexPath.row];
        //    [cell.textLabel setText: person.name];
        //    [cell.detailTextLabel setText: [NSString stringWithFormat: @"tel: %@, birth date: %@", person.phone, person.birthDate]];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    
    People *person = [self.results objectAtIndex: indexPath.row];
    NSString *number = [NSString stringWithFormat:@"%@", person.phone];
    
    //    NSLog(@"%@ was pushed", number);
    NSString *phoneNumber = [@"tel://" stringByAppendingString:number];
    NSURL *url = [[NSURL alloc] initWithString:phoneNumber];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

@end
