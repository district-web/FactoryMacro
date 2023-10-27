# Macro for Factory

This repository provide a simple way to create a `CustomContainer` [Docs](https://hmlongco.github.io/Factory/documentation/factory/containers#Custom-Containers)

Custom container need some boilerplate, and this repository provide a macro to remove the repeated code.

## What is Factory ?

[Factory](https://github.com/hmlongco/Factory) is a new approach to Container-Based Dependency Injection for Swift and SwiftUI.

### Writing CustomContainer with macro

All custom container need to provide this code 
```swift
final class MyContainer: SharedContainer {
     public static let shared = MyContainer()
     public let manager = ContainerManager()
}
```

with this macro
```swift
@FactoryContainer
final class MyContainer {

}
```

And voila!


## Installation

**Swift 5.9 is required**

### Swift Package Manager (SPM)
```swift
dependencies: [
    .package(url: "https://github.com/district-web/FactoryMacro.git", from: "1.0.0"),
    .package(url: "https://github.com/hmlongco/Factory.git", .upToNextMinor(from: "2.2.0")),
],
targets: [
    .target(name: "MyTarget", dependencies: ["Factory", "FactoryMacro]),
]
```

