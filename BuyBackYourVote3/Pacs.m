//
//  Pacs.m
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Pacs.h"

@implementation Pacs

@synthesize pacName = _pacName, cycle = _cycle, seat = _seat, state = _state, party = _party, amount = _amount;

-(id)initWithName:(NSString *)name cycle:(NSString *)cycle seat:(NSString *)seat state:(NSString *)state party:(NSString *)party amount:(NSNumber *)amount {
    self = [super init];
    if (self) {
        _pacName = name;
        _cycle = cycle;
        _seat = seat;
        _state = state;
        _party = party;
        _amount = amount;
        return self;
    }
    return nil;
}

@end
