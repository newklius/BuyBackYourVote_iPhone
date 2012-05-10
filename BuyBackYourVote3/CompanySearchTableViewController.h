//
//  CompanySearchTableViewController.h
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CompanySearchDataController;

@interface CompanySearchTableViewController : UITableViewController
@property (strong, nonatomic) CompanySearchDataController *searchDataController;
@end
