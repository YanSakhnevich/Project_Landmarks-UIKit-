import UIKit

final class DetailViewControllerCoordinator: Coordinator {

    private weak var navigationController: UINavigationController?
    private let location: Location

    init(location: Location, navigationController: UINavigationController) {
        self.location = location
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = DetailViewModel(location: location)
        let viewController = DetailViewController(
            viewModel: viewModel,
            nameText: viewModel.location.name,
            parkText: viewModel.location.park,
            isFavorite: viewModel.location.isFavorite,
            stateText: viewModel.location.state,
            imageNameText: viewModel.location.imageName)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
