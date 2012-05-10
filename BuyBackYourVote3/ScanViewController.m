//
//  FirstViewController.m
//  BuyBackYourVote3
//
//  Created by Nathan Keyes on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScanViewController.h"

#import "CompanySearchTableViewController.h"
#import "CompanySearchDataController.h"
#import "CompanyClarificationTableViewController.h"
#import "CompanyClarificationDataController.h"
#import "CompanyWebViewController.h"

@interface ScanViewController ()

@end

@implementation ScanViewController

@synthesize clarificationDataController, searchDataController, oneSlug, oneName;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.navigationBar.tintColor = [[UIColor alloc] initWithRed:0.21 green:0.49 blue:0.21 alpha:1.0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CompanyResultsSegue"]) {
        CompanyWebViewController *webViewController = [segue destinationViewController];
        webViewController.companyURL = self.oneSlug;
        webViewController.companyName = self.oneName;
    }
    else if ([[segue identifier] isEqualToString:@"CompanySearchSegue"]) {
        CompanySearchTableViewController *searchViewController = [segue destinationViewController];
        searchViewController.searchDataController = self.searchDataController;
    }
    else if ([[segue identifier] isEqualToString:@"CompanyClarificationSegue"]) {
        CompanyClarificationTableViewController *clarificationViewController = [segue destinationViewController];
        clarificationViewController.clarificationDataController = self.clarificationDataController;
    }
}

- (IBAction)scanButtonPressed:(id)sender {
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    [self presentModalViewController:reader animated:YES];    
    
}

- (IBAction)simulateButtonPressed:(id)sender {
    //NSString *polandSprings = @"075720481279";
    //NSString *honeyBunches = @"884912002181";
    //NSString *wheaties = @"016000275652";
    [self processUPC:@"016000275652"];
}

- (void) processUPC:(NSString *)UPC {
    
    NSLog(@"starting to processUPC");
    
    // create Google URL query given barcode data
    NSString *query = [NSString stringWithFormat:@"https://www.googleapis.com/shopping/search/v1/public/products?key=AIzaSyBOyGiUhBNy4v0zFaHvvbxsB-8It3Zl3p8&country=US&q=%@&alt=json", UPC];
    NSURL *url = [NSURL URLWithString:query];
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSArray *items = [jsonResults objectForKey:@"items"];
    NSString *thisBrand = @"";
    NSMutableDictionary *tally = [[NSMutableDictionary alloc] init];
    for (NSDictionary *item in items) {
        //NSLog(@"looping through items array: %d", i);
        thisBrand = [[item objectForKey:@"product"] objectForKey:@"brand"];
        // add thisbrand to tally
        if (thisBrand != NULL) {
            if ([tally valueForKey:thisBrand] == NULL)
                [tally setValue:[NSNumber numberWithInt:1] forKey:thisBrand];
            else {
                NSNumber *currentValue = [tally valueForKey:thisBrand];
                [tally setValue:[NSNumber numberWithInt:[currentValue intValue]+1] forKey:thisBrand];
            }
        }
    }
    
    // sort tally by Value
    //NSArray *sortedKeys = [tally keysSortedByValueUsingSelector:@selector(comparator)];

    NSArray *keys = [tally allKeys];
    NSString *key = @"";
    
    self.clarificationDataController = [[CompanyClarificationDataController alloc] init];

    NSString *slugString = @"http://buybackyourvote.herokuapp.com/search/exists?";
    NSString *slugURLConstruct = @"";
    for (key in keys) {
        // add each key to a URL thingy
        slugURLConstruct = [slugURLConstruct stringByAppendingString:[[[NSString stringWithFormat:@"company=%@&", [key stringByReplacingOccurrencesOfString:@" " withString:@"%20"]] stringByReplacingOccurrencesOfString:@"\"" withString:@""] lowercaseString]];
        [self.clarificationDataController addCompanyWithName:key];
    }
    
    slugString = [slugString stringByAppendingString:slugURLConstruct];
    NSLog(@"%@",slugString);

    NSURL *slugURL = [NSURL URLWithString:slugString];
    NSData *slugJsonData = [NSData dataWithContentsOfURL:slugURL];
    NSArray *slugJsonArray = [NSJSONSerialization JSONObjectWithData:slugJsonData options:0 error:nil];

    self.searchDataController = [[CompanySearchDataController alloc] init];
    if ([slugJsonArray count] > 0) {
        if ([slugJsonArray count] == 1) {
            self.oneSlug = [[slugJsonArray objectAtIndex:0] objectForKey:@"slug"];
            self.oneName = [[slugJsonArray objectAtIndex:0] objectForKey:@"name"];
            NSLog(@"the slug = %@", self.oneSlug);
            [self performSegueWithIdentifier:@"CompanyResultsSegue" sender:self];
        }
        else {
            // get slugKeys from slugJsonResults
            for (NSDictionary *slug in slugJsonArray) {         
                [self.searchDataController addCompanyWithName:[slug objectForKey:@"name"] url:[slug objectForKey:@"slug"]];
            }
            [self performSegueWithIdentifier:@"CompanySearchSegue" sender:self];
        }
    }
    else {
        [self performSegueWithIdentifier:@"CompanyClarificationSegue" sender:self];
    }
}

- (void) imagePickerController:(UIImagePickerController *)reader didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    [reader dismissModalViewControllerAnimated: YES];

    [self processUPC:symbol.data];
}



@end
