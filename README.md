# SwiftEcsLogger

## What?

`SwiftEcsLogger`is a simplified logger for server-side or command-line Swift applications.  

## Why?

Perhaps the functionality already exists in another package, but every logger I looked at had emojis and unnecessary complexity.  Furthermore, they didn't (seem to) have a straightforward manner to generate ECS-compatible logs suitable for ingesting into Elasticsearch.

## How?

### Adding to `Package.swift`

Add the following to your `Package.swift` top-level dependencies:
```
    dependencies: [
      .package(url:  "https://github.com/iachievedit/swiftecslogger", branch:("main")),
    ],
```

And then, for any target you want to link to the package:
```
    targets: [
        .executableTarget( name: "<yourtarget>", dependencies: [
          .product(name: "SwiftEcsLogger", package: "SwiftEcsLogger")
        ])
    ]
```

### Adding to Application

```
import SwiftEcsLogger

let logger = EcsLogger(logFilePath:  "yourtarget.log")
```

### Simple Message Logging

```
logger.log(level:  .info, message:  "Log, log, it's big, it's heavy, it's wood")
```

### Logging Labels

Structured logging takes logging to a whole new level.  Let's say we're developing an application which reads and logs the CPU temperature at a given time.  We could log it like:

```swift
logger.log(level: .info, message:  "The current CPU temperature is \{cpuTemperature}")
```

This works, but, consider the individual that is looking for CPU temperatures above 60 degrees Celsius.  That'd be a lot easier if we could use Kibana to search for it.  Structured logging can help:

```swift
struct CpuTemperature : Codable {
  let temperature:Double
  var unit:String = "Celsius"

  enum CodingKeys:  String, CodingKey {
    case temperature = "cpu.temperature"
    case unit        = "cpu.unit"
  }
}

let reading  = CpuTemperature(temperature:  34.7)
logger.log(level:  .info, message:  "CPU temperature reading", logData: reading)
```




