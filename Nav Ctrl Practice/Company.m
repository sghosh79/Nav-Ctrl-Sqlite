//
//  Company.m
//  Nav Ctrl Practice
//
//  Created by shu ghosh on 5/18/14.
//  Copyright (c) 2014 shu ghosh. All rights reserved.
//

#import "Company.h"

@implementation Company

+(id)initWithName:(NSString *)name logo:(NSString *)logo symbol:(NSString *) symbol price:(NSString*)price companyID:(NSString*)companyID {
    
    Company *company = [[Company alloc] init];
    
    if(company) {
        
        company.name = name;
        company.logo = logo;
        company.stockSymbol = symbol;
        company.stockPrice = price;
        company.companyID = companyID;
        
    }
    return company;
}


-(void)print{
    
    //break up the string with %@ and comma where you want the variables to show up
    
    NSLog(@"CompanyID:%@, Company Name:%@, Company Stock Symbol:%@, Company Logo:%@, Company Stock Price:%@", self.companyID, self.name, self.stockSymbol, self.logo, self.stockPrice);



}



@end
