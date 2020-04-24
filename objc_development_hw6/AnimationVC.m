//
//  AnimationVC.m
//  objc_development_hw6
//
//  Created by Aleksei Kanatev on 27.11.2019.
//  Copyright © 2019 Aleksei Kanatev. All rights reserved.
//

#import "AnimationVC.h"

@interface AnimationVC ()

@end

@implementation AnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];
//    self.view.bounds.size.width
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame: CGRectMake(135, 300, 100, 100)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame: CGRectMake(self.view.bounds.size.width/2-50, self.view.bounds.size.height/2-50, 100, 100)];
    [imgView setImage:[UIImage imageNamed:@"reload"]];
    [self.view addSubview:imgView];
    
    [UIView animateWithDuration:1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        int i;
        for (i = 1; i < 10; i++) {
            imgView.transform = CGAffineTransformRotate(imgView.transform, 120);
        }
    }completion:^(BOOL finished) {
        imgView.alpha = 0.0;
        PeopleTableView *nextVC = [[PeopleTableView alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:nextVC];
        [nav setModalPresentationStyle:UIModalPresentationFullScreen];
        nextVC = (PeopleTableView*)nav.topViewController;
        nav.navigationBar.topItem.title = @"BizCon";
        [self presentViewController:nav animated:true completion:nil];
    }];
}

@end
