//
//  APIManager.h
//  beaconReceiver
//
//  Created by hanks on 5/23/15.
//  Copyright (c) 2015 com.hanks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@import CoreLocation;

typedef void (^SuccessCallback)(AFHTTPRequestOperation *operation, id responseObject);

@interface APIManager : NSObject

+ (void)requestJSONWithEndpoint:(NSString *)endpoint
            successCallback:(SuccessCallback)successCallback;
+ (void)requestImageWithEndpoint:(NSString *)endpoint
                 successCallback:(SuccessCallback)successCallback;
+ (NSString *)buildURLWithEndpoint:(NSString *)endpoint;

@end
