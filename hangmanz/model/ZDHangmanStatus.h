//
//  ZDHangmanStatus.h
//  hangmanz
//
//  Created by Jorge Moura on 02/11/2014.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDHangmanStatus : NSObject

@property (nonatomic, strong) NSString *uniqueID;
@property (nonatomic, strong) NSString *theCurrentGuessingWord;
@property (nonatomic, strong) NSString *theStartDate;
@property (nonatomic, strong) NSString *theLatestDate;
@property (nonatomic, strong) NSNumber *qtFails;
@property (nonatomic) BOOL isFinished;
@property (nonatomic) BOOL iWon;
@property (nonatomic, strong) NSDictionary *theLettersHistory;


- (void)processJson:(NSString *)theJsonResponse;

@end
