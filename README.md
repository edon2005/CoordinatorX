<br/><br/>
<p align="center">
 <picture>
  <source media="(prefers-color-scheme: dark)" srcset="./logo_dark_mode.png">
  <img alt="Text changing depending on mode. Light: 'So light!' Dark: 'So dark!'" src="./logo_light_mode.png">
</picture>
</p>

<br/>
<br/>

<div align="center">

[![GitHub Release](https://img.shields.io/github/release/edon2005/coordinatorx.svg)](https://github.com/edon2005/coordinatorx/releases)
![Static Badge](https://img.shields.io/badge/swift_6-ready-green)
![Static Badge](https://img.shields.io/badge/UI-SwiftUI-green)
![Static Badge](https://img.shields.io/badge/SPM-ready-green)
![Static Badge](https://img.shields.io/badge/demo-ready-green)
<br/>
![Static Badge](https://img.shields.io/badge/iOS-16.0-FF0000)
![Static Badge](https://img.shields.io/badge/macOS-13.0-FF0000)
![Static Badge](https://img.shields.io/badge/tvOS-16.0-FF0000)
![Static Badge](https://img.shields.io/badge/visionOS-1.0-FF0000)
![Static Badge](https://img.shields.io/badge/watchOS-9.0-FF0000)
<br/>
<br/>
<br/>
</div>

## 👋 Getting started

There are only 3 steps:

#### 1️⃣ Create an enum for steps in a particular flow.

```swift
enum AppRoute: Route {
    case splash
    case onboarding
    case login
    case home
}
```
<br/>

#### 2️⃣ Create a Coordinator class for handling steps.

```swift
final class AppCoordinator: ViewCoordinator {

    var initialRoute: AppRoute

    init(initialRoute: AppRoute) {
        self.initialRoute = initialRoute
    }

    @MainActor
    func prepareTransition(for route: AppRoute) -> ViewTransitionType {
        switch route {
        case .splash: .root
        case .onboarding: .fullScreen
        case .login: .sheet
        case .home: .multiple(.root, .dismiss)
        }
    }

    @MainActor
    @ViewBuilder
    func prepareView(for route: AppRoute, router: any Router<AppRoute>) -> some View {
        switch route {
        case .splash:
            let viewModel = TemplateViewModel(color: .red, nextStep: .onboarding, router: router)
            TemplateView(viewModel: viewModel)

        case .onboarding:
            let coordinator = OnboardingCoordinator(initialRoute: .screen1, parentRouter: router)
            OnboardingFlow(coordinator: coordinator)
        ....
        }
    }
}
```
<br/>

#### 3️⃣ Create a Flow structure to make Coordinator working:

```swift
struct AppFlow: DefaultViewFlow {
    var coordinator: AppCoordinator
}
```
<br/>

#### 🏁 Using CoordinatorX from App

```swift
@main
struct CoordinatorX_ExampleApp: App {

    private let coordinator = AppCoordinator(initialRoute: .splash)

    var body: some Scene {
        WindowGroup {
            AppFlow(coordinator: coordinator)
        }
    }
}
```
<br/>

## 🛠 Installation

#### Swift Package Manager

See [this WWDC presentation](https://developer.apple.com/videos/play/wwdc2019/408/) about more information how to adopt Swift packages in your app.
Specify `https://github.com/edon2005/CoordinatorX.git` as the `CoordinatorX` package link. 
<br/>

#### Manually

If you prefer not to use any of the dependency managers, you can integrate CoordinatorX into your project manually, by downloading the source code and placing the files on your project directory.  

<br/>

## 🔔 In details

### What is Coordinator protocol

`var initialRoute: Route` from which route a Flow should be started.

`func prepareTransition(for route: RouteType) -> TransitionType` notify Coordinator how to show a view for route.

`func prepareView(for route: RouteType, router: any Router<RouteType>) -> some View` prepare View to be showed.
 
There are 3 types of Coordinators prepared for your app:
- `ViewCoordinator`
- `RedirectionViewCoordinator`
- `NavigationCoordinator`

**‼️** Every `fullScreen`, `overlay`, `sheet` has own Context. That means that you can call from them appearing another part of `fullScreen`, `overlay`, `sheet`. And it will be handled by the same `Coordinator`

### ViewCoordinator
It is to present a single root `View` and the root `View` can be covered with `sheet`, `fullscreen`, `overlay` or replaced by another `View`.\
`ViewCoordinator` supports next `Transition` types:
```swift
    case dismiss
    case fullScreen
    case none
    case overlay
    case root
    case set
    case sheet
```

`Transition` actions:\
`dismiss` can be applied to dismiss `fullScreen`, `overlay`, `sheet`\
`fullScreen` is applied to cover root `View` with modal `View`\
`none` just do nothing\
`overlay` is applied to cover root `View` with overlay `View`\
`root` is applied to replace root `View` with another one. It was created to be used from `fullScreen`, `overlay`, `sheet`\
`set` should be applied to replace `View` which is presented as `fullScreen`, `overlay`, `sheet`\
`sheet` is applied to cover root `View` with sheet `View`

### RedirectionViewCoordinator
It is similar to `ViewCoordinator`, but can be understood as children coordinator. It has identical `Transition` types plus one additional:
```swift
    case parent(ParentRouteType)
```
Which is used to triger action on parent flow.

### NavigationCoordinator
It is to present Navigation Flow. It has identical `Transition` types as `ViewCoordinator` plus few additional:
```swift
    case pop
    case popToRoot
    case push
```
<br/>

## Last but not least 

Thanks for reading until the end! 🫡
