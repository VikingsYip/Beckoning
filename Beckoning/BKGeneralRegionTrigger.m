//
//  BKGeneralRegionTrigger.m
//  Beckoning
//
//  Created by Ronnie Liew on 10/3/14.
//  Copyright (c) 2014 Monokromik. All rights reserved.
//

#import "BKGeneralRegionTrigger.h"




@implementation BKGeneralRegionTrigger
- (void)beaconManager:(MNBeaconManager *)manager didEnterRegion:(CLBeaconRegion *)region {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = [NSString stringWithFormat:@"Entering region: %@", region.identifier];
    localNotification.alertAction = @"Launch app";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}


- (void)beaconManager:(MNBeaconManager *)manager didExitRegion:(CLBeaconRegion *)region {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = [NSString stringWithFormat:@"Exiting beacons: %@", region.identifier];
    localNotification.alertAction = @"Launch app";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}
@end
