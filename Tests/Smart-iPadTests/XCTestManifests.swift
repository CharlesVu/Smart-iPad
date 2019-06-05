import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Smart_iPadTests.allTests),
    ]
}
#endif
