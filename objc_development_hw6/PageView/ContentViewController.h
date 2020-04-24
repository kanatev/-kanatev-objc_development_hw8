//
//  ContentViewController.h
//  objc_development_hw6
//
//  Created by Aleksei Kanatev on 28.11.2019.
//  Copyright © 2019 Aleksei Kanatev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContentViewController : UIViewController

@property(nonatomic, strong)NSString *contentText;
@property(nonatomic, strong)UIImage *image;
@property(nonatomic)int *index;


@end

NS_ASSUME_NONNULL_END
