import UIKit

class LandmarksTableViewCell: UITableViewCell {
    
    static let identifire = "landmarksTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var landmarkPreview: UIImageView = {
        let image = UIImageView()
        image.toAutoLayout()
        image.layer.cornerRadius = 25
        image.layer.masksToBounds = true
        return image
    }()
    
    private lazy var favouriteImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "star.fill"))
        image.toAutoLayout()
        image.tintColor = .systemYellow
        image.isHidden = true
        return image
    }()
    
    private lazy var landmarkName: UILabel = {
        let postTitle = UILabel()
        postTitle.toAutoLayout()
        postTitle.numberOfLines = 0
        postTitle.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return postTitle
    }()
    
    public func configureCell(title: String, imagePreview: String, isFavourite: Bool) {
        self.landmarkName.text = title
        
        self.landmarkPreview.image = UIImage(named: imagePreview)
        
        if isFavourite {
            self.favouriteImage.isHidden = false
        } else {
            self.favouriteImage.isHidden = true
        }
    }
    
    private func setupView() {
        let views: [UIView] = [
            landmarkPreview,
            landmarkName,
            favouriteImage
        ]
        contentView.addSubviews(views)
    }
    
    private func setupConstraints() {
        
        landmarkPreview.snp.makeConstraints { image in
            image.leading.equalTo(contentView.snp.leading).offset(5)
            image.centerY.equalTo(contentView.snp.centerY)
            image.size.equalTo(CGSize(width: 50, height: 50))
        }
        landmarkName.snp.makeConstraints { text in
            text.leading.equalTo(landmarkPreview.snp.trailing).offset(10)
            text.centerY.equalTo(contentView.snp.centerY)
        }
        favouriteImage.snp.makeConstraints { image in
            image.leading.equalTo(landmarkName.snp.trailing).offset(5)
            image.centerY.equalTo(contentView.snp.centerY)
        }
    }
}
