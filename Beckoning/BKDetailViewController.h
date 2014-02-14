//
//  BKDetailViewController.h
//  Beckoning
//
//  Created by Ronnie Liew on 14/2/14.
//  Copyright (c) 2014 Monokromik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
