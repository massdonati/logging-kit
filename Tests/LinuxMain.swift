import XCTest

#if os(Linux) || os(FreeBSD)
@testable import LoggingKitTests

XCTMain([
    testCase(LogHandlerAutoStreamConformanceTests.allTests),
    testCase(LoggingKitTests.allTests),
    testCase(MetadataTests.allTests),
    testCase(StringFormatterTests.allTests),
])
#endif
