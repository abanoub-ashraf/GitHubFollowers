import UIKit

class GFAvatarImageView: UIImageView {
    
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
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius  = 16
        clipsToBounds       = true
        image               = AppConstants.AppAssets.avatarImage
    }
}
