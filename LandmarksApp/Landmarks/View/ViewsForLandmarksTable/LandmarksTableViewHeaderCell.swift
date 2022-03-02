import UIKit
import SnapKit

class LandmarksTableViewHeaderCell: UITableViewHeaderFooterView {
    
    static let idetifire = "landmarksTableViewHeaderCell"
    var switchChanged: ((Bool) -> Void)?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var headerName: UILabel = {
        let postTitle = UILabel()
        postTitle.toAutoLayout()
        postTitle.numberOfLines = 0
        postTitle.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return postTitle
    }()
    
    private lazy var favouriteSwitch: UISwitch = {
        let favouriteSwitch = UISwitch(frame:CGRect(x: 150, y: 150, width: 0, height: 0))
        favouriteSwitch.toAutoLayout()
        favouriteSwitch.addTarget(self, action: #selector(switchStateDidChange(_:)), for: .valueChanged)
        favouriteSwitch.setOn(false, animated: false)
        return favouriteSwitch
    }()
    
    private lazy var lineLabel: UILabel = {
        let label = UILabel()
        label.toAutoLayout()
        label.backgroundColor = .systemGray5
        return label
    }()
    
    @objc func switchStateDidChange(_ sender: UISwitch!) {
        switchChanged!(sender.isOn)
    }
    
    private func setupView() {
        let views: [UIView] = [
            headerName,
            favouriteSwitch,
            lineLabel
        ]
        contentView.addSubviews(views)
        contentView.backgroundColor = .white
        self.headerName.text = "Favorites only"
    }
    
    private func setupConstraints(){
        
        lineLabel.snp.makeConstraints { label in
            label.leading.equalTo(contentView.snp.leading)
            label.top.equalTo(contentView.snp.top)
            label.trailing.equalTo(contentView.snp.trailing)
            label.height.equalTo(1)
        }
        headerName.snp.makeConstraints { text in
            text.leading.equalTo(contentView.snp.leading).offset(10)
            text.centerY.equalTo(contentView.snp.centerY)
        }
        favouriteSwitch.snp.makeConstraints { sw in
            sw.trailing.equalTo(contentView.snp.trailing).offset(-10)
            sw.centerY.equalTo(contentView.snp.centerY)
        }
    }
}
