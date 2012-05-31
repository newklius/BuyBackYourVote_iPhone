//
//  Company.m
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Company.h"

#import "Candidate.h"
#import "Pacs.h"
#import "BillsDataController.h"

@implementation Company

@synthesize companyName = _companyName, companyURL = _companyURL, candidates = _candidates, pacs = _pacs, supportedBills = _supportedBills, structure = _structure;

-(id)initWithName:(NSString *)name URL:(NSString *)URL {
    self = [super init];
    if (self) {
        _companyName = name;
        _companyURL = URL;
        NSLog(@"initing company");
        return self;
    }
    return nil;
}

-(id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {    
        NSLog(@"initing company");
        _companyName = name;
        _candidates = [self candidatesArray];
        _pacs = [self pacsArray];
        
        NSLog(@"done initing company with name: %@", [self companyName]);
        NSLog(@"pacs array: %@", [self pacs]);
        return self;
    }
    return nil;
}

-(void)loadDataFromAction:(NSString *)action extra:(NSString *)extra delegate:(id)delegate {
    NSString *query = [NSString stringWithFormat:@"http://www.buybackyourvote.com/company/%@/%@/%@", action, self.companyURL, extra];
    NSURL *url = [NSURL URLWithString:query];
    NSURLRequest *request=[NSURLRequest requestWithURL: url
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
    NSLog(query);
}

-(void)loadDataFromAction:(NSString *)action delegate:(id)delegate {
    NSString *query = [NSString stringWithFormat:@"http://www.buybackyourvote.com/company/%@/%@", action, self.companyURL];
    NSURL *url = [NSURL URLWithString:query];
    NSURLRequest *request=[NSURLRequest requestWithURL: url
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
    NSLog(query);
}

-(NSArray *)candidatesArray {
    NSMutableArray *candidates = [[NSMutableArray alloc] init];
    
    NSString *query = [NSString stringWithFormat:@"http://www.buybackyourvote.com/company/candidates/%@", [[self.companyName stringByReplacingOccurrencesOfString:@" " withString:@"-"] lowercaseString]];
    
    NSURL *url = [NSURL URLWithString:query];
    
    NSLog(@"got this far: %@", url);
    
    NSData *jsonData = [NSData dataWithContentsOfURL:url];    
    NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSArray *jsonRows = [jsonResults objectForKey:@"rows"];
    
    for (NSDictionary *row in jsonRows) {
        NSString *candidateName = [[[row objectForKey:@"c"] objectAtIndex:0] objectForKey:@"v"];
        NSString *cycle = [[[row objectForKey:@"c"] objectAtIndex:1] objectForKey:@"v"];
        NSString *seat = [[[row objectForKey:@"c"] objectAtIndex:2] objectForKey:@"v"];
        NSString *state = [[[row objectForKey:@"c"] objectAtIndex:3] objectForKey:@"v"];
        NSString *party = [[[row objectForKey:@"c"] objectAtIndex:4] objectForKey:@"v"];
        NSNumber *amount = [NSNumber numberWithInteger:[[[[row objectForKey:@"c"] objectAtIndex:5] objectForKey:@"v"] integerValue]]; // will this cast really work?
        BOOL support = NO;
        if ([[[row objectForKey:@"c"] objectAtIndex:4] objectForKey:@"v"] == @"1") {
            support = YES;
        } 
        
        [candidates addObject:[[Candidate alloc] initWithName:candidateName cycle:cycle seat:seat state:state party:party amount:amount support:support]];
        
        /*
        NSLog(@"%@",row);
        NSLog(@"---");
        NSLog(@"%@",[[row objectForKey:@"c"] objectAtIndex:0]);
        NSLog(@"%@",candidateName);
        NSLog(@"---------------------");
         */
    }
    
    return [NSArray arrayWithArray:candidates];
}

-(NSArray *)pacsArray {
    NSMutableArray *pacs = [[NSMutableArray alloc] init];
    
    NSString *query = [NSString stringWithFormat:@"http://buybackyourvote.herokuapp.com/company/pacs/%@", [[self.companyName stringByReplacingOccurrencesOfString:@" " withString:@"-"] lowercaseString]];
    
    NSURL *url = [NSURL URLWithString:query];
    
    NSLog(@"got this far: %@", url);
    
    NSData *jsonData = [NSData dataWithContentsOfURL:url];    
    NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSArray *jsonRows = [jsonResults objectForKey:@"rows"];

    for (NSDictionary *row in jsonRows) {
        
        NSString *pacName = [[[row objectForKey:@"c"] objectAtIndex:0] objectForKey:@"v"];
        NSString *cycle = [[[row objectForKey:@"c"] objectAtIndex:1] objectForKey:@"v"];
        NSString *seat = [[[row objectForKey:@"c"] objectAtIndex:2] objectForKey:@"v"];
        NSString *state = [[[row objectForKey:@"c"] objectAtIndex:3] objectForKey:@"v"];
        NSString *party = [[[row objectForKey:@"c"] objectAtIndex:4] objectForKey:@"v"];
        NSNumber *amount = [NSNumber numberWithInteger:[[[[row objectForKey:@"c"] objectAtIndex:5] objectForKey:@"v"] integerValue]]; // will this cast really work?
        
        [pacs addObject:[[Pacs alloc] initWithName:pacName cycle:cycle seat:seat state:state party:party amount:amount]];
        
        /*
         NSLog(@"%@",row);
         NSLog(@"---");
         NSLog(@"%@",[[row objectForKey:@"c"] objectAtIndex:0]);
         NSLog(@"%@",candidateName);
         NSLog(@"---------------------");
         */
    }
    
    return [NSArray arrayWithArray:pacs];
}



-(NSNumber *)democrats {
    // loop through candidates and pacs looking for party affiliations
    NSNumber *sum = 0;
    for (Candidate *c in self.candidates) {
        if (c.party == @"Democrat") {
            sum = [NSNumber numberWithInteger:[sum integerValue] + [c.amount integerValue]];
        }
    }
    for (Pacs *p in self.pacs) {
        if (p.party == @"Democrat") {
            sum = [NSNumber numberWithInteger:[sum integerValue] + [p.amount integerValue]];
        }
    }    
    return sum;
}

-(NSNumber *)republicans {
    // loop through candidates and pacs looking for party affiliations
    NSNumber *sum = 0;
    for (Candidate *c in self.candidates) {
        if (c.party == @"Republican") {
            sum = [NSNumber numberWithInteger:[sum integerValue] + [c.amount integerValue]];
        }
    }
    for (Pacs *p in self.pacs) {
        if (p.party == @"Republican") {
            sum = [NSNumber numberWithInteger:[sum integerValue] + [p.amount integerValue]];
        }
    }    
    return sum;
}


@end
