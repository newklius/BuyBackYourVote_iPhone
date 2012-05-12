//
//  SecondViewController.h
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CompanySearchDataController;
@class CompanyClarificationDataController;
@class CompanySearchDataController;

@interface SearchViewController : UIViewController <ZBarReaderDelegate>

@property (weak, nonatomic) IBOutlet UITextField *companySearchQuery;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actvityIndicator;
@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;

@property (nonatomic, copy) NSString *oneSlug;
@property (nonatomic, copy) NSString *oneName;
@property (nonatomic, strong) CompanySearchDataController *searchDataController;
@property (nonatomic, strong) CompanyClarificationDataController *clarificationDataController;

- (IBAction)scanButtonPressed:(id)sender;
- (IBAction)searchButtonTapped:(id)sender;
- (IBAction)infoButtonPressed:(id)sender;

@end
