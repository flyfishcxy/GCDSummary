//
//  Person.m
//  GCDSummary
//
//  Created by chen on 2017/5/7.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "Person.h"

@implementation Person

-(NSArray *)arrayPerson
{
    if (_arrayPerson==nil) {
        //_arrayPerson = @[@"1234",@"56789"];
        
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _arrayPerson = @[@"1234",@"56789"];
        });
    }
    return _arrayPerson;
}

@end
