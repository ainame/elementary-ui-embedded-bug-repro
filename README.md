# ElementaryUI Embedded Swift FunctionView Repro

While trying a router implementation for ElementaryUI, I hit this Embedded
Swift WASM `FunctionView` build failure. This SwiftPM package reduces that
router-shaped code to `Sources/WebApp/Routes.swift` and a small app that
reproduces the issue.

## Environment

- Swift: `Apple Swift version 6.3.2 (swift-6.3.2-RELEASE)`
- Embedded Swift SDK: `swift-6.3.2-RELEASE_wasm-embedded`
- ElementaryUI: `0.2.3`
- Elementary: `0.7.1`

## Reproduce

```sh
swift build \
  --swift-sdk swift-6.3.2-RELEASE_wasm-embedded \
  --configuration release \
  --product WebApp
```

or `make`

## Error

The build fails while compiling `WebApp` with diagnostics pointing into
ElementaryUI:

```text
ElementaryUI/Views/Function/_FunctionView.swift:30:14:
error: cannot specialize generic function or default protocol method in this context [#EmbeddedRestrictions]
node.patch(view, tx: &tx)

classes cannot have a non-final, generic method 'runUpdate(tx:)' in embedded Swift
classes cannot have a non-final, generic method 'progressAnimation(tx:)' in embedded Swift
ElementaryUI/Views/Function/_FunctionNode.swift:150:13:
error: classes cannot have a non-final, generic method 'SchedulableFunction' in embedded Swift
```

Full logs

<details>

```
% make
swift build \
                --swift-sdk swift-6.3.2-RELEASE_wasm-embedded \
                --configuration release \
                --product WebApp
[1/1] Planning build
Building for production...
/path/to/elementary-ui-embedded-bug-repro/.build/checkouts/elementary-ui/Sources/ElementaryUI/Views/Function/_FunctionView.swift:30:14: error: cannot specialize generic function or default protocol method in this context [#EmbeddedRestrictions]
28 |         tx: inout _TransactionContext
29 |     ) {
30 |         node.patch(view, tx: &tx)
   |              `- error: cannot specialize generic function or default protocol method in this context [#EmbeddedRestrictions]
31 |     }
32 | }

<unknown>:0: note: generic specialization called here
<unknown>:0: note: generic specialization called here
<unknown>:0: note: generic specialization called here
<unknown>:0: note: generic specialization called here
<unknown>:0: note: generic specialization called here
<unknown>:0: note: generic specialization called here
/path/to/elementary-ui-embedded-bug-repro/Sources/WebApp/App.swift:7:9: note: generic specialization called here
 5 |   static func main() {
 6 |     let app = Application(RootView())
 7 |     app.mount(in: "#app")
   |         `- note: generic specialization called here
 8 |   }
 9 | }

<unknown>:0: error: classes cannot have a non-final, generic method 'runUpdate(tx:)' in embedded Swift [#EmbeddedRestrictions]
<unknown>:0: error: classes cannot have a non-final, generic method 'progressAnimation(tx:)' in embedded Swift [#EmbeddedRestrictions]
<unknown>:0: error: classes cannot have a non-final, generic method 'init(child:animatedValue:wiredValue:depthInTree:)' in embedded Swift [#EmbeddedRestrictions]
<unknown>:0: error: classes cannot have a non-final, generic method 'deinit' in embedded Swift [#EmbeddedRestrictions]
/path/to/elementary-ui-embedded-bug-repro/.build/checkouts/elementary-ui/Sources/ElementaryUI/Views/Function/_FunctionNode.swift:150:13: error: classes cannot have a non-final, generic method 'SchedulableFunction' in embedded Swift [#EmbeddedRestrictions]
148 | }
149 |
150 | final class SchedulableFunction<
    |             `- error: classes cannot have a non-final, generic method 'SchedulableFunction' in embedded Swift [#EmbeddedRestrictions]
151 |     Value: __FunctionView,
152 |     Child: _Mountable,

<unknown>:0: error: classes cannot have a non-final, generic method 'runUpdate(tx:)' in embedded Swift [#EmbeddedRestrictions]
<unknown>:0: error: classes cannot have a non-final, generic method 'progressAnimation(tx:)' in embedded Swift [#EmbeddedRestrictions]
<unknown>:0: error: classes cannot have a non-final, generic method 'init(child:animatedValue:wiredValue:depthInTree:)' in embedded Swift [#EmbeddedRestrictions]
<unknown>:0: error: classes cannot have a non-final, generic method 'deinit' in embedded Swift [#EmbeddedRestrictions]
/path/to/elementary-ui-embedded-bug-repro/.build/checkouts/elementary-ui/Sources/ElementaryUI/Views/Function/_FunctionNode.swift:150:13: error: classes cannot have a non-final, generic method 'SchedulableFunction' in embedded Swift [#EmbeddedRestrictions]
148 | }
149 |
150 | final class SchedulableFunction<
    |             `- error: classes cannot have a non-final, generic method 'SchedulableFunction' in embedded Swift [#EmbeddedRestrictions]
151 |     Value: __FunctionView,
152 |     Child: _Mountable,

[#EmbeddedRestrictions]: <https://docs.swift.org/compiler/documentation/diagnostics/embedded-restrictions>

make: *** [build] Error 1
ainame@Satoshis-MacBook-Pro elementary-ui-embedded-bug-repro % codex app
Opening Codex Desktop at /Applications/Codex.app...
Opening workspace /path/to/elementary-ui-embedded-bug-repro...
```

</details>
