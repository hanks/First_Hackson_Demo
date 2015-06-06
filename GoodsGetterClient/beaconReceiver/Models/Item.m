//
//  Item.m
//  beaconReceiver
//
//  Created by hanks on 5/23/15.
//  Copyright (c) 2015 com.hanks. All rights reserved.
//

#import "Item.h"

@implementation Item

- (instancetype)initWithName:(NSString *)itemName
                 description:(NSString *)description
                       major:(CLBeaconMajorValue)major
                       minor:(CLBeaconMinorValue)minor
                       price:(NSInteger)price
                    priority:(NSInteger)showPriority
                   imageName:(NSString *)imageName {
    self = [super init];
    
    if (self) {
        _itemName = itemName;
        _majorValue = major;
        _minorValue = major;
        _price = price;
        _showPriority = showPriority;
        _imageName = imageName;
        _desc = description;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    NSString *itemName = dict[@"name"];
    CLBeaconMajorValue majorValue = [dict[@"major"] intValue];
    CLBeaconMajorValue minorValue = [dict[@"minor"] intValue];
    NSInteger price = [dict[@"price"] intValue];
    NSInteger showPriority = [dict[@"showPriority"] intValue];
    NSString *imageName = dict[@"image_url"];
    NSString *desc = dict[@"description"];
    
    return [self initWithName:itemName
                  description:desc
                        major:majorValue
                        minor:minorValue
                        price:price
                     priority:showPriority
                    imageName:imageName];
}

@end
