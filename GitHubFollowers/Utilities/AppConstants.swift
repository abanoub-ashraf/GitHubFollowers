import UIKit

struct AppConstants {
    
    // MARK: - AppAssets
    
    struct AppAssets {
        static let logo         = UIImage(named: "logo")
        static let emptyPage    = UIImage(named: "empty")
        static let avatarImage  = UIImage(named: "avatar")
    }
    
    // MARK: - API
    
    struct API {
        static let baseUrl = "https://api.github.com"
    }
    
    // MARK: - Cells
    
    struct CellIdentifiers {
        static let followerCellIdentifier = "FollowerCell"
    }
    
}
