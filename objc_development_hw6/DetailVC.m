//
//  DetailVC.m
//  objc_development_hw6
//
//  Created by Aleksei Kanatev on 22.12.2019.
//  Copyright © 2019 Aleksei Kanatev. All rights reserved.
//

#import "DetailVC.h"

@interface DetailVC ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *birthLabel;
@property (nonatomic, strong) UIButton *phoneButton;
@property (nonatomic, strong) NSMutableAttributedString *indentedNameText;
@property (nonatomic) NSRange myNewRange;
@property (nonatomic, strong) NSMutableParagraphStyle *style;
@property (nonatomic, strong) NSString *locBirthDate;
@property (nonatomic, strong) NSString *locNoPhone;

@end

@implementation DetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if (!self.navigationItem.backBarButtonItem.isEnabled) {

        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemClose target:self action:@selector(backButtonTapped)];
        
    [self.navigationItem setLeftBarButtonItem:backButton];
    }
    
    NSString *locEdit = [NSString localizedStringWithFormat:NSLocalizedString(@"edit", @"")];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle: locEdit style:UIBarButtonItemStylePlain target:self action:@selector(editButtonTapped)];
    [self.navigationItem setRightBarButtonItem:editButton];
    
    self.locBirthDate = [NSString localizedStringWithFormat:NSLocalizedString(@"birthDate", @"")];
    self.locNoPhone = [NSString localizedStringWithFormat:NSLocalizedString(@"noPhone", @"")];
    
    // отступ для лейблов
    self.style = [[NSMutableParagraphStyle alloc] init];
    self.style.firstLineHeadIndent = 5;
    
    // создаем точку внесения отступа
    self.myNewRange = NSMakeRange(0, 1);
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 50)];
    
    CALayer * nameLayer = [self.nameLabel layer];
    [nameLayer setMasksToBounds:YES];
    [nameLayer setCornerRadius:5.0];
    [nameLayer setBorderWidth:1.0];
    [nameLayer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    [self.view addSubview:self.nameLabel];
    
    self.birthLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, self.view.bounds.size.width - 40, 50)];
    CALayer * birthDateLayer = [self.birthLabel layer];
    [birthDateLayer setMasksToBounds:YES];
    [birthDateLayer setCornerRadius:5.0];
    [birthDateLayer setBorderWidth:1.0];
    [birthDateLayer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.view addSubview:self.birthLabel];
    
    self.phoneButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 150, self.view.bounds.size.width - 40, 50)];
    
    CALayer * phoneLayer = [self.phoneButton layer];
    [phoneLayer setMasksToBounds:YES];
    [phoneLayer setCornerRadius:5.0];
    [phoneLayer setBorderWidth:1.0];
    [phoneLayer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    // другой путь сделать отступ текста
    self.phoneButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    self.phoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [self.view addSubview:self.phoneButton];
}

    -(void)backButtonTapped {
        if (self.navigationController.viewControllers.count == 1) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:true];
        }
    }

- (void)viewWillAppear:(BOOL)animated{
    // обновляем инфу в поле - имя
    self.indentedNameText = [[NSMutableAttributedString alloc] initWithString:self.ourPerson.name];
    [self.indentedNameText addAttribute:NSParagraphStyleAttributeName value:self.style range:self.myNewRange];
    [self.nameLabel setAttributedText:self.indentedNameText];
    
    // обновляем инфу в поле - день рождения
    if (self.ourPerson.birthDate.hash != 0) {
        NSString *birthDateString = [NSString stringWithFormat:@"%@", self.ourPerson.birthDate];
        NSMutableAttributedString *indentedBirthDateText = [[NSMutableAttributedString alloc] initWithString:birthDateString];
        [indentedBirthDateText addAttribute:NSParagraphStyleAttributeName value:self.style range:self.myNewRange];
        [self.birthLabel setAttributedText:indentedBirthDateText];
    }
    else {
        NSString *birthDateStringEmpty = [NSString stringWithFormat:@"%@", self.locBirthDate];
        NSMutableAttributedString *indentedBirthDateTextEmpty = [[NSMutableAttributedString alloc] initWithString:birthDateStringEmpty];
        [indentedBirthDateTextEmpty addAttribute:NSParagraphStyleAttributeName value:self.style range:self.myNewRange];
        [self.birthLabel setAttributedText:indentedBirthDateTextEmpty];
        self.birthLabel.textColor = [UIColor lightGrayColor];
    }
    
    // обновляем инфу в поле - телефон
    if (self.ourPerson.phone != nil) {
        NSString *maskedNumber = [self maskedNumberFromNumber:self.ourPerson.phone];
        [self.phoneButton setTitle:[NSString stringWithFormat: @"%@", maskedNumber] forState:UIControlStateNormal];
        [self.phoneButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.phoneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [self.phoneButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.phoneButton setTitle:[NSString stringWithFormat: @"%@", self.locNoPhone]
                          forState:UIControlStateNormal];
        [self.phoneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.phoneButton.enabled = false;
    }
}

-(void)editButtonTapped {
    EditVC *editVC = [[EditVC alloc] init];
    editVC.ourPerson = [People new];
    editVC.ourPerson = self.ourPerson;
    [self.navigationController pushViewController:editVC animated:false];
    
}

-(void)buttonPressed{
    //Набор номера телефона
    NSString *number = [NSString stringWithFormat:@"%@", self.ourPerson.phone];
    NSString *phoneNumber = [@"tel://" stringByAppendingString:number];
    NSURL *url = [[NSURL alloc] initWithString:phoneNumber];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
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
