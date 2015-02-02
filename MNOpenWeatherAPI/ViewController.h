//
//  ViewController.h
//  MNOpenWeatherAPI
//
//  Created by Michael Nguyen on 1/29/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MNWeatherAPI.h"

@interface ViewController : UIViewController <UITextFieldDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, weak) IBOutlet UITextField            *cityInputField;
@property (nonatomic, weak) IBOutlet UIButton               *searchBtn;
@property (nonatomic, weak) IBOutlet UIButton               *currentLocationBtn;

@property (nonatomic, weak) IBOutlet UIImageView            *currentWeatherIcon;
@property (nonatomic, weak) IBOutlet UILabel                *locationLabel;
@property (nonatomic, weak) IBOutlet UITextView             *currentWeatherTextBox;
@property (nonatomic, weak) IBOutlet UITableView            *forecastResultsTableView;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *actvityIndicator;

@property (nonatomic, strong)  MNWeatherAPI                 *apiHandler;
@property (nonatomic, strong)  NSArray                      *forecastItems;

// we could extend the app by saving results for offline review, statistics, etc
@property (nonatomic, strong) NSManagedObjectContext *moc;


- (IBAction)getCurrentLocation:(id)sender;
- (IBAction)getCurrentWeatherForCityName:(id)sender;

@end

