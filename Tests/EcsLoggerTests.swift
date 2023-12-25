/*
  SwiftEcsLogger

  Copyright 2023 iAchieved.it LLC

  MIT License

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
*/
import XCTest
@testable import SwiftEcsLogger

struct Member : Codable {
  let first_name: String
  let last_name: String
  let address: String
  let address2: String
  let city: String
  let state: String
  let zip: String
  enum CodingKeys: String, CodingKey {
        case first_name = "member.first_name"
        case last_name = "member.last_name"
        case address = "member.address"
        case address2 = "member.address2"
        case city = "member.city"
        case state = "member.state"
        case zip = "member.zip"
  }
}

class EcsLoggerTests: XCTestCase {
  
  func testLog() {
    // Create a temporary log file path for testing
    let temporaryLogFilePath = "test.log"
    
    // Create an instance of EcsLogger
    let logger = EcsLogger(logFilePath: temporaryLogFilePath)
    
    // Log a message
    logger.log(level: .info, message: "Test log message")
    
    
    // Read the contents of the log file
    let fileContents = try! String(contentsOfFile: temporaryLogFilePath)
    
    // Assert that the log message is present in the file
    XCTAssertTrue(fileContents.contains("Test log message"))
  }

  func testCodable() {
    let temporaryLogFilePath = "test.log"
    let logger = EcsLogger(logFilePath: temporaryLogFilePath)
    let member = Member(first_name: "John", last_name: "Doe", address: "123 Main St", address2: "", city: "Anytown", state: "CA", zip: "12345")
    logger.log(level: .info, message: "Test log message", logData: member) 
  }


  
}
