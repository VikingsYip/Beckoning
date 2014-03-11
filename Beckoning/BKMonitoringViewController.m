//
//  BKMonitoringViewController.m
//  Beckoning
//
//  Created by Ronnie Liew on 25/2/14.
//  Copyright (c) 2014 Monokromik. All rights reserved.
//

@import CoreLocation;
#import "BKMonitoringViewController.h"
#import "BKConstants.h"
#import "MNBeaconManager.h"



@interface BKMonitoringViewController ()
@property (strong, nonatomic) CLBeaconRegion *generalRegion;
@property (strong, nonatomic) CLBeaconRegion *foursquareRegion;
@property (weak, nonatomic) IBOutlet UISwitch *monitorGeneralRegionSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *monitor4sqSwitch;
@property (strong ,nonatomic) MNBeaconManager *beaconManager;
@end

@implementation BKMonitoringViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUUID *UUID = [[NSUUID alloc] initWithUUIDString:BKProximityUUIDString];
    
    self.beaconManager = [[MNBeaconManager alloc] init];
    self.generalRegion = [[CLBeaconRegion alloc] initWithProximityUUID:UUID identifier:BKProximityIdentifierGeneral];
    self.foursquareRegion = [[CLBeaconRegion alloc] initWithProximityUUID:UUID major:BKBeaconMajorPurple identifier:BKProximityIdentifierFoursquare];
    
    NSSet *monitoredRegions = self.beaconManager.monitoredRegions;
    
    
    self.monitorGeneralRegionSwitch.on = [monitoredRegions member:self.generalRegion] ? YES : NO;
    self.monitor4sqSwitch.on = [monitoredRegions member:self.foursquareRegion] ? YES: NO;

    [self.monitorGeneralRegionSwitch addTarget:self action:@selector(monitoringChanged:) forControlEvents:UIControlEventValueChanged];
    [self.monitor4sqSwitch addTarget:self action:@selector(monitoringChanged:) forControlEvents:UIControlEventValueChanged];
}


- (void)monitoringChanged:(id)sender {
    UISwitch *regionSwitch = (UISwitch *)sender;
    CLBeaconRegion *region = (regionSwitch == self.monitorGeneralRegionSwitch) ? self.generalRegion : self.foursquareRegion;
    
    if (regionSwitch.on) {
        [self.beaconManager registerBeaconRegion:region];
    }
    else {
        [self.beaconManager unregisterBeaconRegion:region];
    }
}

@end
