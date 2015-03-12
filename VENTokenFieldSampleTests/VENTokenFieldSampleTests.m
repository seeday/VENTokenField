//
//  VENTokenFieldSampleTests.m
//  VENTokenFieldSampleTests
//
//  Created by Ayaka Nonaka on 6/20/14.
//  Copyright (c) 2014 Venmo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <KIF/KIF.h>

@interface VENTokenFieldSampleTests : XCTestCase
@end

@implementation VENTokenFieldSampleTests

- (void)testBasicFlow
{
    [tester enterText:@"Ayaka" intoViewWithAccessibilityLabel:@"To"];
    [tester enterTextIntoCurrentFirstResponder:@"\n"];
    [tester waitForViewWithAccessibilityLabel:@"Ayaka,"];

    [tester enterTextIntoCurrentFirstResponder:@"Mark\n"];
    [tester waitForViewWithAccessibilityLabel:@"Mark,"];

    [tester enterTextIntoCurrentFirstResponder:@"Neeraj\n"];
    [tester waitForViewWithAccessibilityLabel:@"Neeraj,"];

    [tester enterTextIntoCurrentFirstResponder:@"Octocat\n"];
    [tester waitForViewWithAccessibilityLabel:@"Octocat,"];

    // Make sure everything else is still there.
    [tester waitForViewWithAccessibilityLabel:@"Ayaka,"];
    [tester waitForViewWithAccessibilityLabel:@"Mark,"];

    // Delete
    [tester enterTextIntoCurrentFirstResponder:@"\b"];
    [tester enterTextIntoCurrentFirstResponder:@"\b"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Octocat,"];

    // Clear remaining names to reset state for next test
    [tester tapViewWithAccessibilityLabel:@"To"];
    [tester enterTextIntoCurrentFirstResponder:@"\b"];
    [tester enterTextIntoCurrentFirstResponder:@"\b"];
    [tester enterTextIntoCurrentFirstResponder:@"\b"];
    [tester enterTextIntoCurrentFirstResponder:@"\b"];
    [tester enterTextIntoCurrentFirstResponder:@"\b"];
    [tester enterTextIntoCurrentFirstResponder:@"\b"];
}

- (void)testSuggestionFlow
{
    [tester enterText:@"Be" intoViewWithAccessibilityLabel:@"To"];
    [tester waitForViewWithAccessibilityLabel:@"Ben"];
    [tester tapViewWithAccessibilityLabel:@"Ben"];
    [tester waitForViewWithAccessibilityLabel:@"Ben,"];
}

- (void)testResignFirstResponder
{
    [tester tapViewWithAccessibilityLabel:@"To"];
    [tester tapViewWithAccessibilityLabel:@"Resign First Responder"];
    [tester waitForAbsenceOfKeyboard];
}

- (void)testResignFirstResponderAndCollapse
{
    [tester tapViewWithAccessibilityLabel:@"To"];
    [tester tapViewWithAccessibilityLabel:@"Resign First Responder"];
    [tester waitForAbsenceOfKeyboard];
    [tester tapViewWithAccessibilityLabel:@"Collapse token field"];

    // Confirm the collapse lable
    [tester waitForViewWithAccessibilityLabel:@"0 people"];

    // Tap on the field and enter names. Lable isn't tappable, so tap the point.
    UIView *tokenField = [tester waitForViewWithAccessibilityLabel:@"0 people"];
    [tester tapScreenAtPoint:tokenField.center];

    [tester enterTextIntoCurrentFirstResponder:@"Ayaka\n"];
    [tester waitForViewWithAccessibilityLabel:@"Ayaka,"];

    [tester enterTextIntoCurrentFirstResponder:@"Mark\n"];
    [tester waitForViewWithAccessibilityLabel:@"Mark,"];

    [tester enterTextIntoCurrentFirstResponder:@"Neeraj\n"];
    [tester waitForViewWithAccessibilityLabel:@"Neeraj,"];

    [tester enterTextIntoCurrentFirstResponder:@"Octocat\n"];
    [tester waitForViewWithAccessibilityLabel:@"Octocat,"];

    [tester tapViewWithAccessibilityLabel:@"Resign First Responder"];
    [tester waitForAbsenceOfKeyboard];
    [tester tapViewWithAccessibilityLabel:@"Collapse token field"];

    // Confirm the collapse label
    [tester waitForViewWithAccessibilityLabel:@"4 people"];

    // Remove one name and check again
    [tester tapScreenAtPoint:tokenField.center];
    [tester enterTextIntoCurrentFirstResponder:@"\b"];
    [tester enterTextIntoCurrentFirstResponder:@"\b"];
    [tester tapViewWithAccessibilityLabel:@"Resign First Responder"];
    [tester waitForAbsenceOfKeyboard];
    [tester tapViewWithAccessibilityLabel:@"Collapse token field"];
    [tester waitForViewWithAccessibilityLabel:@"3 people"];
}

@end
