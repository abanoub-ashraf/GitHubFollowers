import UIKit

class FollowerCell: UICollectionViewCell {
    
    // MARK: - Properties

    static let reuseID = AppConstants.CellIdentifiers.followerCellIdentifier
    
    let padding: CGFloat = 8
    
    // MARK: - UI

    let avatarImageView = GFAvatarImageView(frame: .zero)
    let usernameLabel   = GFTitleLabel(textAlignment: .center, fontSize: 16)
    
    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions

    private func configureLayout() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
        
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func set(follower: FollowerModel) {
        usernameLabel.text = follower.login
    }
}
