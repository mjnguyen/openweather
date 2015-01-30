//
//  WeatherInformation.h
//  MNOpenWeatherAPI
//
//  Created by Michael Nguyen on 1/29/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
// Object to Model JSON response from OpenWeatherMap API
//{
//"coord":{
//    "lon":145.77,
//    "lat":-16.92
//},
//"sys":{
//    "message":0.0329,
//    "country":"AU",
//    "sunrise":1422475420,
//    "sunset":1422521781
//},
//"weather":[
//           {
//               "id":803,
//               "main":"Clouds",
//               "description":"broken clouds",
//               "icon":"04n"
//           }
//           ],
//"base":"cmc stations",
//"main":{
//    "temp":303.742,
//    "temp_min":303.742,
//    "temp_max":303.742,
//    "pressure":1000.95,
//    "sea_level":1018.4,
//    "grnd_level":1000.95,
//    "humidity":84
//},
//"wind":{
//    "speed":2.81,
//    "deg":123.505
//},
//"clouds":{
//    "all":56
//},
//"dt":1422575875,
//"id":2172797,
//"name":"Cairns",
//"cod":200
//}

@interface WeatherInformation : NSObject

@property (nonatomic, strong) NSDictionary      *coordinates;
@property (nonatomic, strong) NSDictionary      *geoCodeSystem; // "sys"
@property (nonatomic, strong) NSArray           *weatherDetails;
@property (nonatomic, copy)   NSString          *baseInformation;
@property (nonatomic, strong) NSDictionary      *mainDetails;
@property (nonatomic, strong) NSDictionary      *windDetails;   // "wind"
@property (nonatomic, strong) NSDictionary      *cloudDetails;
@property (nonatomic, copy)   NSDate            *timestamp;
@property (nonatomic, copy)   NSString          *citytName;
@property (nonatomic, copy)   NSString          *cityId;
@property (nonatomic, copy)   NSString          *httpStatusCode; // "cod"

-(instancetype)initWithJsonData:(id)jsonData;

@end
