//
//  ViewController.m
//  beaconReceiver
//
//  Created by hanks on 3/25/15.
//  Copyright (c) 2015 com.hanks. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ItemDetailViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "APIManager.h"
#import "Item.h"

static NSString * const kUUID = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";
static NSString * const kIdentifier = @"SomeIdentifier";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *distanceValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorValueLabel;
@property (nonatomic) NSNumber *minor;
@property (nonatomic) NSNumber *major;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up location manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate=self;
    self.locationManager.activityType = CLActivityTypeFitness;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    
    NSLog(@"Turning on ranging...");
    
    [self createBeaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    
    NSLog(@"Ranging turned on for region: %@.", self.beaconRegion);
    
    self.distanceValueLabel.text = [NSString stringWithFormat:@"%d m", 0];
    
}

- (IBAction)showPopUpView:(id)sender {
    ItemDetailViewController *detailViewController = [[ItemDetailViewController alloc] initWithNibName:@"ItemDetailViewController" bundle:nil];
    [detailViewController setMajor:@12];
    [detailViewController setMinor:@1];
    [self presentPopupViewController:detailViewController animationType:MJPopupViewAnimationSlideBottomTop];
}

- (IBAction)showNotification:(id)sender {
    [self vibratePhone];
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"localPush" ofType:@"mp3"];
    NSURL *pathURL = [NSURL fileURLWithPath : path];
    
    SystemSoundID audioEffect;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
    AudioServicesPlaySystemSound(audioEffect);
}

- (IBAction)fetchItem:(id)sender {
    SuccessCallback successcallback = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *aDictionary = (NSDictionary *)responseObject;
        NSString *message = [NSString stringWithFormat:@"Item name is %@", aDictionary[@"name"]];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Item Information"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    };
    
    // call api
    NSString *endpoint = @"/";
    [APIManager requestJSONWithEndpoint:endpoint successCallback:successcallback];
}

- (void)createBeaconRegion {
    if (self.beaconRegion)
        return;
    
    
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:kUUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                           identifier:kIdentifier];
    self.beaconRegion.notifyEntryStateOnDisplay= YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate

/*
 * When monitoring error
 */
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error{
    NSLog(@"monitoring Error");
}

/*
 * When enter region
 */
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    NSLog(@"Found Region");
    [self sendLocalPush:@"You find me, see detail"];
    [self vibratePhone];
}

/*
 * When leave region
 */
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    NSLog(@"didExitRegion");
    [self sendLocalPush:@"leave region"];
    [self vibratePhone];
}

/*
 * During monitoring
 */
- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region {
    
    if ([beacons count] == 0) {
        return ;
    }
    
    // now just handle one beacon
    CLBeacon *beacon = [beacons objectAtIndex:0];
    
    // update ibeacon info
    self.distanceValueLabel.text = [NSString stringWithFormat:@"%f m", beacon.accuracy];
    self.majorValueLabel.text = [NSString stringWithFormat:@"%@", beacon.major];
    self.minorValueLabel.text = [NSString stringWithFormat:@"%@", beacon.minor];
    
    // update minor and major
    self.major = beacon.major;
    self.minor = beacon.minor;
}

#pragma mark - Utilities

/*
 * Send local push
 */
- (void)sendLocalPush:(NSString *)msg {
    UILocalNotification *localPush = [[UILocalNotification alloc] init];
    localPush.alertBody = msg;
    localPush.soundName = @"localPush.mp3";
    localPush.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.5];
    localPush.applicationIconBadgeNumber = 1;
    
    // send major and minor info in the local push
    NSDictionary *infoDic = @{
                          @"major": self.major,
                          @"minor": self.minor,
                        };
    localPush.userInfo = infoDic;
    
    // send local push
    [[UIApplication sharedApplication] scheduleLocalNotification:localPush];
}

/*
 * Make phone vibration
 */
- (void)vibratePhone {
    // double vibration to emphasize
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            sleep(1);
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            sleep(1);
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        });
    });
}

@end
