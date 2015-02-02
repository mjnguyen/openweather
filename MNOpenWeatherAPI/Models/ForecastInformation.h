//
//  ForecastInformation.h
//  MNOpenWeatherAPI
//
//  Created by Michael Nguyen on 2/2/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForecastInformation : NSObject

@property (nonatomic, copy)   NSString          *cityName;
@property (nonatomic, copy)   NSString          *cityId;
@property (nonatomic, copy)   NSDictionary      *coordinates;
@property (nonatomic, assign) int               *daysForecast;
@property (nonatomic, copy)   NSArray           *forecasts;

- (instancetype)initWithJsonData: (id)jsonData;
@end
