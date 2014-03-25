//
//  UITableViewController+CustomCells.m
//  bcebook
//
//  Created by ivan on 10.5.11..
//  Copyright 2011 MobileWasp. All rights reserved.
//

#import "UITableViewController+CustomCells.h"

@implementation UITableViewController (CustomCells)

+ (UITableViewCell*) createCellFromXibWithId:(NSString*)cellIdentifier
{
	NSArray* nibContents = [[NSBundle mainBundle]
							loadNibNamed:@"CellDesign" owner:self options:NULL];
	
	NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
	UITableViewCell *customCell= nil;
	NSObject* nibItem = nil;
	while ( (nibItem = [nibEnumerator nextObject]) != nil) {
		if ( [nibItem isKindOfClass: [UITableViewCell class]]) {
			customCell = (UITableViewCell*) nibItem;
			if ([customCell.reuseIdentifier isEqualToString:cellIdentifier]) {
				break; // we have a winner
			}
		}
	}
	return customCell;
}

@end
