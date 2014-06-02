//
//  WebViewController.h
//  Nav Ctrl Practice
//
//  Created by shu ghosh on 5/23/14.
//  Copyright (c) 2014 shu ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataAccess.h"
#import "Product.h"
#import "Company.h"


@class ChildViewController; //add Class to avoid circular issue


@interface WebViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIWebView *webView;

@property(retain, nonatomic) NSString *productURL;


@end
