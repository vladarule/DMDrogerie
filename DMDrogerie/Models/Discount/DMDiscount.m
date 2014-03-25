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
        self.objectId = [dict objectForKey:@"idPop"];
		self.item = [dict objectForKey:@"proiz"];
		self.name = [dict objectForKey:@"naziv"];
        self.description = [dict objectForKey:@"opis"];
        self.quantity = [dict objectForKey:@"kol"];
        self.oldPrice = [dict objectForKey:@"st_ce"];
        self.nwPrice = [dict objectForKey:@"no_ce"];
        self.saving = [dict objectForKey:@"ust"];
        self.discount = [dict objectForKey:@"pop"];
        self.activeTo = [dict objectForKey:@"akt"];
        self.image = [dict objectForKey:@"sl"];
        self.numberOfItems = [NSNumber numberWithInt:1];
        self.inCart = [NSNumber numberWithBool:NO];
        self.ref = [dict objectForKey:@"ref"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.objectId forKey:@"objectId"];
    [encoder encodeObject:self.item forKey:@"item"];
    [encoder encodeObject:self.description forKey:@"description"];
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
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if( self != nil )
    {
        self.objectId = [decoder decodeObjectForKey:@"objectId"];
        self.item = [decoder decodeObjectForKey:@"item"];
        self.description = [decoder decodeObjectForKey:@"description"];
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
        
    }
    return self;
}

@end
