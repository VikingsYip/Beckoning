//
//  BKViewController.m
//  Beckoning
//
//  Created by Ronnie Liew on 14/2/14.
//  Copyright (c) 2014 Monokromik. All rights reserved.
//

@import CoreLocation;
#import "BKRangingViewController.h"
#import "MNBeaconManager.h"
#import "BKConstants.h"

@interface BKRangingViewController ()
@property (nonatomic, strong)MNBeaconManager *beaconManager;
@property (weak, nonatomic) IBOutlet UILabel *blueProximityLabel;
@property (weak, nonatomic) IBOutlet UILabel *purpleProximityLabel;
@property (weak, nonatomic) IBOutlet UILabel *greenProximityLabel;
@end


@implementation BKRangingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:BKProximityUUIDString]identifier:@"com.monokromik.beckoning"];
    
    self.beaconManager = [[MNBeaconManager alloc] init];
    [self.beaconManager addObserver:self forBeaconRegion:region];
    [self.beaconManager startRangingBeaconsInRegion:region];
    
    self.blueProximityLabel.text = @"Unknown";
    self.purpleProximityLabel.text =@"Unknown";
    self.greenProximityLabel.text = @"Unknown";
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - MNBeaconManagerDelegate
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)beaconManager:(MNBeaconManager *)beaconManager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {

    self.blueProximityLabel.text = @"Unknown";
    self.purpleProximityLabel.text =@"Unknown";
    self.greenProximityLabel.text = @"Unknown";

    if (beacons.count > 0) {
        for (CLBeacon *beacon in beacons) {
            if (beacon.major.intValue == BKBeaconMajorBlue) [self updateProximityLabel:self.blueProximityLabel forBeacon:beacon];
            else if (beacon.major.intValue == BKBeaconMajorPurple) [self updateProximityLabel:self.purpleProximityLabel forBeacon:beacon];
            else if (beacon.major.intValue == BKBeaconMajorGreen) [self updateProximityLabel:self.greenProximityLabel forBeacon:beacon];
        }
    }
}


- (void)updateProximityLabel:(UILabel *)label forBeacon:(CLBeacon *)beacon {
    NSString *labelValue;
    switch (beacon.proximity) {
        case CLProximityImmediate:
            labelValue = @"Immediate";
            break;
            
        case CLProximityNear:
            labelValue = @"Near";
            break;

        case CLProximityFar:
            labelValue = @"Far";
            break;

        case CLProximityUnknown:
            labelValue = @"Unknown";
            break;
            
        default:
            break;
    }
    
    label.text = labelValue;
}

@end
