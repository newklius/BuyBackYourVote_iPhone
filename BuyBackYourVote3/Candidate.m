//
//  Candidate.m
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Candidate.h"

@implementation Candidate

@synthesize candidateName = _candidateName, cycle = _cycle, seat = _seat, state = _state, party = _party, amount = _amount, support = _support;

-(id)initWithName:(NSString *)name cycle:(NSString *)cycle seat:(NSString *)seat state:(NSString *)state party:(NSString *)party amount:(NSNumber *)amount support:(BOOL)support {
    self = [super init];
    if (self) {
        _candidateName = name;
        _cycle = cycle;
        _seat = seat;
        _state = state;
        _party = party;
        _amount = amount;
        _support = support;
        return self;
    }
    return nil;
}

@end
