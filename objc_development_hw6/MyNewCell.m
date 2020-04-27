//
//  MyNewCell.m
//  objc_development_hw6
//
//  Created by Aleksei Kanatev on 10.01.2020.
//  Copyright © 2020 Aleksei Kanatev. All rights reserved.
//

#import "MyNewCell.h"

@implementation MyNewCell

@synthesize buttonInCell;

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    }

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        buttonInCell = [[IndexedButton alloc] initWithFrame:CGRectMake(0,0,50,30)];
        [buttonInCell setImage:[UIImage imageNamed:@"i"] forState:UIControlStateNormal];
        [self addSubview:buttonInCell];
        [self setBackgroundColor:[UIColor yellowColor]];
    }
    return self;
}

@end
