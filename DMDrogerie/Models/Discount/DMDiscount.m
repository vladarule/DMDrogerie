//
//  DMDiscount.m
//  DMDrogerie
//
//  Created by Vlada on 2/8/14.
//  Copyright (c) 2014 Vlada. All rights reserved.
//

#import "DMDiscount.h"

@implementation DMDiscount

- (id)initWithDictionary:(NSDictionary *)dict{
	if (self = [super init]) {
        self.objectId = [dict objectForKey:@"id"];
		self.item = [dict objectForKey:@"proizvodjac"];
		self.name = [dict objectForKey:@"naziv"];
        self.descr = [dict objectForKey:@"opis"];
        self.quantity = [dict objectForKey:@"kolicina"];
        self.oldPrice = [dict objectForKey:@"staraC"];
        self.nwPrice = [dict objectForKey:@"novaC"];
        self.saving = [dict objectForKey:@"usteda"];
        self.discount = [dict objectForKey:@"popust"];
        self.activeTo = [dict objectForKey:@"akt"];
        self.image = [dict objectForKey:@"slika"];
        self.numberOfItems = [NSNumber numberWithInt:1];
        
        self.dmBrand = [NSNumber numberWithBool:[[dict objectForKey:@"dm_marka"] boolValue]];
        
        self.inCart = [NSNumber numberWithBool:NO];
        self.ref = [dict objectForKey:@"refJed"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.objectId forKey:@"objectId"];
    [encoder encodeObject:self.item forKey:@"item"];
    [encoder encodeObject:self.descr forKey:@"description"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.oldPrice forKey:@"oldPrice"];
    [encoder encodeObject:self.quantity forKey:@"quantity"];
    [encoder encodeObject:self.nwPrice forKey:@"nwPrice"];
    [encoder encodeObject:self.activeTo forKey:@"activeTo"];
    [encoder encodeObject:self.saving forKey:@"saving"];
    [encoder encodeObject:self.discount forKey:@"discount"];
    [encoder encodeObject:self.image forKey:@"image"];
    [encoder encodeObject:self.numberOfItems forKey:@"numberOfItems"];
    [encoder encodeObject:self.inCart forKey:@"inCart"];
    [encoder encodeObject:self.ref forKey:@"ref"];
    [encoder encodeObject:self.dmBrand forKey:@"dmBrand"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if( self != nil )
    {
        self.objectId = [decoder decodeObjectForKey:@"objectId"];
        self.item = [decoder decodeObjectForKey:@"item"];
        self.descr = [decoder decodeObjectForKey:@"description"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.oldPrice = [decoder decodeObjectForKey:@"oldPrice"];
        self.quantity = [decoder decodeObjectForKey:@"quantity"];
        self.nwPrice = [decoder decodeObjectForKey:@"nwPrice"];
        self.activeTo = [decoder decodeObjectForKey:@"activeTo"];
        self.saving = [decoder decodeObjectForKey:@"saving"];
        self.discount = [decoder decodeObjectForKey:@"discount"];
        self.image = [decoder decodeObjectForKey:@"image"];
        self.numberOfItems = [decoder decodeObjectForKey:@"numberOfItems"];
        self.inCart = [decoder decodeObjectForKey:@"inCart"];
        self.ref = [decoder decodeObjectForKey:@"ref"];
        self.dmBrand = [decoder decodeObjectForKey:@"dmBrand"];
        
    }
    return self;
}

@end
