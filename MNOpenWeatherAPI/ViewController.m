//
//  ViewController.m
//  MNOpenWeatherAPI
//
//  Created by Michael Nguyen on 1/29/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import "ViewController.h"
#import "TSMessage.h"

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

    [self.actvityIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button Actions

- (IBAction)getCurrentLocation:(id)sender {
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;

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
                NSString *weatherIconUrl = result.currentWeatherIconUrl;

                [self loadImageForURLString:weatherIconUrl forImageView: self.currentWeatherIcon];

            }
            else {
                NSString *msg = [NSString stringWithFormat:@"\"%@\" could not be found.  Please try again.", self.cityInputField.text];
                [TSMessage showNotificationWithTitle:msg type:TSMessageNotificationTypeWarning];
            }
            [self.actvityIndicator stopAnimating];

        };

        [self.apiHandler currentWeatherByCityName:cityName withCallback: handler];

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

    CLLocationCoordinate2D currentCoords = CLLocationCoordinate2DMake(latitude, longitude);

    [self.apiHandler currentWeatherByCoordinate:currentCoords withCallback:handler];

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
    [self getCurrentWeatherForCityName:nil];
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


@end
