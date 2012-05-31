//
//  Contributions.h
//  BuyBackYourVote3
//
//  Created by Timothy Bauman on 5/29/12.
//  Copyright (c) 2012 Undergraduate Class of 2013. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contributions : NSObject {
    NSArray *names;
    NSArray *years;
    NSArray *seats;
    NSArray *states;
    NSArray *parties;
    NSArray *supports;
    NSArray *amounts;
    NSString *groupingFilter;
    NSString *seatFilter;
    NSString *stateFilter;
}

@property(strong, nonatomic) NSArray *list;

- (void)filterWithGrouping:(NSString *)grouping state:(NSString *)state seat:(NSString *)seat;
-(void)loadFromJSON:(NSData *)jsonData;
-(id)initWithJSON:(NSData *)jsonData;
-(id)init;

@end
