import UIKit

enum ItemInfoType {
    case repos
    case gists
    case followers
    case following
}

class GFItemInfoView: UIView {

    // MARK: - UI

    let symbolImageView = UIImageView()
    let titleLabel      = GFTitleLabel(textAlignment: .left, fontSize: 16)
    let countLabel      = GFTitleLabel(textAlignment: .center, fontSize: 16)
    
    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions

    private func configure() {
        [symbolImageView, titleLabel, countLabel].forEach { subView in
            addSubview(subView)
        }
        
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        symbolImageView.contentMode = .scaleAspectFill
        symbolImageView.tintColor   = .label
        
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    ///
    /// configure this view with the 4 types of data it will be filled with insted of creating
    /// four views for that, using enum is way better and makes it reusable
    ///
    func set(itemInfoType: ItemInfoType, withCount count: Int) {
        switch itemInfoType {
            case .repos:
                symbolImageView.image   = UIImage(systemName: AppConstants.SFSymbols.reposSymbol)
                titleLabel.text         = "Public Repos"
            case .gists:
                symbolImageView.image   = UIImage(systemName: AppConstants.SFSymbols.gistsSymbol)
                titleLabel.text         = "Public Gists"
            case .followers:
                symbolImageView.image   = UIImage(systemName: AppConstants.SFSymbols.followersSymbol)
                titleLabel.text         = "Followers"
            case .following:
                symbolImageView.image   = UIImage(systemName: AppConstants.SFSymbols.followingSymbol)
                titleLabel.text         = "Following"
        }
        
        countLabel.text = String(count)
    }
}
