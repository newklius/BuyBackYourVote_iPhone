//
//  SecondViewController.h
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CompanySearchDataController;

@interface SearchViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *companySearchQuery;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actvityIndicator;

@property (nonatomic, copy) NSString *oneSlug;
@property (nonatomic, copy) NSString *oneName;
@property (nonatomic, strong) CompanySearchDataController *searchDataController;

- (IBAction)searchButtonTapped:(id)sender;

@end
