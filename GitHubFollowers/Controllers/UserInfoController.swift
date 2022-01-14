import UIKit

///
/// this protocol will establish a connection between this parent controller
/// and the 2 child controllers through their buttons
///
protocol UserInfoControllerDelegate: AnyObject {
    func didTapGithubProfile(for user: UserModel)
    func didTapGetFollowers(for user: UserModel)
}

class UserInfoController: UIViewController {
    
    // MARK: - UI

    let headerView          = UIView()
    let itemViewOne         = UIView()
    let itemViewTwo         = UIView()
    let dateLabel           = GFBodyLabel(textAlignment: .center)
    var itemViews: [UIView] = []
    
    // MARK: - Properties

    var username: String!
    
    weak var delegate: FollowersListControllerDelegate!

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUserInfo()
    }
    
    // MARK: - Helper Functions

    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(dismissController)
        )
        
        navigationItem.rightBarButtonItem = doneButton
        
        configureLayout()
    }
    
    private func configureLayout() {
        let padding: CGFloat    = 20
        let itemHeight: CGFloat = 140
        
        itemViews = [
            headerView,
            itemViewOne,
            itemViewTwo,
            dateLabel
        ]
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    ///
    /// this function is for adding a view controller to a view
    /// as a child view controller
    ///
    private func add(childViewController: UIViewController, to containerView: UIView) {
        ///
        /// - add the specified view controller as a child of the current view controller
        ///
        /// - add the view of the child view controller we added to the container view
        ///   of the current view controller
        ///
        /// - set the frame of the view of the view controller we added to be
        ///   the frame of its container
        ///
        /// - didMove() is for adding the child view controller to the current view controller
        ///
        addChild(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.frame = containerView.bounds
        childViewController.didMove(toParent: self)
    }
    
    private func populateUIFromServer(userData: UserModel) {
        let userInfoHeaderController            = GFUserInfoHeaderController(user: userData)
        
        ///
        /// confirm this class to be the one to respond to the execution of
        /// the functions of the delegate protocol above
        ///
        let repoItemChildController             = GFRepoItemController(user: userData)
        repoItemChildController.delegate        = self
        
        ///
        /// confirm this class to be the one to respond to the execution of
        /// the functions of the delegate protocol above
        ///
        let followerItemChildController         = GFFollowerItemController(user: userData)
        followerItemChildController.delegate    = self
        
        ///
        /// we will use the user info object we got from the server to populate
        /// the user info header controller then add that header controller to
        /// the header view we have in this current view controller
        ///
        self.add(
            childViewController: userInfoHeaderController,
            to: self.headerView
        )
        
        self.add(
            childViewController: repoItemChildController,
            to: self.itemViewOne
        )
        
        self.add(
            childViewController: followerItemChildController,
            to: self.itemViewTwo
        )
        
        self.dateLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        self.dateLabel.text = "On Github since: \(userData.createdAt.convertToDisplayFormat())"
    }
    
    private func fetchUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let userInfo):
                    ///
                    /// this ui stuff should happen in the main thread
                    ///
                    DispatchQueue.main.async {
                        self.populateUIFromServer(userData: userInfo)
                    }
                case .failure(let error):
                    self.presentGFAlertOnMainThread(
                        title: "Something went wrong",
                        message: error.rawValue,
                        buttonTitle: "OK"
                    )
            }
        }
    }
    
    // MARK: - Selectors

    @objc private func dismissController() {
        dismiss(animated: true)
    }
}

// MARK: - UserInfoControllerDelegate

extension UserInfoController: UserInfoControllerDelegate {
    ///
    /// show safari view controller of the profile of the user
    ///
    func didTapGithubProfile(for user: UserModel) {
        guard let url = URL(string: user.htmlUrl) else {
            self.presentGFAlertOnMainThread(
                title: "Invalid URL",
                message: "The URL attached to this User is Invalid",
                buttonTitle: "Ok"
            )
            return
        }
        
        self.presentSafariController(with: url)
    }
    
    ///
    /// - this function will dismiss this current controller,
    ///   then open the followers list controller to load the list of followers of the user we tapped
    ///   on its get followers button when we was on this current controller before it got dismissed
    ///
    /// - this will happen by establishing a delegation connection between this controller
    ///   and the followers list controller, when we tap on this function,
    ///   the delegate protocol function will fire and upon that the function of the delegate
    ///   inside the followers list controller will reset the followers list controller with the new username
    ///  of the new user we got from this controller when the delegate function was fired
    ///
    func didTapGetFollowers(for user: UserModel) {
        ///
        /// - if the user has no followers from this point then stop right here
        ///
        /// - there's no need to reset the followers list controller and do the network call
        ///   and see if the user has followers or not
        ///
        guard user.followers != 0 else {
            self.presentGFAlertOnMainThread(
                title: "No Followers",
                message: "This User has no Followers!",
                buttonTitle: "Ok"
            )
            return
        }
        
        delegate.didRequestFollowers(for: user.login)
        
        self.dismiss(animated: true)
    }
}
