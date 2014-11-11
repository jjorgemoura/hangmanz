//
//  ZDMainController.m
//  hangmanz
//
//  Created by Jorge Moura on 31/10/2014.
//  Copyright (c) 2014 Jorge Moura. All rights reserved.
//

#import "ZDMainController.h"

#import "ZDAlphabetCollectionViewCell.h"
#import "ZDHangmanStatus.h"

@interface ZDMainController ()

@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UILabel *qtErrorsLabel;
@property (nonatomic, weak) IBOutlet UILabel *hangmanWordLabel;
@property (nonatomic, weak) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *theActivityIndicator;
@property (weak, nonatomic) IBOutlet UICollectionView *theCollectionView;

@property (nonatomic, strong) NSArray *alphabetLetters;
@property (nonatomic, strong) NSString *theCategory;
@property (nonatomic) BOOL gameIsUnderway;

@property (nonatomic, strong) ZDHangmanStatus *hangmanStatus;

- (void)processHangmanServiceResponse:(ZDHangmanStatus *)response;

@end




@implementation ZDMainController


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
//MARK: - View Controller Lifecycle
//---------------------------------------------------------------------------------------
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do view setup here.
    
    //Data Source
    _alphabetLetters = [NSArray arrayWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
    
    //Category
    [self setTheCategory:@"Country"];
    //[self setTheCategory:@"Bands"];
    
    
    //Title
    [self setTitle:@"Hangmanz"];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    // Do view setup here.
    
    [[self categoryLabel] setText:[self theCategory]];
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
//MARK: - Main Methods - UI
//---------------------------------------------------------------------------------------
- (void)changeStatusLabel:(NSString *)newStatus {

    if (newStatus) {

        [[self statusLabel] setText:newStatus];
    }
}



//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
//MARK: - Target Action
//---------------------------------------------------------------------------------------
- (IBAction)newGameButtonPressed:(id)sender {
    
    NSLog(@"NEW GAME");
    
    NSString *resultStatus = @"NEW GAME";
    [self setGameIsUnderway:YES];
    
    //Testing.....
    [self performNetworkCallNewGame:[self theCategory]];
    
    //Update UI
    [[self statusLabel] setText:resultStatus];
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
//MARK: - Collection View Data Source
//---------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger rows = 26;
    
    return rows;
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
//MARK: - Collection View Delegate
//---------------------------------------------------------------------------------------
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"MY_MAINCOLLECTION_CELL";

    ZDAlphabetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if ([indexPath section] == 0) {
        
        NSString *theLetter = [[self alphabetLetters] objectAtIndex:indexPath.row];
        
        UIColor *theBlockColor = [UIColor whiteColor];
        UIColor *theBlockBorderColor = [UIColor yellowColor];
        
        [cell mainText:theLetter];
        [cell color:theBlockColor];
        [[cell layer] setBorderColor:[theBlockBorderColor CGColor]];
    }
    
    return cell;
}



- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL result = NO;
    
    if ([self gameIsUnderway]) {
        result = YES;
    }
    return result;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *theCell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if ([theCell isSelected]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [[self theActivityIndicator] startAnimating];
    
    //NSLog(@"DID SELECT ITEM????");
    UIColor *theBlockColor = [UIColor lightGrayColor];
    UIColor *theBlockBorderColor = [UIColor blackColor];
    
    
    //the Cell
    ZDAlphabetCollectionViewCell *theCell = (ZDAlphabetCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [theCell color:theBlockColor];
    [[theCell layer] setBorderColor:[theBlockBorderColor CGColor]];
    
    
    [self performNetworkCallPlay:[[self hangmanStatus] uniqueID] theLetter:[[self alphabetLetters] objectAtIndex:indexPath.row]];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
}



//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
//MARK: - Private Methods
//---------------------------------------------------------------------------------------
- (void)processHangmanServiceResponse:(ZDHangmanStatus *)response {

    if (!response) {
        return;
    }

    
    //
    //[[self hangmanWordLabel] setText:[response theCurrentGuessingWord]];
    
    UIFont *font = [UIFont systemFontOfSize:24.0];
    UIColor *theColor = [UIColor orangeColor];
    NSUInteger leng = [[response theCurrentGuessingWord] length];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[response theCurrentGuessingWord]
                                                                                         attributes:@{NSForegroundColorAttributeName: theColor,
                                                                                                      NSFontAttributeName: font}];
    
    [attributedString addAttribute:NSKernAttributeName
                             value:@(6.4)
                             range:NSMakeRange(0, leng - 1)];
    
    [[self hangmanWordLabel] setAttributedText:attributedString];

    
    
    
    [[self qtErrorsLabel] setText:[[response qtFails] stringValue]];
    
    
    if ([response isFinished]) {
    
        if ([response iWon]) {
            
            [[self statusLabel] setText:@"YOU WIN"];
        }
        else {
        
            [[self statusLabel] setText:@"YOU LOST"];
        }

        //reset ui
        [self setGameIsUnderway:NO];
        //Clean Collection
        for(int i = 0; i < [[self alphabetLetters] count]; i++) {
            
            [[self theCollectionView] deselectItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES];
            
            UIColor *theBlockColor = [UIColor whiteColor];
            UIColor *theBlockBorderColor = [UIColor blackColor];
            
            
            //the Cell
            ZDAlphabetCollectionViewCell *theCell = (ZDAlphabetCollectionViewCell *)[[self theCollectionView] cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [theCell color:theBlockColor];
            [[theCell layer] setBorderColor:[theBlockBorderColor CGColor]];
        }

    }
    else {

        [[self statusLabel] setText:@""];
    }
    
    
    [self setHangmanStatus:response];
    [[self theActivityIndicator] stopAnimating];
}


//---------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------
//MARK: - Network Methods
//---------------------------------------------------------------------------------------
- (void)performNetworkCallCategories {

    //1 -
    
    
    //2 - Decide the URL
    NSString *theURL = @"http://localhost:8080/hangmanz/api/v1/categories";
    
    
    //3 - Define the NSURL
    NSURL *url = [NSURL URLWithString:theURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    //4 - THE URLSESSION
    NSURLSession *session = [NSURLSession sharedSession];
    
    BOOL yyy = [NSThread isMainThread];
    NSLog(@"%@", yyy ? @"THIS IS THE MAIN THREAD" : @"THIS IS NOT THE MAIN THREAD");
    
    
    //5 - The Download Task
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          
                                          
                                          if (error) {
                                              NSLog(@"HANGMANZ SERVICE - CATEGORIES: %@", [error description]);
                                          }
                                          else {
                                              
                                              BOOL yyy = [NSThread isMainThread];
                                              NSLog(@"%@", yyy ? @"THIS IS THE MAIN THREAD" : @"THIS IS NOT THE MAIN THREAD");
                                              NSLog(@"DATA: %@", [data description]);
                                              NSLog(@"RESPONSE: %@", [response description]);
                                              
                                              
                                              
                                              //PROCESS JSON
                                              NSError *errorJSON = nil;
                                              NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&errorJSON];
                                              
                                              if (errorJSON) {
                                                  
                                                  NSLog(@"JSON PARSER ERROR");
                                              }
                                              else {
                                                  
                                                  NSArray *items = [responseDictionary objectForKey:@"categories"];
                                                  
                                                  NSLog(@"COUNT = %lu", (unsigned long)[items count]);
                                                  if([items count] == 0) {
                                                      
                                                      NSLog(@"There are no categories");
                                                  }
                                                  else {
                                                      
                                                      NSDictionary *firstItem = [items objectAtIndex:0];
                                                      NSString *firstItemName = [firstItem objectForKey:@"name"];
                                                      
                                                      
                                                      //CALL THE DOWNLOAD
                                                      dispatch_async(dispatch_get_main_queue(), ^() {
                                                          
                                                          [self changeStatusLabel:firstItemName];
                                                      });
                                                  }
                                              }
                                          }
                                      }];
    
    //6 - Start the Download
    [dataTask resume];
}


- (void)performNetworkCallNewGame:(NSString *)category {

    //NSString *theURL = @"http://localhost:8080/hangmanz/api/v1/games?category=Country";
    
    NSString *theURL = [NSString stringWithFormat:@"http://localhost:8080/hangmanz/api/v1/games?category=%@", category];
    
    [self performNetworkCallNewAndPlay:theURL];
}

- (void)performNetworkCallPlay:(NSString *)gameID theLetter:(NSString *)letter {
    
    NSString *theURL = [NSString stringWithFormat:@"http://localhost:8080/hangmanz/api/v1/games/%@/%@", gameID, letter];
    
    [self performNetworkCallNewAndPlay:theURL];
}


- (void)performNetworkCallNewAndPlay:(NSString *)theURL {
    
    //1 -
    
    
    //2 - Decide the URL
    //NSString *theURL = @"http://localhost:8080/hangmanz/api/v1/games?category=Country";
    
    
    //3 - Define the NSURL
    NSURL *url = [NSURL URLWithString:theURL];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    
    //4 - THE URLSESSION
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    NSURLSessionDataTask *newGameDataTask = [session dataTaskWithRequest:request completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          
                                               
                                                   if (error) {
                                                       NSLog(@"HANGMANZ SERVICE - NEW GAME: %@", [error description]);
                                                   }
                                                   else {
                                                   
                                                   
                                                       //PROCESS JSON
                                                       NSError *errorJSON = nil;
                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&errorJSON];
                                                       
                                                       if (errorJSON) {
                                                           
                                                           NSLog(@"JSON PARSER ERROR");
                                                       }
                                                       else {
                                                       
                                                           NSDictionary *items = [responseDictionary objectForKey:@"hggame"];
                                                           
                                                           
                                                           
                                                           //AUXs BOOLS
                                                           BOOL aux1 = [[[items objectForKey:@"isFinished"] description] isEqualToString:@"1"] ? YES : NO;
                                                           BOOL aux2 = [[[items objectForKey:@"playerWon"] description] isEqualToString:@"1"] ? YES : NO;
                                                           
                                                           //Dic History
                                                           NSDictionary *lettersHistory = [items objectForKey:@"lettersStatus"];

                                                           //Main Object
                                                           ZDHangmanStatus *theHangman = [[ZDHangmanStatus alloc] init];
                                                           [theHangman setUniqueID:[items objectForKey:@"id"]];
                                                           [theHangman setTheCurrentGuessingWord:[items objectForKey:@"currentGuessingWord"]];
                                                           [theHangman setTheStartDate:[items objectForKey:@"startdate"]];
                                                           [theHangman setTheLatestDate:[items objectForKey:@"latestDate"]];
                                                           [theHangman setQtFails:[NSNumber numberWithInteger: [[items objectForKey:@"nrErrors"] integerValue]]];
                                                           [theHangman setIsFinished:aux1];
                                                           [theHangman setIWon:aux2];
                                                           [theHangman setTheLettersHistory:lettersHistory];
                                                           
                                                           //CALL THE DOWNLOAD
                                                           dispatch_async(dispatch_get_main_queue(), ^() {
                                                               
                                                               [self processHangmanServiceResponse:theHangman];
                                                           });
                                                       }
                                                   }
                                               }];
    
    //6 - Start the Download
    [newGameDataTask resume];
}

@end
