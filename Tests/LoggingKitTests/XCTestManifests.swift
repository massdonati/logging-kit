import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(LoggingKitTests.allTests),
        testCase(MetadataTests.allTests),
    ]
}
#endif
