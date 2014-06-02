//
//  ChildViewController.h
//  Nav Ctrl Practice
//
//  Created by shu ghosh on 5/23/14.
//  Copyright (c) 2014 shu ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
#import "ParentViewController.h"
#import "DataAccess.h"
#import "Company.h"
#import "Product.h"

@class ParentViewController; //add Class to avoid circular issue

@interface ChildViewController : UITableViewController

@property(nonatomic, retain) WebViewController *wbc;

@property (nonatomic, retain) DataAccess *dataAccess2;

@property (nonatomic, retain) ParentViewController *parentVC;

@property (nonatomic, retain) Company *company;

@property (nonatomic, retain) Product *selectedProduct;


@end
