# CoordinatorX

## 👋 Getting started

The start contains 3 main steps. As simple as only possible. 

### 1️⃣ Step

You need to create an enum for steps in a particular flow.

```swift
enum AppRoute: Route {
    case splash
    case onboarding
    case login
    case home
}
```

### 2️⃣ Step

Create Coordinator class for handling steps.


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
        .
        .
        .
        .
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

        .
        .
        .
        .
        }
    }
}
```

### 3️⃣ Step

Create Flow structure to make Coordinator working:

```swift
struct AppFlow: DefaultViewFlow {
    var coordinator: AppCoordinator
}
```

### 🏁 Using CoordinatorX from App

Just set it up in your App file:

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

## Important details

### What is Coordinator protocol

Mainly Coordinator protocol contains:

`var initialRoute: Route` from which route Flow should be started.

`func prepareTransition(for route: RouteType) -> TransitionType` notify Coordinator in which way the view should be appeared.

`func prepareView(for route: RouteType, router: any Router<RouteType>) -> some View` prepare View to be showed.
 
There are 3 types of Coordinators prepared for your app:
- `ViewCoordinator`
- `RedirectionViewCoordinator`
- `NavigationCoordinator`

### ViewCoordinator
The Coordinator is to present a single root `View` and the root `View` can be covered with `sheet`, `fullscreen`, `overlay` or replaced by another `View`.\
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

Small clarification on `Transation`:\
`dismiss` can be applied to dismiss `fullScreen`, `overlay`, `sheet`\
`fullScreen` is applied to cover root `View` with modal `View`\
`none` just do nothing\
`overlay` is applied to cover root `View` with overlay `View`\
`root` is applied to replace root `View` with another one. It was created to be used from `fullScreen`, `overlay`, `sheet`\
`set` should be applied to replace `View` which is presented as `fullScreen`, `overlay`, `sheet`\
`sheet` is applied to cover root `View` with sheet `View`

**‼️** Every `fullScreen`, `overlay`, `sheet` has own Context. That means that you can call from them appearing another part of `fullScreen`, `overlay`, `sheet`. And it will be handled by the same `Coordinator`

### RedirectionViewCoordinator
The Coordinator is similar to `ViewCoordinator`, but can be understood as children coordinator. It has identical `Transition` types plus one additional:
```swift
    case parent(ParentRouteType)
```
Which is used to triger action on parent flow.

### NavigationCoordinator
The Coordinator is to present Navigation Flow. It has identical `Transition` types as `ViewCoordinator` plus few additional:
```swift
    case pop
    case popToRoot
    case push
```
Supposing the meaning of these `Transition` is clean to everyone 🙄

## Last but not least 

Thanks for reading till the end! 🫡
