//
//  ForecastInformation.m
//  MNOpenWeatherAPI
//
//  Created by Michael Nguyen on 2/2/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import "ForecastInformation.h"
#import "WeatherInformation.h"

@implementation ForecastInformation

- (instancetype)initWithJsonData: (id)jsonData {
    self = [super init];
    if (self) {
        self.cityName = jsonData[@"city"][@"name"];
        self.cityId = jsonData[@"city"][@"id"];
        self.coordinates = jsonData[@"city"][@"coord"];
        self.daysForecast = [jsonData[@"cnt"] intValue];

        NSMutableArray *forecastArray = [[NSMutableArray alloc] init];
        for (NSDictionary *forecastData in jsonData[@"list"]) {
            WeatherInformation *w = [[WeatherInformation alloc] initWithJsonData: forecastData];
            [forecastArray addObject: w];
        }
        self.forecasts = [forecastArray copy];

    }

    return self;
}


-(NSString *)description {
    NSMutableString *retVal = [NSMutableString stringWithFormat:@"%@\n"
            " %ld day forecast", self.cityName, (long)self.daysForecast];

    for (WeatherInformation *weatherInfo in self.forecasts) {
        NSLog(@"%@", weatherInfo);
    }

    return [retVal stringByAppendingString:@""];
}
@end
