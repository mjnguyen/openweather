//
//  MNWeatherAPI.h
//  MNOpenWeatherAPI
//
//  Created by Michael Nguyen on 1/29/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"
#import "WeatherInformation.h"

@interface MNWeatherAPI : NSObject

typedef void (^MNHTTPSuccessResultBlock)(AFHTTPRequestOperation* operation, id responseObject);
typedef void (^MNHTTPFailureResultBlock)(AFHTTPRequestOperation  *operation, NSError *error);
typedef void (^MNAPICallbackBlock)(NSError* error, WeatherInformation *result);

#define MN_UNKNOWN_ERROR_CODE 800
#define MN_QUERY_FAILED_CODE 700

typedef enum {
    kMNTempKelvin,
    kMNTempCelcius,
    kMNTempFahrenheit
} MNTemperature;


- (instancetype) initWithAPIKey:(NSString *) apiKey;

- (void) setApiVersion:(NSString *) version;
- (NSString *) apiVersion;

- (void) setTemperatureFormat:(MNTemperature) tempFormat;
- (MNTemperature) temperatureFormat;

#pragma mark - current weather

-(void) currentWeatherByCityName:(NSString *) name
                    withCallback:( void (^)( NSError* error, WeatherInformation *result ) )callback;


-(void) currentWeatherByCoordinate:(CLLocationCoordinate2D) coordinate
                      withCallback:( void (^)( NSError* error, WeatherInformation *result ) )callback;

-(void) currentWeatherByCityId:(NSString *) cityId
                  withCallback:( void (^)( NSError* error, WeatherInformation *result ) )callback;

#pragma mark - forecast

-(void) forecastWeatherByCityName:(NSString *) name
                     withCallback:( void (^)( NSError* error, WeatherInformation *result ) )callback;

-(void) forecastWeatherByCoordinate:(CLLocationCoordinate2D) coordinate
                       withCallback:( void (^)( NSError* error, WeatherInformation *result ) )callback;

-(void) forecastWeatherByCityId:(NSString *) cityId
                   withCallback:( void (^)( NSError* error, WeatherInformation *result ) )callback;

#pragma mark forcast - n days

-(void) dailyForecastWeatherByCityName:(NSString *) name
                             withCount:(int) count
                           andCallback:( void (^)( NSError* error, WeatherInformation *result ) )callback;

-(void) dailyForecastWeatherByCoordinate:(CLLocationCoordinate2D) coordinate
                               withCount:(int) count
                             andCallback:( void (^)( NSError* error, WeatherInformation *result ) )callback;

-(void) dailyForecastWeatherByCityId:(NSString *) cityId
                           withCount:(int) count
                         andCallback:( void (^)( NSError* error, WeatherInformation *result ) )callback;

@end