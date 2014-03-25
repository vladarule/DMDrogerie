//
//  DMOffer.m
//  DMDrogerie
//
//  Created by Vlada on 2/8/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import "DMOffer.h"

@implementation DMOffer

- (id)initWithDictionary:(NSDictionary *)dict{
    
	if (self = [super init]) {
        self.objectId = [dict objectForKey:@"idPon"];
		self.title = [dict objectForKey:@"naslov"];
		self.description = [dict objectForKey:@"opis"];
        self.detailDescription = [dict objectForKey:@"det_op"];
        self.price = [dict objectForKey:@"cen"];
        self.quantity = [dict objectForKey:@"kol"];
        self.time = [dict objectForKey:@"vreme"];
        self.activeTo = [dict objectForKey:@"akt"];
        self.imageSmall = [dict objectForKey:@"sl_l"];
        self.imageBig = [dict objectForKey:@"sl_d"];
        self.numberOfItems = [NSNumber numberWithInt:1];
        self.inCart = [NSNumber numberWithBool:NO];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.objectId forKey:@"objectId"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.description forKey:@"description"];
    [encoder encodeObject:self.detailDescription forKey:@"detailDescription"];
    [encoder encodeObject:self.price forKey:@"price"];
    [encoder encodeObject:self.quantity forKey:@"quantity"];
    [encoder encodeObject:self.time forKey:@"time"];
    [encoder encodeObject:self.activeTo forKey:@"activeTo"];
    [encoder encodeObject:self.imageSmall forKey:@"imageSmall"];
    [encoder encodeObject:self.imageBig forKey:@"imageBig"];
    [encoder encodeObject:self.numberOfItems forKey:@"numberOfItems"];
    [encoder encodeObject:self.inCart forKey:@"inCart"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if( self != nil )
    {
        self.objectId = [decoder decodeObjectForKey:@"objectId"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.description = [decoder decodeObjectForKey:@"description"];
        self.detailDescription = [decoder decodeObjectForKey:@"detailDescription"];
        self.price = [decoder decodeObjectForKey:@"price"];
        self.quantity = [decoder decodeObjectForKey:@"quantity"];
        self.time = [decoder decodeObjectForKey:@"time"];
        self.activeTo = [decoder decodeObjectForKey:@"activeTo"];
        self.imageSmall = [decoder decodeObjectForKey:@"imageSmall"];
        self.imageSmall = [decoder decodeObjectForKey:@"imageBig"];
        self.numberOfItems = [decoder decodeObjectForKey:@"numberOfItems"];
        self.inCart = [decoder decodeObjectForKey:@"inCart"];
        
    }
    return self;
}

@end
