//
//  BKFourSquareTrigger.h
//  Beckoning
//
//  Created by Ronnie Liew on 7/3/14.
//  Copyright (c) 2014 Monokromik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNBeaconManager.h"

@interface BKFourSquareTrigger : NSObject <MNBeaconManagerObserver>
- (void)beaconManager:(MNBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region;
- (BOOL)beaconManager:(MNBeaconManager *)manager shouldAutoStartRangingBeaconsInRegion:(CLBeaconRegion *)region;
@end
