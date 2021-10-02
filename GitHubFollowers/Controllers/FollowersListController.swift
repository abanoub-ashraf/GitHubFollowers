import UIKit

class FollowersListController: UIViewController {

    // MARK: - Properties

    var username: String!
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        NetworkManager.shared.getFollowers(for: username, page: 1) { followers, errorMessage in
            guard let followers = followers else {
                self.presentGFAlertOnMainThread(
                    title: "Bad Stuff Happened",
                    message: errorMessage!,
                    buttonTitle: "Ok"
                )
                
                return
            }
            
            print("Followers.count = \(followers.count)")
            print(followers)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ///
        /// set this to false cause it is set to true on the previous screen
        ///
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
