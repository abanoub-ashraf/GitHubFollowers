import UIKit

class FollowersListController: UIViewController {

    // MARK: - Properties

    var username: String!
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        getFollowersFromServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ///
        /// set this to false cause it is set to true on the previous screen
        ///
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Helper Functions

    private func getFollowersFromServer() {
        NetworkManager.shared.getFollowers(for: username, page: 1) { result in
            switch result {
                case .success(let followers):
                    print(followers)
                    
                case .failure(let error):
                    self.presentGFAlertOnMainThread(
                        title: "Bad Stuff Happened",
                        message: error.rawValue,
                        buttonTitle: "Ok"
                    )
            }
        }
    }

}
