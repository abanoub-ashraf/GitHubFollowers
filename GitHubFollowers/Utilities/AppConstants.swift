import UIKit

struct AppConstants {
    
    // MARK: - API
    
    struct API {
        static let baseUrl = "https://api.github.com"
    }
    
    // MARK: - Cells
    
    struct CellIdentifiers {
        static let followerCellIdentifier = "FollowerCell"
    }
    
    // MARK: - Strings
    
    static let noFollowersMessage = "This user doesn't have any Followers, Go follow them 😄"
    
    // MARK: - SFSymbols
    
    enum SFSymbols {
        static let locationSymbol       = "mappin.and.ellipse"
        static let reposSymbol          = "folder"
        static let gistsSymbol          = "text.alignleft"
        static let followersSymbol      = "heart"
        static let followingSymbol      = "person.2"
    }
}
