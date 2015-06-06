//
//  APIManager.m
//  beaconReceiver
//
//  Created by hanks on 5/23/15.
//  Copyright (c) 2015 com.hanks. All rights reserved.
//

#import "APIManager.h"

// detect run on simulator or not, because the server ip is different between simulator and device
#if TARGET_IPHONE_SIMULATOR
static NSString * const BaseURLString = @"http://192.168.59.103:8080";
#else
static NSString * const BaseURLString = @"http://192.168.1.40";
#endif

typedef NS_ENUM(NSUInteger, RESPONSE_TYPE) {
    RESPONSE_JSON,
    RESPONSE_IMG,
};


@implementation APIManager

+ (void)requestJSONWithEndpoint:(NSString *)endpoint
            successCallback:(SuccessCallback)successCallback {
    [APIManager _requestWithEndpoint:endpoint responseType:RESPONSE_JSON successCallback:successCallback];}

+ (void)requestImageWithEndpoint:(NSString *)endpoint
                successCallback:(SuccessCallback)successCallback {
    [APIManager _requestWithEndpoint:endpoint responseType:RESPONSE_IMG successCallback:successCallback];
}

+ (void)_requestWithEndpoint:(NSString *)endpoint
                responseType:(RESPONSE_TYPE)type
             successCallback:(SuccessCallback)successCallback {
    NSString *string = [APIManager buildURLWithEndpoint:endpoint];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // set response type
    switch (type) {
        case RESPONSE_JSON:
            operation.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case RESPONSE_IMG:
            operation.responseSerializer = [AFImageResponseSerializer serializer];
            break;
    }
    
    // define a failure callback block
    void (^failureCallback)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Item"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    };
    
    // set block callback
    [operation setCompletionBlockWithSuccess:successCallback
                                     failure:failureCallback];
    
    [operation start];

}

+ (NSString *)buildURLWithEndpoint:(NSString *)endpoint {
    return [NSString stringWithFormat:@"%@%@", BaseURLString, endpoint];
}

@end
