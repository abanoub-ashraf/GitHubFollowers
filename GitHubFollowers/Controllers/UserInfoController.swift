import UIKit

class UserInfoController: UIViewController {
    
    // MARK: - UI

    let headerView          = UIView()
    let itemViewOne         = UIView()
    let itemViewTwo         = UIView()
    let dateLabel           = GFBodyLabel(textAlignment: .center)
    var itemViews: [UIView] = []
    
    // MARK: - Properties

    var username: String!

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
        ///
        /// this ui stuff should happen in the main thread
        ///
        DispatchQueue.main.async {
            ///
            /// we will use the user info object we got from the server to populate
            /// the user info header controller then add that header controller to
            /// the header view we have in this current view controller
            ///
            self.add(
                childViewController: GFUserInfoHeaderController(user: userData),
                to: self.headerView
            )
            
            self.add(
                childViewController: GFRepoItemController(user: userData),
                to: self.itemViewOne
            )
            
            self.add(
                childViewController: GFFollowerItemController(user: userData),
                to: self.itemViewTwo
            )
            
            self.dateLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            self.dateLabel.text = "On Github since: \(userData.createdAt.convertToDisplayFormat())"
        }
    }
    
    private func fetchUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let userInfo):
                    self.populateUIFromServer(userData: userInfo)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Selectors

    @objc private func dismissController() {
        dismiss(animated: true)
    }
}
