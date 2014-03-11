//
//  MNBeaconManagerTest.m
//  Beckoning
//
//  Created by Ronnie Liew on 9/3/14.
//  Copyright (c) 2014 Monokromik. All rights reserved.
//

#define EXP_SHORTHAND
#define MOCKITO_SHORTHAND

#import <Specta.h>
#import <Expecta.h>
#import <OCMockito/OCMockito.h>
#import "MNBeaconManager.h"

SpecBegin(MNBeaconManager)

describe(@"MNBeaconManager", ^{
    __block MNBeaconManager *beaconManager;
    __block CLBeaconRegion *beaconRegion;
    __block CLBeaconRegion *altBeaconRegion;
    __block id<MNBeaconManagerObserver>observerForMainOnly;
    __block id<MNBeaconManagerObserver>observerForAltOnly;
    __block id<MNBeaconManagerObserver>observerForMainAndAlt;

    context(@"when handing observers", ^{
        beforeAll(^{
            beaconManager = [[MNBeaconManager alloc] init];
            beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[NSUUID UUID] identifier:@"main"];
            altBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[NSUUID UUID] identifier:@"alt"];
            
            observerForMainOnly = mockObjectAndProtocol([NSObject class], @protocol(MNBeaconManagerObserver));
            observerForAltOnly = mockObjectAndProtocol([NSObject class], @protocol(MNBeaconManagerObserver));
            observerForMainAndAlt = mockObjectAndProtocol([NSObject class], @protocol(MNBeaconManagerObserver));
        });

        it(@"adds observers", ^{
            [beaconManager addObserver:observerForMainOnly forBeaconRegion:beaconRegion];
            [beaconManager addObserver:observerForAltOnly forBeaconRegion:altBeaconRegion];
            [beaconManager addObserver:observerForMainAndAlt forBeaconRegion:beaconRegion];
            [beaconManager addObserver:observerForMainAndAlt forBeaconRegion:altBeaconRegion];
            
            expect([beaconManager observersForBeaconRegion:beaconRegion]).to.haveCountOf(2);
            expect([beaconManager observersForBeaconRegion:beaconRegion]).to.contain(observerForMainOnly);
            expect([beaconManager observersForBeaconRegion:beaconRegion]).to.contain(observerForMainAndAlt);
            
            expect([beaconManager observersForBeaconRegion:altBeaconRegion]).to.haveCountOf(2);
            expect([beaconManager observersForBeaconRegion:altBeaconRegion]).to.contain(observerForMainAndAlt);
            expect([beaconManager observersForBeaconRegion:altBeaconRegion]).to.contain(observerForAltOnly);
        });
        
        it(@"replaces existing observer if observer is re-added", ^{
            [beaconManager addObserver:observerForMainOnly forBeaconRegion:beaconRegion];
            
            expect([beaconManager observersForBeaconRegion:beaconRegion]).to.haveCountOf(2);
            expect([beaconManager observersForBeaconRegion:beaconRegion]).to.contain(observerForMainOnly);
            expect([beaconManager observersForBeaconRegion:beaconRegion]).to.contain(observerForMainAndAlt);
        });

        it(@"removes observers", ^{
            [beaconManager removeObserver:observerForAltOnly forBeaconRegion:altBeaconRegion];
            [beaconManager removeObserver:observerForMainAndAlt forBeaconRegion:beaconRegion];
            [beaconManager removeObserver:observerForMainAndAlt forBeaconRegion:altBeaconRegion];
            
            expect([beaconManager observersForBeaconRegion:beaconRegion]).to.haveCountOf(1);
            expect([beaconManager observersForBeaconRegion:beaconRegion].firstObject).to.beIdenticalTo(observerForMainOnly);
            expect([beaconManager observersForBeaconRegion:altBeaconRegion]).to.haveCountOf(0);
        });

        it(@"ignores removal of observers if observer is not added for the region", ^{
            [beaconManager removeObserver:observerForAltOnly forBeaconRegion:beaconRegion];

            expect([beaconManager observersForBeaconRegion:beaconRegion]).to.haveCountOf(1);
            expect([beaconManager observersForBeaconRegion:beaconRegion].firstObject).to.beIdenticalTo(observerForMainOnly);
        });
    });
    
    context(@"when notifiying observers for region monitoring", ^{
        beforeAll(^{
            beaconManager = [[MNBeaconManager alloc] init];
            beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[NSUUID UUID] identifier:@"main"];
            altBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[NSUUID UUID] identifier:@"alt"];
        });
        
        
        beforeEach(^{
            observerForMainOnly = mockObjectAndProtocol([NSObject class], @protocol(MNBeaconManagerObserver));
            observerForAltOnly = mockObjectAndProtocol([NSObject class], @protocol(MNBeaconManagerObserver));
            observerForMainAndAlt = mockObjectAndProtocol([NSObject class], @protocol(MNBeaconManagerObserver));
            
            [beaconManager addObserver:observerForMainOnly forBeaconRegion:beaconRegion];
            [beaconManager addObserver:observerForAltOnly forBeaconRegion:altBeaconRegion];
            [beaconManager addObserver:observerForMainAndAlt forBeaconRegion:beaconRegion];
            [beaconManager addObserver:observerForMainAndAlt forBeaconRegion:altBeaconRegion];
            
        });
        
        it(@"notifies observers when entering region", ^{
            [beaconManager locationManager:nil didEnterRegion:beaconRegion];
            
            [verify(observerForMainOnly) beaconManager:beaconManager didEnterRegion:beaconRegion];
            [verify(observerForMainAndAlt) beaconManager:beaconManager didEnterRegion:beaconRegion];

            [verifyCount(observerForAltOnly, never()) beaconManager:beaconManager didEnterRegion:beaconRegion];
            [verifyCount(observerForMainOnly, never()) beaconManager:beaconManager didEnterRegion:altBeaconRegion];

            [verifyCount(observerForMainOnly, never()) beaconManager:beaconManager didExitRegion:beaconRegion];
            [verifyCount(observerForMainAndAlt, never()) beaconManager:beaconManager didExitRegion:altBeaconRegion];
        });

        it(@"notifies observers when exiting region", ^{
            [beaconManager locationManager:nil didExitRegion:beaconRegion];
            
            [verify(observerForMainOnly) beaconManager:beaconManager didExitRegion:beaconRegion];
            [verify(observerForMainAndAlt) beaconManager:beaconManager didExitRegion:beaconRegion];

            [verifyCount(observerForAltOnly, never()) beaconManager:beaconManager didExitRegion:beaconRegion];
            [verifyCount(observerForMainOnly, never()) beaconManager:beaconManager didExitRegion:altBeaconRegion];
            
            [verifyCount(observerForMainOnly, never()) beaconManager:beaconManager didEnterRegion:beaconRegion];
            [verifyCount(observerForMainAndAlt, never()) beaconManager:beaconManager didEnterRegion:altBeaconRegion];
        });
        
        it(@"notifies observers when monitoring failed for region", ^{
            [beaconManager locationManager:nil monitoringDidFailForRegion:beaconRegion withError:nil];
            
            [verify(observerForMainOnly) beaconManager:beaconManager monitoringDidFailForRegion:beaconRegion withError:nil];
            [verify(observerForMainAndAlt) beaconManager:beaconManager monitoringDidFailForRegion:beaconRegion withError:nil];
            [verifyCount(observerForAltOnly, never()) beaconManager:beaconManager monitoringDidFailForRegion:beaconRegion withError:nil];
        });
    });
    
    context(@"when notifiying observers for ranging", ^{
        beforeAll(^{
            beaconManager = [[MNBeaconManager alloc] init];
            NSUUID *uuid = [NSUUID UUID];
            beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"main"];
            altBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:23 identifier:@"alt"];
            
            observerForMainOnly = mockObjectAndProtocol([NSObject class], @protocol(MNBeaconManagerObserver));
            observerForAltOnly = mockObjectAndProtocol([NSObject class], @protocol(MNBeaconManagerObserver));
            observerForMainAndAlt = mockObjectAndProtocol([NSObject class], @protocol(MNBeaconManagerObserver));
            
            [beaconManager addObserver:observerForMainOnly forBeaconRegion:beaconRegion];
            [beaconManager addObserver:observerForAltOnly forBeaconRegion:altBeaconRegion];
            [beaconManager addObserver:observerForMainAndAlt forBeaconRegion:beaconRegion];
            [beaconManager addObserver:observerForMainAndAlt forBeaconRegion:altBeaconRegion];
           

            [given([observerForMainAndAlt beaconManager:beaconManager shouldAutoStartRangingBeaconsInRegion:beaconRegion]) willReturnBool:YES];
            [given([observerForMainAndAlt beaconManager:beaconManager shouldAutoStartRangingBeaconsInRegion:altBeaconRegion]) willReturnBool:YES];
            [given([observerForMainOnly beaconManager:beaconManager shouldAutoStartRangingBeaconsInRegion:beaconRegion]) willReturnBool:NO];
        });
        
        it(@"checks for auto ranging", ^{
            [beaconManager locationManager:nil didDetermineState:CLRegionStateInside forRegion:beaconRegion];
            [beaconManager locationManager:nil didEnterRegion:beaconRegion];
            
            [verify(observerForMainOnly) beaconManager:beaconManager shouldAutoStartRangingBeaconsInRegion:beaconRegion];
            [verify(observerForMainAndAlt) beaconManager:beaconManager shouldAutoStartRangingBeaconsInRegion:beaconRegion];

            [verifyCount(observerForMainOnly, never()) beaconManager:beaconManager shouldAutoStartRangingBeaconsInRegion:altBeaconRegion];
            [verifyCount(observerForMainAndAlt, never()) beaconManager:beaconManager shouldAutoStartRangingBeaconsInRegion:altBeaconRegion];
            [verifyCount(observerForAltOnly, never()) beaconManager:beaconManager shouldAutoStartRangingBeaconsInRegion:beaconRegion];

        });
        
        it(@"does auto ranging", ^{
            [beaconManager locationManager:nil didDetermineState:CLRegionStateInside forRegion:beaconRegion];
            [beaconManager locationManager:nil didEnterRegion:beaconRegion];
            [beaconManager locationManager:nil didRangeBeacons:nil inRegion:beaconRegion];

            [verify(observerForMainAndAlt) beaconManager:beaconManager didRangeBeacons:nil inRegion:beaconRegion];

            [verifyCount(observerForAltOnly, never()) beaconManager:beaconManager didRangeBeacons:nil inRegion:beaconRegion];
            [verifyCount(observerForMainOnly, never()) beaconManager:beaconManager didRangeBeacons:nil inRegion:altBeaconRegion];
            [verifyCount(observerForMainAndAlt, never()) beaconManager:beaconManager didRangeBeacons:nil inRegion:altBeaconRegion];


        });
    });
});

SpecEnd