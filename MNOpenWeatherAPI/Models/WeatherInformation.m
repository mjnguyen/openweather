//
//  WeatherInformation.m
//  MNOpenWeatherAPI
//
//  Created by Michael Nguyen on 1/29/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import "WeatherInformation.h"


@implementation WeatherInformation

-(instancetype)initWithJsonData:(id)jsonData {
    self = [super init];

    if ( self != nil ) {
        // parse the json data and populate as necessary
        long long timestampMillis = [[jsonData objectForKey:@"dt"] longLongValue];

        self.timestamp = [NSDate dateWithTimeIntervalSince1970: timestampMillis];
        self.baseInformation = [jsonData objectForKey:@"base"];
        self.cloudDetails = [jsonData objectForKey:@"clouds"];
        self.coordinates = [jsonData objectForKey:@"coord"];
        self.cityId = [jsonData objectForKey:@"id"];
        self.mainDetails = [jsonData objectForKey:@"main"];
        self.weatherDetails = [jsonData objectForKey:@"weather"];
        self.geoCodeSystem = [jsonData objectForKey:@"sys"];
        self.windDetails = [jsonData objectForKey:@"wind"];
        self.citytName = [jsonData objectForKey:@"name"];
    }

    return self;

}

#pragma mark - helper methods
- (NSString *)windDirection {
    float degreeDirection = [[self.windDetails objectForKey:@"deg"] floatValue];

    NSString *cardinalDirection = @"N";
    if ((degreeDirection > 11.25) && (degreeDirection <= 33.75)) {
        cardinalDirection = @"NNE";
    }
    else if ((degreeDirection> 33.75) && (degreeDirection <= 56.25)) {
        cardinalDirection = @"NE";
    }
    else if ((degreeDirection> 56.25) && (degreeDirection <= 78.75)) {
        cardinalDirection = @"ENE";
    }
    else if ((degreeDirection> 78.75) && (degreeDirection <= 101.25)) {
        cardinalDirection = @"E";
    }
    else if ((degreeDirection > 101.25) && (degreeDirection <= 123.75)) {
        cardinalDirection = @"ESE";
    }
    else if ((degreeDirection > 123.75) && (degreeDirection <= 146.25)) {
        cardinalDirection = @"SE";
    }
    else if ((degreeDirection> 146.25) && (degreeDirection <= 168.75)) {
        cardinalDirection = @"SSE";
    }
    else if ((degreeDirection> 168.75) && (degreeDirection <= 191.25)) {
        cardinalDirection = @"S";
    }
    else if ((degreeDirection> 191.25) && (degreeDirection <= 213.75)) {
        cardinalDirection = @"SSW";
    }
    else if ((degreeDirection> 213.75) && (degreeDirection <= 236.25)) {
        cardinalDirection = @"SW";
    }
    else if ((degreeDirection> 236.25) && (degreeDirection <= 258.75)) {
        cardinalDirection = @"WSW";
    }
    else if ((degreeDirection> 258.75) && (degreeDirection <= 281.25)) {
        cardinalDirection = @"W";
    }
    else if ((degreeDirection> 281.25) && (degreeDirection <= 303.75)) {
        cardinalDirection = @"WNW";
    }
    else if ((degreeDirection> 303.75) && (degreeDirection <= 326.25)) {
        cardinalDirection = @"NW";
    }
    else if ((degreeDirection> 326.25) && (degreeDirection <= 348.75)) {
        cardinalDirection = @"NNW";
    }

    return cardinalDirection;

}

- (float)convertTemp: (float)temp toScale: (NSInteger)scale {
    // assume all input is in terms of Kelvin
    if (scale == 0) { // Celsius
        return temp - 273.15;
    }
    else { // Farenheit
        return (temp - 273.15) * 9 * 0.5 + 32;
    }
}

-(NSString *)description {
    return [NSString stringWithFormat:@"\nWeather Conditions For %@\n"
            "%@\n"
            "Temperature: %2.0f F\n"
            "\tHigh: %2.0f F\n"
            "\tLow: %2.0f F\n"
            "Humidity: %@%% \n"
            "Wind: %@ mph %@\n"
            , self.citytName
            , [[self.weatherDetails firstObject] objectForKey:@"description"]
            , [self convertTemp: [[self.mainDetails objectForKey:@"temp"] floatValue] toScale:1]
            , [self convertTemp: [[self.mainDetails objectForKey:@"temp_max"] floatValue] toScale:1]
            , [self convertTemp: [[self.mainDetails objectForKey:@"temp_min"] floatValue] toScale:1]
            , [self.mainDetails objectForKey:@"humidity"]
            , [self.windDetails objectForKey:@"speed"]
            , [self windDirection]
            ];
}
@end
