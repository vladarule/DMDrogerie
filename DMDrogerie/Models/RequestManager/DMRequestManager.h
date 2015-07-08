//
//  DMRequestManager.h
//  DMDrogerie
//
//  Created by Vlada on 2/26/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface DMRequestManager : NSObject

+ (DMRequestManager* )sharedManager;

- (void)getDataWithResponse:(void(^)(BOOL success, NSDictionary* response, NSError *error))block;

- (void)postDeviceToken:(NSString *)token withResponse:(void(^)(BOOL success, id response, NSError *error))block;

@property (nonatomic, strong)NSDictionary* promoDict;
@property (nonatomic, strong)NSDictionary* bannerDict;

@property (nonatomic, strong)NSArray* arrayLocations;
@property (nonatomic, strong)NSDictionary* pdfDict;

@property (nonatomic, strong)NSDictionary* finalDict;

@property (nonatomic, strong)NSMutableArray* arrayHairColors;

- (void)cancelRequests;


@end
