//
//  CompanySearchDataController.m
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CompanySearchDataController.h"
#import "CompanySearch.h"

@interface CompanySearchDataController ()
- (void)initializeDefaultDataList;
@end

@implementation CompanySearchDataController

@synthesize companyList = _companyList;

- (void)initializeDefaultDataList {
    NSMutableArray *clarificationList = [[NSMutableArray alloc] init];
    self.companyList = clarificationList;
    //[self addCompanyWithName:@"Google"];
}

- (void)initializeDataListWithName:(NSString *)name {
    NSMutableArray *clarificationList = [[NSMutableArray alloc] init];
    self.companyList = clarificationList;
    // send query to Heroku with name
    
    NSString *query = [NSString stringWithFormat:@"http://buybackyourvote.herokuapp.com/search/results?iphone=true&q=%@", [[name lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    NSURL *url = [NSURL URLWithString:query];

    NSLog(@"url: %@",url);
    
    NSString *results = [NSString stringWithContentsOfURL:url usedEncoding:nil error:nil];

    NSLog(@"results of the query: %@",results);
    
    // now search through the string line-by-line for every occurance of "<td><h3><a href="/company/"
    NSArray *lines = [results componentsSeparatedByString:@"\n"];
    NSLog(@"%@", lines);

    // if line in lines contains "<td><h3><a href="/company/" // watch for escaped "
    for (NSString *line in lines) {
        NSRange textRange;
        textRange = [line rangeOfString:@"<td><h3><a href=\"/company/"];
        if(textRange.location != NSNotFound) {
            
            NSString *result = [line substringFromIndex:34];
            NSLog(@"%@", result);
            NSRange companyURLRange = [result rangeOfString:@"\">"];
            // then find "> and extract until then
            NSString *companyURL = [result substringToIndex:companyURLRange.location];
            //NSLog(@"location: %d length: %d", textRange.location, textRange.length);
            NSLog(@"companyURL: %@", companyURL);
            NSString *result2 = [result substringFromIndex:companyURLRange.location + companyURLRange.length];
            NSRange companyNameRange = [result2 rangeOfString:@"</a>"];
            NSString *companyName = [result2 substringToIndex:companyNameRange.location];
            // it found it, so extract the URL and the title
            NSLog(@"companyName: %@", companyName);
            //NSLog(@"We found a matching line! %@", line);   
            
            [self addCompanyWithName:companyName url:companyURL];

        }
    }

}


- (void)setCompanyList:(NSMutableArray *)newList {
    if (_companyList != newList) {
        _companyList = [newList mutableCopy];
    }
}

- (id)init {
    if (self = [super init]) {
        [self initializeDefaultDataList];
        return self;
    }
    return nil;   
}

- (id)initWithCompanyName:(NSString *)name {
    if (self = [super init]) {
        [self initializeDataListWithName:name];
        return self;
    }
    return nil;
}

- (NSUInteger)countOfCompanyList {
    return [self.companyList count];
}

- (CompanySearch *)objectInCompanyListAtIndex:(NSUInteger)index {
    return [self.companyList objectAtIndex:index];
}

- (void)addCompanyWithName:(NSString *)name url:(NSString *)url {
    CompanySearch *company = [[CompanySearch alloc] initWithName:name url:url];
    [self.companyList addObject:company];
}

@end
