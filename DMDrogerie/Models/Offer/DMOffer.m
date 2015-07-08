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
        self.objectId = [dict objectForKey:@"id"];
		self.title = [dict objectForKey:@"naslov"];
		self.descr = [dict objectForKey:@"opis"];
        self.detailDescription = [dict objectForKey:@"det_opis"];
        self.price = [dict objectForKey:@"cena"];
        self.quantity = [dict objectForKey:@"kolicina"];
        self.time = [dict objectForKey:@"vreme"];
        self.activeTo = [dict objectForKey:@"akt"];
        self.imageSmall = [dict objectForKey:@"slika_mala"];
        self.imageBig = [dict objectForKey:@"slika_velika"];
        self.link = [dict objectForKey:@"link"];
        self.isNew = [NSNumber numberWithBool:[[dict objectForKey:@"novo"] boolValue]];
        
        self.numberOfItems = [NSNumber numberWithInt:1];
        self.inCart = [NSNumber numberWithBool:NO];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.objectId forKey:@"objectId"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.descr forKey:@"description"];
    [encoder encodeObject:self.detailDescription forKey:@"detailDescription"];
    [encoder encodeObject:self.price forKey:@"price"];
    [encoder encodeObject:self.quantity forKey:@"quantity"];
    [encoder encodeObject:self.time forKey:@"time"];
    [encoder encodeObject:self.activeTo forKey:@"activeTo"];
    [encoder encodeObject:self.imageSmall forKey:@"imageSmall"];
    [encoder encodeObject:self.imageBig forKey:@"imageBig"];
    [encoder encodeObject:self.numberOfItems forKey:@"numberOfItems"];
    [encoder encodeObject:self.inCart forKey:@"inCart"];
    
    [encoder encodeObject:self.link forKey:@"link"];
    [encoder encodeObject:self.isNew forKey:@"isNew"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if( self != nil )
    {
        self.objectId = [decoder decodeObjectForKey:@"objectId"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.descr = [decoder decodeObjectForKey:@"description"];
        self.detailDescription = [decoder decodeObjectForKey:@"detailDescription"];
        self.price = [decoder decodeObjectForKey:@"price"];
        self.quantity = [decoder decodeObjectForKey:@"quantity"];
        self.time = [decoder decodeObjectForKey:@"time"];
        self.activeTo = [decoder decodeObjectForKey:@"activeTo"];
        self.imageSmall = [decoder decodeObjectForKey:@"imageSmall"];
        self.imageSmall = [decoder decodeObjectForKey:@"imageBig"];
        self.numberOfItems = [decoder decodeObjectForKey:@"numberOfItems"];
        self.inCart = [decoder decodeObjectForKey:@"inCart"];
        self.link = [decoder decodeObjectForKey:@"link"];
        self.isNew = [decoder decodeObjectForKey:@"isNew"];
        
    }
    return self;
}

@end
