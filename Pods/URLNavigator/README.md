# URLNavigator

![Swift](https://img.shields.io/badge/Swift-3.0-orange.svg)
[![CocoaPods](http://img.shields.io/cocoapods/v/URLNavigator.svg)](https://cocoapods.org/pods/URLNavigator)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Build Status](https://travis-ci.org/devxoul/URLNavigator.svg?branch=master)](https://travis-ci.org/devxoul/URLNavigator)
[![CodeCov](https://img.shields.io/codecov/c/github/devxoul/URLNavigator.svg)](https://codecov.io/gh/devxoul/URLNavigator)
[![CocoaDocs](https://img.shields.io/cocoapods/metrics/doc-percent/URLNavigator.svg)](http://cocoadocs.org/docsets/URLNavigator/)

⛵️ URLNavigator provides an elegant way to navigate through view controllers by URLs. URL patterns can be mapped by using `URLNavigator.map(_:_:)` function.

URLNavigator can be used for mapping URL patterns with 2 kind of types: `URLNavigable` and `URLOpenHandler`. `URLNavigable` is a type which defines an custom initializer and `URLOpenHandler` is a closure which can be executed. Both an initializer and a closure receive an URL and placeholder values.


## Getting Started

#### 1. Understanding URL Patterns

URL patterns can contain placeholders. Placeholders will be replaced with matching values from URLs. Use `<` and `>` to make placeholders. Placeholders can have types: `string`(default), `int`, `float`, and `path`.

For example, `myapp://user/<int:id>` matches with:

* `myapp://user/123`
* `myapp://user/87`

But it doesn't match with:

* `myapp://user/devxoul` (expected int)
* `myapp://user/123/posts` (different url structure)
* `/user/devxoul` (missing scheme)

#### 2. Mapping View Controllers and URL Open Handlers

URLNavigator allows to map view controllers ans URL open handlers with URL patterns. Here's an example of mapping URL patterns with view controllers and a closure. Each closures has three parameters: `url`, `values` and `context`.

* `url` is an URL that is passed from `push()` and `present()`.
* `values` is a dictionary that contains URL placeholder keys and values.
* `context` is a dictionary which contains extra values passed from `push()`, `present()` or `open()`.

```swift
let navigator = Navigator()

// register view controllers
navigator.register("myapp://user/<int:id>") { url, values, context in
  guard let userID = values["id"] as? Int else { return nil }
  return UserViewController(userID: userID)
}
navigator.register("myapp://post/<title>") { url, values, context in
  return storyboard.instantiateViewController(withIdentifier: "PostViewController")
}

// register url open handlers
navigator.handle("myapp://alert") { url, values, context in
  let title = url.queryParameters["title"]
  let message = url.queryParameters["message"]
  presentAlertController(title: title, message: message)
  return true
}
```

#### 3. Pushing, Presenting and Opening URLs

URLNavigator can push and present view controllers and execute closures with URLs.

Provide the `from` parameter to `push()` to specify the navigation controller which the new view controller will be pushed. Similarly, provide the `from` parameter to `present()` to specify the view controller which the new view controller will be presented. If the `nil` is passed, which is a default value, current application's top most view controller will be used to push or present view controllers.

`present()` takes an extra parameter: `wrap`. If a `UINavigationController` class is specified, the new view controller will be wrapped with the class. Default value is `nil`.

```swift
Navigator.push("myapp://user/123")
Navigator.present("myapp://post/54321", wrap: UINavigationController.self)

Navigator.open("myapp://alert?title=Hello&message=World")
```


## Installation

- **For iOS 8+ projects** with [CocoaPods](https://cocoapods.org):

    ```ruby
    pod 'URLNavigator'
    ```

- **For iOS 8+ projects** with [Carthage](https://github.com/Carthage/Carthage):

    ```
    github "devxoul/URLNavigator"
    ```


## Example

You can find an example app [here](https://github.com/devxoul/URLNavigator/tree/master/Example).

1. Build and install the example app.
2. Open Safari app
3. Enter `navigator://user/devxoul` in the URL bar.
4. The example app will be launched.


## Tips and Tricks

#### Where to initialize a Navigator instance

1. Define as a global constant:

    ```swift
    let navigator = Navigator()

    class AppDelegate: UIResponder, UIApplicationDelegate {
      // ...
    }
    ```

2. Register to an IoC container:

    ```swift
    container.register(NavigatorType.self) { _ in Navigator() } // Swinject
    let navigator = container.resolve(NavigatorType.self)!
    ```

3. Inject dependency from a composition root.


#### Where to Map URLs

I'd prefer using separated URL map file.

```swift
struct URLNavigationMap {
  static func initialize(navigator: NavigatorType) {
    navigator.register("myapp://user/<int:id>") { ... }
    navigator.register("myapp://post/<title>") { ... }
    navigator.map("myapp://alert") { ... }
  }
}
```

Then call `initialize()` at `AppDelegate`'s `application:didFinishLaunchingWithOptions:`.

```swift
@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    // Navigator
    URLNavigationMap.initialize(navigator: navigator)
    
    // Do something else...
  }
}
```


#### Implementing AppDelegate Launch Option URL

It's available to open your app with URLs if custom schemes are registered. In order to navigate to view controllers with URLs, you'll have to implement `application:didFinishLaunchingWithOptions:` method.

```swift
func application(
  _ application: UIApplication,
  didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
) -> Bool {
  // ...
  if let url = launchOptions?[.url] as? URL {
    if let opened = navigator.open(url)
    if !opened {
      navigator.present(url)
    }
  }
  return true
}

```


#### Implementing AppDelegate Open URL Method

You'll might want to implement custom URL open handler. Here's an example of using URLNavigator with other URL open handlers.

```swift
func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
  // If you're using Facebook SDK
  let fb = FBSDKApplicationDelegate.sharedInstance()
  if fb.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) {
    return true
  }

  // URLNavigator Handler
  if navigator.open(url) {
    return true
  }

  // URLNavigator View Controller
  if navigator.present(url, wrap: UINavigationController.self) != nil {
    return true
  }

  return false
}
```


#### Passing Extra Values when Pushing, Presenting and Opening

```swift
let context: [AnyHashable: Any] = [
  "fromViewController": self
]
Navigator.push("myapp://user/10", context: context)
Navigator.present("myapp://user/10", context: context)
Navigator.open("myapp://alert?title=Hi", context: context)
```


## License

URLNavigator is under MIT license. See the [LICENSE](LICENSE) file for more info.
