//
//  ViewController.h
//  beaconReceiver
//
//  Created by hanks on 3/25/15.
//  Copyright (c) 2015 com.hanks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController : UIViewController <CLLocationManagerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;

@end

