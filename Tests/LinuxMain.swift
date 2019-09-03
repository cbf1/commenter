import XCTest

import commenterTests

var tests = [XCTestCaseEntry]()
tests += commenterTests.allTests()
XCTMain(tests)
