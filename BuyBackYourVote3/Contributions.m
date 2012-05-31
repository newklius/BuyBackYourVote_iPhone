//
//  Contributions.m
//  BuyBackYourVote3
//
//  Created by Timothy Bauman on 5/29/12.
//  Copyright (c) 2012 Undergraduate Class of 2013. All rights reserved.
//

#import "Contributions.h"

@implementation Contributions
@synthesize list;

-(id)init {
    self = [super init];
    if (self) {
        return self;
    }
    return nil;
}

-(id)initWithJSON:(NSData *)jsonData {
    self = [super init];
    if (self) {
        [self loadFromJSON:jsonData];
        return self;
    }
    return nil;
}
         
-(void)loadFromJSON:(NSData *)jsonData {
     
    NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
     
    NSArray *jsonCols = [jsonResults objectForKey:@"cols"];
    NSArray *jsonRows = [jsonResults objectForKey:@"rows"];
    
    NSMutableArray *nameList = [[NSMutableArray alloc] init];
    NSMutableArray *yearList = [[NSMutableArray alloc] init];
    NSMutableArray *seatList = [[NSMutableArray alloc] init];
    NSMutableArray *stateList = [[NSMutableArray alloc] init];
    NSMutableArray *partyList = [[NSMutableArray alloc] init];
    NSMutableArray *amountList = [[NSMutableArray alloc] init];
    NSMutableArray *supportList = [[NSMutableArray alloc] init];
    NSMutableDictionary *colsIndex = [[NSMutableDictionary alloc] init];
    
    int i = 0;
    
    for (NSDictionary *row in jsonCols) {
        [colsIndex setValue:[NSNumber numberWithInt:i] forKey:[row objectForKey:@"id"]];
        i++;
    }
     
    for (NSDictionary *row in jsonRows) {
        NSArray *c = [row objectForKey:@"c"];
        [yearList addObject:[[c objectAtIndex:[[colsIndex objectForKey:@"Election year"] intValue]] objectForKey:@"v"]];
        NSString *seat = [[c objectAtIndex:[[colsIndex objectForKey:@"Seat"] intValue]] objectForKey:@"v"];
        [seatList addObject:seat];
        NSString *state = [[c objectAtIndex:[[colsIndex objectForKey:@"State"] intValue]] objectForKey:@"v"];
        [stateList addObject:state];
        [amountList addObject:[[c objectAtIndex:[[colsIndex objectForKey:@"Donations"] intValue]] objectForKey:@"v"]];
        NSNumber *support = [[c objectAtIndex:[[colsIndex objectForKey:@"Supporting"] intValue]] objectForKey:@"v"];
        [supportList addObject:support];
        NSString *name = [[c objectAtIndex:[[colsIndex objectForKey:@"Candidate"] intValue]] objectForKey:@"v"];
        NSString *party = [[c objectAtIndex:[[colsIndex objectForKey:@"Party"] intValue]] objectForKey:@"v"];
        
        NSString *formattedName;
        
        if ([seat isEqualToString:@"President"])
            seat = [NSString stringWithFormat:@"%c", [seat characterAtIndex:0]];
        else
            seat = [NSString stringWithFormat:@"%c-%@", [seat characterAtIndex:0], state];
        
        if ([support intValue] == 1) {
            formattedName = [NSString stringWithFormat:@"For %@ (%@, %c)", name, seat, [party characterAtIndex:0]];
        } else {
            formattedName = [NSString stringWithFormat:@"Against %@ (%@, %c)", name, seat, [party characterAtIndex:0]];
        }
        [nameList addObject:formattedName];
        NSString *formattedParty;
        if ([support intValue] == 1) {
            formattedParty = [NSString stringWithFormat:@"For %@", party];
        } else {
            formattedParty = [NSString stringWithFormat:@"Against %@", party];
        }
        [partyList addObject:formattedParty];
    }
    names = [NSArray arrayWithArray:nameList];
    years = [NSArray arrayWithArray:yearList];
    seats = [NSArray arrayWithArray:seatList];
    states = [NSArray arrayWithArray:stateList];
    parties = [NSArray arrayWithArray:partyList];
    amounts = [NSArray arrayWithArray:amountList];
    supports = [NSArray arrayWithArray:supportList];
    
        //[contributions addContributionWithName:candidateName cycle:cycle seat:seat state:state party:party amount:amount];
}

- (void)filterWithGrouping:(NSString *)grouping state:(NSString *)state seat:(NSString *)seat {
    if (grouping == groupingFilter && state == stateFilter && seat == seatFilter)
        return;
    groupingFilter = grouping;
    stateFilter = state;
    seatFilter = seat;
    if ([grouping isEqualToString:@"candidate"]) {
        // shortcut: the JSON results should already be sorted
        NSMutableArray *topList = [[NSMutableArray alloc] init];
        for (int i = 0; i < [amounts count]; i++) {
            if ((state == nil || [state isEqualToString:[states objectAtIndex:i]]) &&
                (seat == nil || [seat isEqualToString:[seats objectAtIndex:i]])) {
                NSArray *item = [NSArray arrayWithObjects:[names objectAtIndex:i], [amounts objectAtIndex:i], nil];
                [topList addObject:item];
            }
        }
        self.list = [NSArray arrayWithArray:topList];
    } else {
        NSMutableDictionary *groupings = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < [amounts count]; i++) {
            if ((state == nil || [state isEqualToString:[states objectAtIndex:i]]) &&
                (seat == nil || [seat isEqualToString:[seats objectAtIndex:i]])) {
                NSString *party = [parties objectAtIndex:i];
                NSNumber *sum = [groupings objectForKey:party];
                if (sum == nil || [sum isKindOfClass:[NSNull class]])
                    sum = [amounts objectAtIndex:i];
                else
                    sum = [NSNumber numberWithInt:([sum intValue] + [[amounts objectAtIndex:i] intValue])];
                [groupings setValue:sum forKey:party];
            }
        }
        NSMutableArray *topList = [[NSMutableArray alloc] init];
        NSArray *keys = [groupings keysSortedByValueUsingSelector:@selector(compare:)];
        
        for (NSString *key in [keys reverseObjectEnumerator]) {
            NSNumber *n = [groupings objectForKey:key];
            NSArray *item = [NSArray arrayWithObjects:key, n, nil];
            [topList addObject:item];
        }
        self.list = [NSArray arrayWithArray:topList];
    }
}

@end
