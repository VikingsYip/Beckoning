//
//  BKAppDelegate.m
//  Beckoning
//
//  Created by Ronnie Liew on 14/2/14.
//  Copyright (c) 2014 Monokromik. All rights reserved.
//

@import CoreLocation;
#import "BKAppDelegate.h"
#import "MNBeaconManager.h"
#import <Foursquare2.h>
#import "BKConstants.h"
#import "BKFourSquareTrigger.h"
#import "BKGeneralRegionTrigger.h"

@interface BKAppDelegate() <MNBeaconManagerObserver>
@property (nonatomic, strong) MNBeaconManager *beaconManager;
@property (nonatomic, strong) BKFourSquareTrigger *foursquareTrigger;
@property (nonatomic, strong) BKGeneralRegionTrigger *generalRegionTrigger;
@end



@implementation BKAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Foursquare2 setupFoursquareWithClientId:@"QIIFRPAMQRFHOKIRRSV1D5K2JVF3GFPOAD3MSU0VYHIZW1VG"
                                      secret:@"V4QWF4Y0EAUFMVWI0W1H4KEI2CDKHDY1DPXPHLMSVHXM2JWI"
                                 callbackURL:@"beckoning://foursquare"];

    CLBeaconRegion *regionFor4SQ = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:BKProximityUUIDString]
                                                                           major:BKBeaconMajorPurple
                                                                      identifier:BKProximityIdentifierFoursquare];

    CLBeaconRegion *regionForGeneral = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:BKProximityUUIDString]
                                                                      identifier:BKProximityIdentifierGeneral];

    
    self.beaconManager = [[MNBeaconManager alloc] init];
    self.foursquareTrigger = [[BKFourSquareTrigger alloc] init];
    self.generalRegionTrigger = [[BKGeneralRegionTrigger alloc] init];
    
    [self.beaconManager addObserver:self.foursquareTrigger forBeaconRegion:regionFor4SQ];
    [self.beaconManager addObserver:self.generalRegionTrigger forBeaconRegion:regionForGeneral];
    
    return YES;
}



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [Foursquare2 handleURL:url];
}
@end
