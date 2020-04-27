//
//  MyTextField.m
//  objc_development_hw6
//
//  Created by Aleksei Kanatev on 19.12.2019.
//  Copyright © 2019 Aleksei Kanatev. All rights reserved.
//

#import "MyTextField.h"



@implementation MyTextField

- (void)deleteBackward {    
    if ([_myDelegate respondsToSelector:@selector(textFieldDidDelete)]){
        [_myDelegate textFieldDidDelete];
    }
}

@end
