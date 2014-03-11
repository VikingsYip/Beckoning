//
//  BKGeneralRegionTrigger.h
//  Beckoning
//
//  Created by Ronnie Liew on 10/3/14.
//  Copyright (c) 2014 Monokromik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNBeaconManager.h"

@interface BKGeneralRegionTrigger : NSObject <MNBeaconManagerObserver>
- (void)beaconManager:(MNBeaconManager *)manager didEnterRegion:(CLBeaconRegion *)region;
- (void)beaconManager:(MNBeaconManager *)manager didExitRegion:(CLBeaconRegion *)region;
@end
