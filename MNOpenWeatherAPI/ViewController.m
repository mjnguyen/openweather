//
//  ViewController.m
//  MNOpenWeatherAPI
//
//  Created by Michael Nguyen on 1/29/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import "ViewController.h"
#import "TSMessage.h"
#import "ForecastInformation.h"

@interface ViewController () {
    NSArray *weatherResults;
    CLLocationManager *locationManager;
    CGFloat longitude, latitude;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // Should load the apiKey from a pList in a production app
    self.apiHandler = [[MNWeatherAPI alloc] initWithAPIKey:@"87ffe556600211fb77dcca20e79bd90a"];

    locationManager = [[CLLocationManager alloc] init]; // startup location services
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;

    _forecastItems = [[NSArray alloc] init];
    [self.actvityIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button Actions

- (IBAction)getCurrentLocation:(id)sender {
    // if location services are restricted do nothing
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted )
    {
        [TSMessage showNotificationWithTitle:@"Location Services for this application have been turned off.  Please go to the Settings App and turn it on." type:TSMessageNotificationTypeWarning];
        return;
    }

    // for iOS 8, specific user level permission is required,
    // "when-in-use" authorization grants access to the user's location
    //
    // important: be sure to include NSLocationWhenInUseUsageDescription along with its
    // explanation string in your Info.plist or startUpdatingLocation will not work.
    //
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManager requestWhenInUseAuthorization];
    }

    [locationManager startUpdatingLocation];
}

- (IBAction)getCurrentWeatherForCityName:(id)sender {

    // make call to weather api to get the current weather information
    NSString *cityName = self.cityInputField.text;
    if ( [cityName length] > 0 ) {
        // start the activity indicator
        [self.actvityIndicator startAnimating];

        MNAPICallbackBlock handler = ^(NSError *error, WeatherInformation *result) {
            if ((error == nil) && [result.cityName length] > 0) {
                // update UI with current weather conditions
                self.locationLabel.text = [NSString stringWithFormat:@"%@, %@", result.cityName, [result.geoCodeSystem objectForKey:@"country"]];

                self.currentWeatherTextBox.text = [result description];
                [self.currentWeatherTextBox setFont:[UIFont fontWithName:@"Helvetica Neue" size:13.f]];
                NSString *weatherIconUrl = result.currentWeatherIconUrl;

                [self loadImageForURLString:weatherIconUrl forImageView: self.currentWeatherIcon];

            }
            else {
                NSString *msg = [NSString stringWithFormat:@"\"%@\" could not be found.  Please try again.", self.cityInputField.text];
                [TSMessage showNotificationWithTitle:msg type:TSMessageNotificationTypeWarning];
            }
            [self.actvityIndicator stopAnimating];

        };

        MNAPICallbackBlock forecastHandler = ^(NSError *error, ForecastInformation *results) {
            // populate forecast array with results
            self.forecastItems = [results forecasts];
            [self.forecastResultsTableView reloadData];

        };


        [self.apiHandler currentWeatherByCityName:cityName withCallback: handler];
        [self.apiHandler forecastWeatherByCityName:cityName numDaysForecast:5 withCallback: forecastHandler];

    }
    else {
        [TSMessage showNotificationWithTitle:@"Please enter a city name" type:TSMessageNotificationTypeError];
    }
}


- (void)getCurrentWeatherByLocation:(id)sender {
    // start the activity indicator
    [self.actvityIndicator startAnimating];

    // make call to weather api to get the current weather information
    MNAPICallbackBlock handler = ^(NSError *error, WeatherInformation *result) {
        if (error == nil) {
            // update UI with current weather conditions
            self.locationLabel.text = [NSString stringWithFormat:@"%@, %@", result.cityName, [result.geoCodeSystem objectForKey:@"country"]];
            self.currentWeatherTextBox.text = [result description];

            NSString *weatherIconUrl = result.currentWeatherIconUrl;

            [self loadImageForURLString:weatherIconUrl forImageView: self.currentWeatherIcon];

        } else {
            [TSMessage showNotificationWithTitle:@"Failed to get location information. Perhaps you need to enable Location Services in Settings?" type:TSMessageNotificationTypeWarning];
        }

        // start the activity indicator
        [self.actvityIndicator stopAnimating];
    };
    MNAPICallbackBlock forecastHandler = ^(NSError *error, ForecastInformation *results) {
        // populate forecast array with results
        self.forecastItems = [results forecasts];
        [self.forecastResultsTableView reloadData];

    };


    CLLocationCoordinate2D currentCoords = CLLocationCoordinate2DMake(latitude, longitude);

    [self.apiHandler currentWeatherByCoordinate:currentCoords withCallback:handler];
    [self.apiHandler forecastWeatherByCoordinate:currentCoords numDaysForecast:5 withCallback:forecastHandler];

}


- (void)loadImageForURLString:(NSString *)imageUrl forImageView: (UIImageView *)imageView {

    imageView.image = nil;

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * response, NSData * data, NSError * connectionError)
     {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         if (data) {
             imageView.image = [UIImage imageWithData:data];
         }
     }];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
//    [self getCurrentWeatherForCityName:nil];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [TSMessage showNotificationWithTitle:@"Failed to get location information. Perhaps you need to enable Location Services in Settings?" type:TSMessageNotificationTypeWarning];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;

    if (currentLocation != nil) {
        longitude = currentLocation.coordinate.longitude;
        latitude = currentLocation.coordinate.latitude;
        [locationManager stopUpdatingLocation];

        [self getCurrentWeatherByLocation:nil];
    }
}


#pragma mark - tableview delegates

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    WeatherInformation *forecast = [self.forecastItems objectAtIndex: indexPath.row];
    float maxTemp = [forecast maxTemp];
    float minTemp =[forecast minTemp];
    NSDateFormatter* day = [[NSDateFormatter alloc] init];
    [day setDateFormat: @"EEEE @ hh a"];
    NSString *dayOfWeek = [day stringFromDate: forecast.timestamp];

    NSString *forecastSummary = [NSString stringWithFormat:@"%@ - High: %2.0fF Low: %2.0fF", dayOfWeek, maxTemp, minTemp];
    cell.textLabel.text = forecastSummary;
    cell.detailTextLabel.text = [forecast.weatherDetails.firstObject objectForKey:@"description"];

    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ((self.forecastItems == nil) || ([self.forecastItems count] == 0))
        return 0;

    return [self.forecastItems count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ForecastCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}


@end
