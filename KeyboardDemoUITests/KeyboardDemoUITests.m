//
//  KeyboardDemoUITests.m
//  KeyboardDemoUITests
//
//  Created by 李小龙 on 2017/3/6.
//  Copyright © 2017年 李小龙. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface KeyboardDemoUITests : XCTestCase

@end

@implementation KeyboardDemoUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.buttons[@"Push"] tap];
    [app.buttons[@"64"] tap];
    
    XCUIElement *element2 = [[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element;
    XCUIElement *element = [[[[element2 childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element;
    [[element childrenMatchingType:XCUIElementTypeTextField].element tap];
    [element2 tap];
    [app.navigationBars[@"PushTwoView"].buttons[@"Back"] tap];
    [app.buttons[@"0"] tap];
    
    XCUIElement *textField = [[element childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:0];
    [textField tap];
    [textField typeText:@"d"];
    [[[element childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:1] tap];
    [[[element childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:2] tap];
    [element2 tap];
    [app.navigationBars[@"PushOneView"].buttons[@"Back"] tap];
    

}

@end
