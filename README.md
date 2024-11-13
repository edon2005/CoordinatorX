# CoordinatorX

## 👋 Getting started

The start contains 3 main steps. As simple as only possible. 

### Step 1️⃣

You need to create an enum for steps in a particular flow.

```swift
enum AppRoute: Route {
    case splash
    case onboarding
    case login
    case home
}
```

### Step 2️⃣

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

### Step 3️⃣

Create Flow structure to make Coordinator working:

```swift
struct AppFlow: DefaultViewFlow {
    var coordinator: AppCoordinator
}
```

### Using CoordinatorX from App

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

Mainly Coordinator protocol contains:\
**var initialRoute: Route** from which route Flow should be started.

**func prepareTransition(for route: RouteType) -> TransitionType** notify Coordinator in which way the view should be appeared.

**func prepareView(for route: RouteType, router: any Router<RouteType>) -> some View** prepare View to be showed.
 
There are 3 types of Coordinators prepared for your app: `ViewCoordinator`, `RedirectionViewCoordinator`, `NavigationCoordinator`.

### ViewCoordinator
Main Coordinator to present a single root `View` and the root `View` can be covered with `sheet`, `fullscreen`, `overlay` or replaced by another `View`.\
`ViewCoordinator` supports next `Transition` types:
```swift
    case dismiss
    case fullScreen
    case multiple([Self])
    case none
    case overlay
    case root
    case set
    case sheet
```
 

### RedirectionViewCoordinator

### NavigationCoordinator
 
## Last but not least 

New version is on horizont with a lot of many sweet functionality.
