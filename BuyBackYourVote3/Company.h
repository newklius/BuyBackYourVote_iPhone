//
//  Company.h
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Candidate;
@class Bill;
@class CorporateStructure;

@interface Company : NSObject

@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyURL;
@property (nonatomic, copy) NSArray *candidates; // again this should be an array of Candidate objects  // actually it should be a CandidateDataController
@property (nonatomic, copy) NSArray *pacs;
@property (nonatomic, copy) NSArray *supportedBills;  // this should be more like a table/csv type thingy.  An array of Bills objects
@property (nonatomic, copy) CorporateStructure *structure;

-(id)initWithName:(NSString *)name URL:(NSString *)URL;
-(id)initWithName:(NSString *)name;
-(void)loadDataFromAction:(NSString *)action delegate:(id)delegate;
-(void)loadDataFromAction:(NSString *)action extra:(NSString *)extra delegate:(id)delegate;

// return various stats:
-(NSNumber *)democrats;
-(NSNumber *)republicans;

@end
