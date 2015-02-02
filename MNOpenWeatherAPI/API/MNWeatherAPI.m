//
//  MNWeatherAPI.m
//  MNOpenWeatherAPI
//
//  Created by Michael Nguyen on 1/29/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import "MNWeatherAPI.h"
#import "ForecastInformation.h"
#import "WeatherInformation.h"
#import "NSString+URLEnocder.h"

@interface MNWeatherAPI () {
    NSString *_baseApiUrl;
    NSString *_apiKey;
    NSString *_apiVersion;

    AFHTTPRequestOperationManager *_requestManager;

    MNTemperature _currentTemperatureFormat;
}
@end

@implementation MNWeatherAPI

- (instancetype)initWithAPIKey:(NSString *)apiKey {
    self = [super init];
    if (self != nil) {

        _apiKey = apiKey;
        _apiVersion = @"2.5";
        _baseApiUrl = [NSString stringWithFormat:@"http://api.openweathermap.org/data/%@", _apiVersion];
        _currentTemperatureFormat = kMNTempFahrenheit;

        _requestManager = [AFHTTPRequestOperationManager manager];

    }

    return self;
}

- (NSString *) apiVersion {
    return _apiVersion;
}

- (void) setApiVersion:(NSString *)version {
    _apiVersion = version;
    _baseApiUrl = [NSString stringWithFormat:@"http://api.openweathermap.org/data/%@", _apiVersion];
}

- (void) setTemperatureFormat:(MNTemperature)tempFormat {
    _currentTemperatureFormat = tempFormat;
}

- (MNTemperature)temperatureFormat {
    return _currentTemperatureFormat;
}

#pragma mark - current weather calls

// Make the Api call to get current weather info by city id
// api.openweathermap.org/data/2.5/weather?id=2172797
- (void) currentWeatherByCityId:(NSString *)cityId withCallback:(MNAPICallbackBlock)callback {

    MNHTTPSuccessResultBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (callback) {
            WeatherInformation *weatherInformation = [[WeatherInformation alloc] initWithJsonData: responseObject];
            callback(nil, weatherInformation);
        }
    };

    MNHTTPFailureResultBlock failureBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(error, nil);
    };


    NSString *url = [NSString stringWithFormat:@"%@/weather?id=%@", _baseApiUrl, cityId];

    [_requestManager GET:url parameters:nil success:successBlock failure:failureBlock];

}

// api.openweathermap.org/data/2.5/weather?q=London,uk

- (void) currentWeatherByCityName:(NSString *)name withCallback:(void (^)(NSError *, id))callback {

    MNHTTPSuccessResultBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (callback) {
            NSInteger httpResponseCode = [[operation response] statusCode];
            if ( httpResponseCode != 200 ) {
                // request failed for some reason
                NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:responseObject, @"responseObject", operation.request, @"request", operation.response, @"response", nil];
                NSError *error = [NSError errorWithDomain:@"WEATHER" code:MN_UNKNOWN_ERROR_CODE userInfo:data];
                callback(error, nil);

            }
            else {
                NSInteger statusCode = [[responseObject valueForKey:@"cod"] intValue];

                if (statusCode != 200) {
                    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:responseObject, @"responseObject", operation.request, @"request", operation.response, @"response", nil];
                    NSError *error = [NSError errorWithDomain:@"WEATHER" code:MN_QUERY_FAILED_CODE userInfo:data];
                    callback(error, nil);
                }
                else {
                    WeatherInformation *weatherInformation = [[WeatherInformation alloc] initWithJsonData: responseObject];
                    callback(nil, weatherInformation);
                }
            }
        }
    };

    MNHTTPFailureResultBlock failureBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(error, nil);
    };

    NSString *urlEscapedCityName = [name urlEncode];
    NSString *url = [NSString stringWithFormat:@"%@/weather?q=%@", _baseApiUrl, urlEscapedCityName];

    [_requestManager GET:url parameters:nil success:successBlock failure:failureBlock];

}


// api.openweathermap.org/data/2.5/weather?lat=35&lon=139
- (void)currentWeatherByCoordinate:(CLLocationCoordinate2D)coordinate withCallback:(MNAPICallbackBlock)callback {

    MNHTTPSuccessResultBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (callback) {
            WeatherInformation *weatherInformation = [[WeatherInformation alloc] initWithJsonData: responseObject];
            callback(nil, weatherInformation);
        }
    };

    MNHTTPFailureResultBlock failureBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(error, nil);
    };

    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];

    NSString *url = [NSString stringWithFormat:@"%@/weather?lat=%@&lon=%@", _baseApiUrl, latitude, longitude];

    [_requestManager GET:url parameters:nil success:successBlock failure:failureBlock];

}

#pragma mark - forecast calls

// http://api.openweathermap.org/data/2.5/forecast?id=2172797
- (void)forecastWeatherByCityId:(NSString *)cityId numDaysForecast:(int)daysForecast withCallback:(MNAPICallbackBlock)callback {
    MNHTTPSuccessResultBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (callback) {
            NSInteger httpResponseCode = [[operation response] statusCode];
            if ( httpResponseCode != 200 ) {
                // request failed for some reason
                NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:responseObject, @"responseObject", operation.request, @"request", operation.response, @"response", nil];
                NSError *error = [NSError errorWithDomain:@"WEATHER" code:MN_UNKNOWN_ERROR_CODE userInfo:data];
                callback(error, nil);

            }
            else {
                NSInteger statusCode = [[responseObject valueForKey:@"cod"] intValue];

                if (statusCode != 200) {
                    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:responseObject, @"responseObject", operation.request, @"request", operation.response, @"response", nil];
                    NSError *error = [NSError errorWithDomain:@"WEATHER" code:MN_QUERY_FAILED_CODE userInfo:data];
                    callback(error, nil);
                }
                else {
                    ForecastInformation *forecastInformation = [[ForecastInformation alloc] initWithJsonData: responseObject];
                    callback(nil, forecastInformation);
                }
            }
        }
    };

    MNHTTPFailureResultBlock failureBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(error, nil);
    };

    NSString *url = [NSString stringWithFormat:@"%@/forecast?id=%@&cnt=%d", _baseApiUrl, cityId, daysForecast];

    [_requestManager GET:url parameters:nil success:successBlock failure:failureBlock];

}

// http://api.openweathermap.org/data/2.5/forecast?q=London,uk
- (void)forecastWeatherByCityName:(NSString *)name numDaysForecast:(int)daysForecast withCallback:(MNAPICallbackBlock)callback {

    MNHTTPSuccessResultBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (callback) {
            NSInteger httpResponseCode = [[operation response] statusCode];
            if ( httpResponseCode != 200 ) {
                // request failed for some reason
                NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:responseObject, @"responseObject", operation.request, @"request", operation.response, @"response", nil];
                NSError *error = [NSError errorWithDomain:@"WEATHER" code:MN_UNKNOWN_ERROR_CODE userInfo:data];
                callback(error, nil);

            }
            else {
                NSInteger statusCode = [[responseObject valueForKey:@"cod"] intValue];

                if (statusCode != 200) {
                    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:responseObject, @"responseObject", operation.request, @"request", operation.response, @"response", nil];
                    NSError *error = [NSError errorWithDomain:@"WEATHER" code:MN_QUERY_FAILED_CODE userInfo:data];
                    callback(error, nil);
                }
                else {
                    ForecastInformation *forecastInformation = [[ForecastInformation alloc] initWithJsonData: responseObject];
                    callback(nil, forecastInformation);
                }
            }
        }
    };

    MNHTTPFailureResultBlock failureBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(error, nil);
    };

    NSString *urlEscapedCityName = [name urlEncode];
    NSString *url = [NSString stringWithFormat:@"%@/forecast?q=%@&cnt=%d", _baseApiUrl, urlEscapedCityName, daysForecast];

    [_requestManager GET:url parameters:nil success:successBlock failure:failureBlock];

}

// http://api.openweathermap.org/data/2.5/forecast?lat=35&lon=139
- (void)forecastWeatherByCoordinate:(CLLocationCoordinate2D)coordinate numDaysForecast:(int)daysForecast withCallback:(MNAPICallbackBlock)callback {

    MNHTTPSuccessResultBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (callback) {
            ForecastInformation *forecastInfo = [[ForecastInformation alloc] initWithJsonData: responseObject];
            callback(nil, forecastInfo);
        }
    };

    MNHTTPFailureResultBlock failureBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(error, nil);
    };

    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];

    NSString *url = [NSString stringWithFormat:@"%@/forecast?lat=%@&lon=%@", _baseApiUrl, latitude, longitude];

    [_requestManager GET:url parameters:nil success:successBlock failure:failureBlock];
}


- (void)dailyForecastWeatherByCityId:(NSString *)cityId withCount:(int)count andCallback:(MNAPICallbackBlock)callback {

}

- (void)dailyForecastWeatherByCityName:(NSString *)name withCount:(int)count andCallback:(MNAPICallbackBlock)callback {

}

- (void)dailyForecastWeatherByCoordinate:(CLLocationCoordinate2D)coordinate withCount:(int)count andCallback:(MNAPICallbackBlock)callback {

}


@end
