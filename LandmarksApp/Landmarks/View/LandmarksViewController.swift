import UIKit
import CoreLocation

class LandmarksViewController: UIViewController {
    
    private let spinnerView = UIActivityIndicatorView(style: .large)
    private let viewModel: LandmarksViewModel
    
    init(viewModel: LandmarksViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                self.hideContent()
                self.spinnerView.startAnimating()
                
            case .loading:
                self.hideContent()
                self.spinnerView.startAnimating()
                
            case .loaded:
                self.spinnerView.stopAnimating()
                self.showContent()
                self.tableView.reloadData()
                
            case let .error(error):
                print(error)
            case .filterAsFavourite:
                self.tableView.reloadData()
            }
        }
    }
    
    private func hideContent() {
        UIView.animate(withDuration: 0.25) {
            self.tableView.alpha = 0
        }
    }
    
    private func showContent() {
        UIView.animate(withDuration: 0.25) {
            self.tableView.alpha = 1
        }
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "Landmarks"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.toAutoLayout()
        tableView.register(LandmarksTableViewCell.self, forCellReuseIdentifier: LandmarksTableViewCell.identifire)
        tableView.register(LandmarksTableViewHeaderCell.self, forHeaderFooterViewReuseIdentifier: LandmarksTableViewHeaderCell.idetifire)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = .zero
        return tableView
    }()
    
    private func setupConstraints() {
        let views: [UIView] = [
            tableView,
            spinnerView
        ]
        view.addSubviews(views)
        
        spinnerView.snp.makeConstraints { spiner in
            spiner.centerX.equalTo(self.view.safeAreaLayoutGuide.snp.centerX)
            spiner.centerY.equalTo(self.view.safeAreaLayoutGuide.snp.centerY)
        }
        tableView.snp.makeConstraints { table in
            table.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            table.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            table.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            table.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func switcherState(isActive: Bool) {
        viewModel.send(.switchChanged(isActive))
    }
}

extension LandmarksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.resultsArrayFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LandmarksTableViewCell.identifire, for: indexPath) as? LandmarksTableViewCell else { fatalError() }
        cell.accessoryType = .disclosureIndicator
        cell.configureCell(title: viewModel.resultsArrayFiltered[indexPath.row].name,
                           imagePreview: viewModel.resultsArrayFiltered[indexPath.row].imageName,
                           isFavourite: viewModel.resultsArrayFiltered[indexPath.row].isFavorite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                                                                    LandmarksTableViewHeaderCell.idetifire) as? LandmarksTableViewHeaderCell else { fatalError() }
        view.switchChanged = switcherState(isActive:)
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

extension LandmarksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.send(.tapCell(indexPath))
    }
}
