//
//  ParentViewController.h
//  Nav Ctrl Practice
//
//  Created by shu ghosh on 5/23/14.
//  Copyright (c) 2014 shu ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildViewController.h"
#import "DataAccess.h"
#import "Company.h"


@class ChildViewController; //add Class to avoid circular issue
@class DataAccess; //add Class to avoid circular issue

@interface ParentViewController : UITableViewController <NSURLConnectionDataDelegate>
{ //The NSURLConnectionDataDelegate protocol describes methods that should be implemented by the delegate for an instance of NSURLConnection. Many methods in this protocol existed as part of an informal protocol in previous versions of OS X and iOS.
    
    NSMutableData *_responseData;
    
}


@property (nonatomic, retain) DataAccess *dataAccess;

@property (nonatomic, retain) IBOutlet  ChildViewController * childVC; //gave parent a child property; initially forgot to make this an outlet

@property (nonatomic, retain) IBOutlet UITableView *myTableView;



@end
