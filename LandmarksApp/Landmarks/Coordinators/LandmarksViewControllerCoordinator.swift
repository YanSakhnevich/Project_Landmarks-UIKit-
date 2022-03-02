import UIKit

final class LandmarksViewControllerCoordinator: Coordinator {

    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = LandmarksViewModel()
        
        viewModel.onSelectPlace = { [weak self] location in
            self?.showDetail(location)
        }

        let viewController = LandmarksViewController(viewModel: viewModel)

        navigationController?.setViewControllers([viewController], animated: false)
    }

    func showDetail(_ location: Location) {
        guard let navigationController = navigationController else {
            return
        }

        let coordinator = DetailViewControllerCoordinator(location: location, navigationController: navigationController)
        coordinator.start()
    }
}

