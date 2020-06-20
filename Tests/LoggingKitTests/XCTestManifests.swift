import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(StringFormatterTests.allTests),
        testCase(LogHandlerAutoStreamConformanceTests.allTests),
        testCase(LoggingKitTests.allTests),
        testCase(MetadataTests.allTests),
    ]
}
#endif
