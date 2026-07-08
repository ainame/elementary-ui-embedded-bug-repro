# Swift Snapshot Build Status

This repository is a reduced ElementaryUI project used to check Swift snapshot
behavior with both normal SwiftPM builds and Embedded Swift WASM builds.

## Current result with main-snapshot

The checkout is configured with:

```text
.swift-version: main-snapshot
```

The active toolchain resolves to:

```text
Apple Swift version 6.5-dev (LLVM 7e56002c186efac, Swift d40e60a5e915f1f)
Target: arm64-apple-macosx26.0
Build config: +assertions
swiftCompilerTag: swift-DEVELOPMENT-SNAPSHOT-2026-07-05-a
```

The matching Embedded Swift SDK is installed:

```text
swift-DEVELOPMENT-SNAPSHOT-2026-07-05-a_wasm-embedded
```

Resolved package versions:

```text
ElementaryUI 0.4.1
Elementary   0.7.1
JavaScriptKit 0.56.1
swift-syntax 603.0.2
swift-collections 1.6.0
```

### Native SwiftPM build

Command:

```sh
swift build
```

Observed result:

```text
Build complete! (59.81 secs)
```

### Embedded Swift SDK build

Command:

```sh
swift build \
  --swift-sdk swift-DEVELOPMENT-SNAPSHOT-2026-07-05-a_wasm-embedded \
  --configuration release \
  --product WebApp
```

Observed result:

```text
Build complete! (417.24 secs)
```

## Previous result with 6.4 development snapshot

The previous tested toolchain was:

```text
Apple Swift version 6.4-dev (LLVM 0aa1511f1bca4a6, Swift 80702ec6ad4159b)
swiftCompilerTag: swift-6.4.x-DEVELOPMENT-SNAPSHOT-2026-06-15-a
```

My earlier assumption that normal `swift build` failed with the 6.4 snapshot
was wrong. Both native commands succeeded in this checkout:

```sh
swift build
swift build --product WebApp
```

The actual 6.4 snapshot failure was limited to the Embedded Swift SDK build:

```sh
swift build \
  --swift-sdk swift-6.4.x-DEVELOPMENT-SNAPSHOT-2026-06-15-a_wasm-embedded \
  --configuration release \
  --product WebApp
```

That failed with an internal Swift frontend assertion while compiling
JavaScriptKit 0.56.1:

```text
Abort: function getOrigParamIndex at ParameterPack.cpp:387
Invalid substituted argument index: 1

(substitution_map generic_signature=<A0, A1 where A0 : ConvertibleToJSValue, A1 : ConvertibleToJSValue>
  (substitution A0 -> JSOneshotClosure)
  (substitution A1 -> JSOneshotClosure)
  (conformance type="A0" ... ConvertibleToJSValue ...)
  (conformance type="A1" ... ConvertibleToJSValue ...))

(parameter_list
  JSObject.swift:400:6 - line:400:33
  (parameter "name" apiName="dynamicMember" interface_type="String"))

Please submit a bug report (https://swift.org/contributing/#reporting-bugs)
and include the crash backtrace.

error: Build failed
```

The crash pointed at JavaScriptKit's two-argument dynamic member subscript:

```swift
public subscript<
    A0: ConvertibleToJSValue,
    A1: ConvertibleToJSValue
>(dynamicMember name: String) -> ((A0, A1) -> JSValue)? {
    self[name].function.map { function in
        { function(this: self, $0, $1) }
    }
}
```

## Summary

- The normal native SwiftPM build succeeds with both tested snapshots.
- The original claim that `swift build` itself failed with Swift 6.4 was
  incorrect.
- Swift 6.4 development snapshot
  `swift-6.4.x-DEVELOPMENT-SNAPSHOT-2026-06-15-a` failed only for the Embedded
  Swift WASM release build, with a compiler assertion in
  `ParameterPack.cpp:387`.
- Main snapshot `swift-DEVELOPMENT-SNAPSHOT-2026-07-05-a` succeeds for both the
  native build and the Embedded Swift WASM release build.
- The situation appears fixed in main-snapshot, or at least no longer
  reproducible in this project with the tested package resolution.
