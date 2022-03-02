import UIKit
import SnapKit
import MapKit
import PureLayout

class DetailViewController: UIViewController {
    
    private let spinnerView = UIActivityIndicatorView(style: .large)
    private let viewModel: DetailViewModel
    private var nameText: String
    private var parkText: String
    private var isFavorite: Bool
    private var stateText: String
    private var imageNameText: String
    
    init(
        viewModel: DetailViewModel,
        nameText: String,
        parkText: String,
        isFavorite: Bool,
        stateText: String,
        imageNameText: String
    ) {
        self.viewModel = viewModel
        self.nameText = nameText
        self.parkText = parkText
        self.isFavorite = isFavorite
        self.stateText = stateText
        self.imageNameText = imageNameText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupView()
        setupConstraints()
        setupViewModel()
        viewModel.send(.viewIsReady)
    }
    
    private func setupViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .initial:
                self.spinnerView.startAnimating()
                
            case .loading:
                self.spinnerView.startAnimating()
                self.setRegion()
                
            case .loaded:
                self.spinnerView.stopAnimating()
                self.showContent()
                
            case let .error(error):
                print(error)
                
            }
        }
    }
    
    private func setRegion() {
        DispatchQueue.global().async {
            guard let region = self.viewModel.onSelectRegion else { return }
            self.mapView.setRegion(region, animated: false)
            DispatchQueue.main.async {
                self.viewModel.send(.mapIsLoaded)
            }
        }
    }
    
    private func showContent() {
        UIView.animate(withDuration: 0.25) {
            self.mapView.alpha = 1
            self.conteinerView.alpha = 1
            self.name.alpha = 1
            self.place.alpha = 1
            self.detailPlace.alpha = 1
            self.favouriteImage.alpha = 1
            self.mapView.alpha = 1
            self.placeImage.alpha = 1
        }
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        let views: [UIView] = [
            mapView,
            conteinerView,
            name,
            detailPlace,
            favouriteImage,
            place,
            spinnerView
        ]
        self.conteinerView.addSubview(placeImage)
        self.view.addSubviews(views)
    }
    
    lazy var placeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.autoSetDimensions(to: CGSize(width: 250.0, height: 250.0))
        imageView.alpha = 0
        imageView.image = UIImage(named: imageNameText)
        imageView.layer.borderWidth = 5.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 125.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var conteinerView: UIView = {
        let view = UIView()
        view.autoSetDimensions(to: CGSize(width: 250.0, height: 250.0))
        view.alpha = 0
        view.backgroundColor = .white
        view.layer.cornerRadius = 125.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        view.layer.shadowRadius = 7.0
        view.layer.shadowOpacity = 0.9
        return view
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.toAutoLayout()
        mapView.alpha = 0
        return mapView
    }()
    
    private lazy var name: UILabel = {
        let name = UILabel()
        name.toAutoLayout()
        name.alpha = 0
        name.text = nameText
        name.numberOfLines = 0
        name.font = UIFont.systemFont(ofSize: 26, weight: .regular)
        return name
    }()
    
    private lazy var place: UILabel = {
        let place = UILabel()
        place.toAutoLayout()
        place.alpha = 0
        place.text = stateText
        place.numberOfLines = 0
        place.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return place
    }()
    
    private lazy var detailPlace: UILabel = {
        let detailPlace = UILabel()
        detailPlace.toAutoLayout()
        detailPlace.alpha = 0
        detailPlace.text = parkText
        detailPlace.numberOfLines = 2
        detailPlace.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return detailPlace
    }()
    
    private lazy var favouriteImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "star.fill"))
        image.alpha = 0
        if isFavorite {
            image.isHidden = false
        } else {
            image.isHidden = true
        }
        image.toAutoLayout()
        image.tintColor = .systemYellow
        return image
    }()
    
    func setupConstraints() {
        
        spinnerView.snp.makeConstraints { spiner in
            spiner.centerX.equalTo(self.view.safeAreaLayoutGuide.snp.centerX)
            spiner.centerY.equalTo(self.view.safeAreaLayoutGuide.snp.centerY)
        }
        mapView.snp.makeConstraints { map in
            map.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            map.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            map.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            map.height.equalTo(self.view.frame.height/3)
        }
        conteinerView.snp.makeConstraints { container in
            container.centerX.equalTo(self.mapView.snp.centerX)
            container.centerY.equalTo(self.mapView.snp.bottom)
        }
        name.snp.makeConstraints { name in
            name.leading.equalTo(self.view.snp.leading).offset(10)
            name.top.equalTo(self.conteinerView.snp.bottom).offset(20)
        }
        detailPlace.snp.makeConstraints { detailPlace in
            detailPlace.leading.equalTo(self.view.snp.leading).offset(10)
            detailPlace.trailing.equalTo(self.view.snp.trailing).offset(-120)
            detailPlace.top.equalTo(self.name.snp.bottom).offset(3)
        }
        favouriteImage.snp.makeConstraints { favouriteImage in
            favouriteImage.leading.equalTo(self.name.snp.trailing).offset(10)
            favouriteImage.centerY.equalTo(self.name.snp.centerY)
        }
        place.snp.makeConstraints { place in
            place.centerY.equalTo(self.detailPlace.snp.centerY)
            place.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing).offset(-5)
        }
    }
}
