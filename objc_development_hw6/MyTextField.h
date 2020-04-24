//
//  MyTextField.h
//  objc_development_hw6
//
//  Created by Aleksei Kanatev on 19.12.2019.
//  Copyright © 2019 Aleksei Kanatev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//create delegate protocol
@protocol MyTextFieldDelegate <NSObject>
@optional
- (void)textFieldDidDelete;
@end

@interface MyTextField : UITextField<UIKeyInput>


//create "myDelegate"
@property (nonatomic, assign) id<MyTextFieldDelegate> myDelegate;

@end

NS_ASSUME_NONNULL_END
