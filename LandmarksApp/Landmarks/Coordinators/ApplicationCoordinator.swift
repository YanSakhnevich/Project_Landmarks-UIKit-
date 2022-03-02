import UIKit

final class ApplicationCoordinator: BaseCoordinator, Coordinator {
    
    private let navigationController = UINavigationController()
    private var window: UIWindow?
    private let scene: UIWindowScene
    
    init(scene: UIWindowScene) {
        self.scene = scene
        super.init()
    }
    
    func start() {
        initWindow()
        startMainFlow()
    }
    
    private func initWindow() {
        let window = UIWindow(windowScene: scene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    private func startMainFlow() {
        let coordinator = LandmarksViewControllerCoordinator(navigationController: navigationController)
        addDependency(coordinator)
        coordinator.start()
    }
    
}
