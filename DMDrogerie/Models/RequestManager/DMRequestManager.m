//
//  DMRequestManager.m
//  DMDrogerie
//
//  Created by Vlada on 2/26/15.
//  Copyright (c) 2015 Vlada. All rights reserved.
//

#import "DMRequestManager.h"

#import "DMDiscount.h"
#import "DMOffer.h"
#import "DMLocation.h"
#import "DMAktuelnost.h"
#import "DMPromotion.h"
#import "DMNailColor.h"
#import "DMHairColorManufacturer.h"

@interface DMRequestManager ()

@property (nonatomic, strong)AFHTTPRequestOperationManager* manager;

@end

@implementation DMRequestManager


- (id)init{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.manager = [AFHTTPRequestOperationManager manager];
    
    return self;
}

+ (DMRequestManager *)sharedManager {
    
    static DMRequestManager *singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[DMRequestManager alloc] init];
    });
    return singleton;
    
}

- (void)cancelRequests{
    [self.manager.operationQueue cancelAllOperations];
}

- (void)getDataWithResponse:(void(^)(BOOL success, NSDictionary* response, NSError *error))block{
    
//    http://dm-mobile.darijo73.mycpanel.rs/Data/data_final.json
//    @"http://dm-mobile.darijo73.mycpanel.rs/Data/data.json"
    [[AFHTTPRequestOperationManager manager] GET:@"http://dmbih.com/mobile" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        NSDictionary* dict = (NSDictionary *)responseObject;
        
        
        self.pdfDict = [dict objectForKey:@"pdf"];
        
        self.promoDict = [dict objectForKey:@"akt_pr"];
        
        NSDictionary* bannerHelper = [[NSUserDefaults standardUserDefaults] objectForKey:@"banner"];
        
        NSDictionary* tempBannerDict = [dict objectForKey:@"banner"];
        
        
        
        NSMutableDictionary* tempDict = [NSMutableDictionary dictionaryWithDictionary:tempBannerDict];
        if ([[bannerHelper objectForKey:@"id"] isEqualToString:[tempBannerDict objectForKey:@"id"]]) {
           
            [tempDict setObject:[NSNumber numberWithBool:NO] forKey:@"shouldShow"];
        }
        else{
            NSDate* lastDate = [bannerHelper objectForKey:@"lastDate"];
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd.MM.yyyy"];
            BOOL startedToday = [[formatter stringFromDate:lastDate] isEqualToString:[formatter stringFromDate:[NSDate date]]];
            if (startedToday) {
                [tempDict setObject:[NSNumber numberWithBool:NO] forKey:@"shouldShow"];
            }
            else{
                [tempDict setObject:[NSNumber numberWithBool:YES] forKey:@"shouldShow"];
                [tempDict setObject:[NSDate date] forKey:@"lastDate"];
                [tempDict setObject:[tempBannerDict objectForKey:@"id"] forKey:@"id"];
                self.bannerDict = [dict objectForKey:@"banner"];
            }
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:tempDict forKey:@"banner"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSArray* ponude = [NSArray arrayWithArray:[dict objectForKey:@"ponude"]];
        NSMutableArray* arrPonude = [NSMutableArray array];
        
        for (NSDictionary* ponuda in ponude) {
            DMOffer* offer = [[DMOffer alloc] initWithDictionary:ponuda];
            [arrPonude addObject:offer];
        }
        
        NSArray* popusti = [NSArray arrayWithArray:[dict objectForKey:@"popusti"]];
        NSMutableArray* arrPopusti = [NSMutableArray array];
        
        for (id popust in popusti) {
            if ([popust isKindOfClass:[NSDictionary class]]) {
                DMDiscount* discount = [[DMDiscount alloc] initWithDictionary:popust];
                [arrPopusti addObject:discount];
            }
            
        }
        
        NSArray* lokacije = [NSArray arrayWithArray:[dict objectForKey:@"lokacije"]];
        NSMutableArray* arrLokacije = [NSMutableArray array];
        
        for (id lokacija in lokacije) {
            
            if ([lokacija isKindOfClass:[NSDictionary class]]) {
                DMLocation* location = [[DMLocation alloc] initWithDictionary:lokacija];
                [arrLokacije addObject:location];
            }
            
        }
        
        NSArray* aktuelnosti = [NSArray arrayWithArray:[dict objectForKey:@"aktuelnosti"]];
        NSMutableArray* arrAktuelnosti = [NSMutableArray array];
        
        for (NSDictionary* aktuelnos in aktuelnosti) {
            DMAktuelnost* act = [[DMAktuelnost alloc] initWithDictionary:aktuelnos];
            [arrAktuelnosti addObject:act];
        }
        
        NSArray* promocije = [NSArray arrayWithArray:[dict objectForKey:@"promo"]];
        NSMutableArray* arrPromocije = [NSMutableArray array];
        
        for (NSDictionary* promocija in promocije) {
            DMPromotion* promption = [[DMPromotion alloc] initWithDictionary:promocija];
            [arrPromocije addObject:promption];
        }
        
        NSArray* nokti = [NSArray arrayWithArray:[dict objectForKey:@"nokti"]];
        NSMutableArray* arrNokti = [NSMutableArray array];
        
        for (NSDictionary* nail in nokti) {
            DMNailColor* nailColor = [[DMNailColor alloc] initWithDictionary:nail];
            [arrNokti addObject:nailColor];
        }
        
        self.arrayLocations = [NSArray arrayWithArray:arrLokacije];
        
        
        NSArray* boje = [NSArray arrayWithArray:[dict objectForKey:@"boje"]];
        self.arrayHairColors = [NSMutableArray array];
        
        for (id d in boje) {
            
            if ([d isKindOfClass:[NSDictionary class]]) {
                DMHairColorManufacturer* hairC = [[DMHairColorManufacturer alloc] initWithDictionary:d];
                [self.arrayHairColors addObject:hairC];
            }
            
        }
        
        
        self.finalDict = @{@"aktuelnosti": arrAktuelnosti,
                                    @"ponude": arrPonude,
                                    @"popusti": arrPopusti,
                                    @"lokacije": arrLokacije,
                                    @"promocije": arrPromocije,
                                    @"nokti": arrNokti
                                    };
        
        block(YES, self.finalDict, nil);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        block(NO, nil, error);
    }];
    
}

- (void)postDeviceToken:(NSString *)token withResponse:(void(^)(BOOL success, id response, NSError *error))block{
    

    
    NSString* urlsStr = [[NSString stringWithFormat:@"http://dm-mobile.darijo73.mycpanel.rs/ios_push/save_device.php"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest* req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlsStr parameters:nil error:nil];
    
    [req setHTTPMethod:@"POST"];
    
    
    NSData* data = [NSJSONSerialization dataWithJSONObject:@{@"token": @"qQBF&HCU9`ey#vDc9~*", @"deviceToken":token} options:NSJSONWritingPrettyPrinted error:nil];
    
    
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[data length]] forHTTPHeaderField:@"Content-Length"];
    [req setHTTPBody:data];
    
    
    AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
        
        block(YES, responseObject, nil);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        block(NO, nil, error);
    }];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [op start];
    
    
//    [[AFHTTPRequestOperationManager manager].requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    
//    [[AFHTTPRequestOperationManager manager] POST:@"http://dm-mobile.darijo73.mycpanel.rs/ios_push/save_device.php" parameters:@{@"token": @"qQBF&HCU9`ey#vDc9~*", @"deviceToken": token} success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        block(YES, responseObject, nil);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        block(NO, nil, error);
//    }];
    
    
}

@end
