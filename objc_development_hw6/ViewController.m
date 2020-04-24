//
//  ViewController.m
//  objc_development_hw6
//
//  Created by Aleksei Kanatev on 12.11.2019.
//  Copyright © 2019 Aleksei Kanatev. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *ourLabel;
@property (nonatomic, strong) UITextField *ourTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor: [UIColor whiteColor]];
    
    self.ourLabel = [[UILabel alloc] initWithFrame: CGRectMake(10, 150, 300, 50)];
    [self.ourLabel setText: [[NSUserDefaults standardUserDefaults] stringForKey: @"ourKey"]];
    [self.view addSubview: self.ourLabel];
    
    self.ourTextField = [[UITextField alloc] initWithFrame: CGRectMake(10, 250, 300, 50)];
    [self.ourTextField setPlaceholder:@"Введите что-то"];
    [self.ourTextField setBorderStyle:UITextBorderStyleBezel];
    [self.view addSubview: self.ourTextField];
    
    UIButton *ourSaveButton = [[UIButton alloc] initWithFrame: CGRectMake(10, 350, 150, 50)];
    [ourSaveButton setTitle:@"our Save" forState:UIControlStateNormal];
    [ourSaveButton setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [ourSaveButton addTarget:self action: @selector(saveButtonTapped) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:ourSaveButton];
    
    UIButton *ourDeleteButton = [[UIButton alloc] initWithFrame: CGRectMake(10, 450, 150, 50)];
    [ourDeleteButton setTitle:@"our Delete" forState:UIControlStateNormal];
    [ourDeleteButton setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    [ourDeleteButton addTarget:self action: @selector(deleteButtonTapped) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:ourDeleteButton];
}

-(void)saveButtonTapped {
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    [data setObject:self.ourTextField.text forKey:@"ourKey"];
    [self.ourLabel setText: [[NSUserDefaults standardUserDefaults] stringForKey: @"ourKey"]];
}

-(void)deleteButtonTapped {
    NSUserDefaults *data = [NSUserDefaults standardUserDefaults];
    [data removeObjectForKey:@"ourKey"];
    [self.ourLabel setText: [[NSUserDefaults standardUserDefaults] stringForKey: @"ourKey"]];
}

@end
