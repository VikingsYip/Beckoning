//
//  BKHomeViewController.m
//  Beckoning
//
//  Created by Ronnie Liew on 25/2/14.
//  Copyright (c) 2014 Monokromik. All rights reserved.
//

#import "BKHomeViewController.h"
#import <Foursquare2.h>

@interface BKHomeViewController ()

@end

@implementation BKHomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];

}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (![Foursquare2 isAuthorized]){
        [Foursquare2 authorizeWithCallback:nil];
    }
    
}
@end
