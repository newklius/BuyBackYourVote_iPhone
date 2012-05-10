//
//  BillsDataController.m
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BillsDataController.h"
#import "Bill.h"

@implementation BillsDataController

@synthesize billsList = _billsList;

- (id)init {
    if (self = [super init]) {
        NSMutableArray *billsList = [[NSMutableArray alloc] init];
        self.billsList = billsList;
        return self;
    }
    return nil;
}

- (NSUInteger)countOfBillsList {
    return [self.billsList count];
}

- (Bill *)objectInBillsListAtIndex:(NSUInteger)index {
    return [self.billsList objectAtIndex:index];
}

- (void)addBillWithTitle:(NSString *)title number:(NSString *)number link:(NSString *)link summary:(NSString *)summary support:(BOOL)support {
    Bill *bill = [[Bill alloc] initWithTitle:title number:number link:link summary:summary support:support];
    [self.billsList addObject:bill];
}

@end
