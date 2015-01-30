//
//  MNOpenWeatherAPITests.m
//  MNOpenWeatherAPITests
//
//  Created by Michael Nguyen on 1/29/15.
//  Copyright (c) 2015 Michael Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MNWeatherAPI.h"
#import "AppDelegate.h"
#import "ViewController.h"


@interface MNOpenWeatherAPITests : XCTestCase

@property (nonatomic, readwrite, weak) AppDelegate *appDelegate;
@property (nonatomic, readwrite, weak) ViewController *mainViewController;

@end

@implementation MNOpenWeatherAPITests  {
    MNWeatherAPI *apiHandler;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    self.mainViewController = (ViewController *) self.appDelegate.window.rootViewController;
    apiHandler = self.mainViewController.apiHandler;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetCurrentWeatherByCitySanJose {
    XCTestExpectation *weatherByCityName = [self expectationWithDescription:@"getting weather by City Name"];
    [apiHandler currentWeatherByCityName:@"San Jose, CA" withCallback:^(NSError *error, WeatherInformation *result) {
        XCTAssertNil(error);
        [weatherByCityName fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if (error != nil) {
            XCTFail(@"test timed out or some error occurred");
        }
    }];
    
}

// test using GPS for New York
//"coord":{"lat":43.000351,"lon":-75.499901},

- (void)testGetCurrentWeatherByGPSCoordinates {
    XCTestExpectation *weatherByGPSCoords = [self expectationWithDescription:@"getting weather by GPS Coordinates"];

    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(43.000351, -75.499901);
    [apiHandler currentWeatherByCoordinate:coords withCallback:^(NSError *error, WeatherInformation *result) {
        XCTAssertNil(error);
        [weatherByGPSCoords fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if (error != nil) {
            XCTFail(@"test timed out or some error occurred");
        }
    }];
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        [apiHandler currentWeatherByCityName:@"San Jose, CA" withCallback:^(NSError *error, WeatherInformation *result) {
            XCTAssertNil(error);
            NSLog(@"Finished test call");
        }];

    }];
}

@end
