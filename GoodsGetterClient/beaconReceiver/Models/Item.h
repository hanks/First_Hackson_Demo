//
//  Item.h
//  beaconReceiver
//
//  Created by hanks on 5/23/15.
//  Copyright (c) 2015 com.hanks. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

@interface Item : NSObject

@property (strong, nonatomic, readonly) NSString *itemName;
@property (strong, nonatomic, readonly) NSString *desc;
@property (nonatomic, readonly) CLBeaconMajorValue majorValue;
@property (nonatomic, readonly) CLBeaconMinorValue minorValue;
@property (nonatomic, readonly) NSInteger showPriority;
@property (nonatomic, readonly) NSInteger price;
@property (nonatomic, readonly) NSString* imageName;

- (instancetype)initWithName:(NSString *)itemName
                 description:(NSString *)desc
                       major:(CLBeaconMajorValue)major
                       minor:(CLBeaconMinorValue)minor
                       price:(NSInteger)price
                    priority:(NSInteger)showPriority
                   imageName:(NSString *)imageName;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
