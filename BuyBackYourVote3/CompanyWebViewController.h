//
//  CompanyWebViewController.h
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyWebViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (copy, nonatomic) NSString *companyURL;
@property (copy, nonatomic) NSString *companyName;

@end
