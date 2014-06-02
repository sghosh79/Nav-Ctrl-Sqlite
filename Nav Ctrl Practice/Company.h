//
//  Company.h
//  Nav Ctrl Practice
//
//  Created by shu ghosh on 5/18/14.
//  Copyright (c) 2014 shu ghosh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Company : NSObject

@property (nonatomic, retain) NSString *name;

@property (nonatomic, retain) NSString *logo;

@property (nonatomic, retain) NSString *stockPrice;

@property (nonatomic, retain) NSString *stockSymbol;

@property (nonatomic, retain) NSString *companyID;

@property (nonatomic, retain) NSMutableArray *products;



+(id)initWithName:(NSString *)name logo:(NSString *)logo symbol: (NSString *) symbol price: (NSString*)price companyID:(NSString*)companyID; //name of this method is really initWithName:logo:symbol:price:companyID

-(void)print;


@end
