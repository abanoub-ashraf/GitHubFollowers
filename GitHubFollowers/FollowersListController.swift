import UIKit

class FollowersListController: UIViewController {

    // MARK: - Properties

    var username: String!
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        ///
        /// set this to false cause it is set to true on the previous screen
        ///
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}
