//
//  BKFourSquareTrigger.m
//  Beckoning
//
//  Created by Ronnie Liew on 7/3/14.
//  Copyright (c) 2014 Monokromik. All rights reserved.
//

#import "BKFourSquareTrigger.h"
#import "BKConstants.h"
#import <Foursquare2.h>

@interface BKFourSquareTrigger ()
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTask;
@end



@implementation BKFourSquareTrigger
- (BOOL)beaconManager:(MNBeaconManager *)manager shouldAutoStartRangingBeaconsInRegion:(CLBeaconRegion *)region {
    return YES;
}



- (void)beaconManager:(MNBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    UIApplication *application = [UIApplication sharedApplication];
    NSArray *nearOrImmediateBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity == %ld || proximity == %ld",
                                                                            CLProximityImmediate, CLProximityNear]];
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask: self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    
    if (nearOrImmediateBeacons.count > 0) {
        [Foursquare2 checkinAddAtVenue:@"4bfdf724e93095217f2862ab" shout:@"Auto check-in" callback:^(BOOL success, id results){
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.alertBody = [NSString stringWithFormat:@"Checking into R/GA"];
            localNotification.alertAction = @"Launch app";
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            
            [application presentLocalNotificationNow:localNotification];
        }];

        [manager stopRangingBeaconsInRegion:region];
    }
    
    [application endBackgroundTask: self.backgroundTask];
    self.backgroundTask = UIBackgroundTaskInvalid;
}
@end
