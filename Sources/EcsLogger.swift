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

import Foundation

enum LogLevel : String, Codable {
  case debug = "debug"
  case info = "info"
  case warn = "warn"
  case error = "error"
}

struct LogMessage<T: Codable>: Codable {
  let message: String
  let timestamp: String
  let logLevel: LogLevel
  let ecsVersion: String = "1.12.2"
  let labels:T

  enum CodingKeys: String, CodingKey {
    case message = "message"
    case timestamp = "@timestamp"
    case logLevel = "log.level"
    case ecsVersion = "ecs.version"
    case labels = "labels"
  }
}

class EcsLogger {
  private let logFilePath: String
  
  init(logFilePath: String) {
    self.logFilePath = logFilePath
    
    // Create the file if it doesn't exist
    if !FileManager.default.fileExists(atPath: logFilePath) {
      FileManager.default.createFile(atPath: logFilePath, contents: nil, attributes: nil)
    }
  }

  func log<T: Codable>(level: LogLevel, message: String, logData: T = "") {
    if let fileHandle = FileHandle(forWritingAtPath: logFilePath) {
      fileHandle.seekToEndOfFile()

      let formatter = ISO8601DateFormatter()
      formatter.formatOptions = [.withInternetDateTime]
      let timestamp = formatter.string(from: Date())

      let logMessage = LogMessage<T>(message: message, timestamp: timestamp, logLevel: level, labels: logData)
      let encoder = JSONEncoder()
      encoder.dateEncodingStrategy = .iso8601
      let m = try! encoder.encode(logMessage)

      fileHandle.write(m)
      fileHandle.write("\n".data(using: .utf8)!) 
      fileHandle.closeFile()
    } else {
      // TODO:  Error handling
    }
  }



}
